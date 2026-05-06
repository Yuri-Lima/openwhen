import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/auth_service.dart';
import '../models/app_user.dart';
import '../../../core/constants/firestore_collections.dart';
import '../../../core/billing/subscription_tier.dart';
import '../../../core/services/fcm_token_manager.dart';
import '../../../core/services/safe_callable.dart';
import '../../../core/user_search/user_search_tokens.dart';
import '../../../core/services/access_log_service.dart';
import '../../../core/policy/policy_constants.dart';
import '../../../core/utils/firebase_locale_helper.dart';
import '../../../core/utils/username_generator.dart';

class AuthRepository {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _authService.authStateChanges;

  User? get currentUser => _authService.currentUser;

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String username,
    required DateTime dateOfBirth,
  }) async {
    final credential = await _authService.registerWithEmail(
      email: email,
      password: password,
    );

    final user = credential.user!;
    final searchTokens = buildUserSearchTokens(
      username: username,
      displayName: name,
      name: name,
    );

    // Batch atómico: reserva o username E cria o user doc ao mesmo tempo.
    // Se o username já estiver reservado, o batch inteiro falha (Security
    // Rules só permitem `create` em usernames/{id}, nunca `update`).
    final batch = _firestore.batch();

    batch.set(
      _firestore.collection(FirestoreCollections.usernames).doc(username),
      {'uid': user.uid},
    );

    batch.set(
      _firestore.collection(FirestoreCollections.users).doc(user.uid),
      {
        'uid': user.uid,
        'name': name,
        'displayName': name,
        'username': username,
        'searchTokens': searchTokens,
        'email': email,
        'photoUrl': null,
        'bio': null,
        'isPrivate': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lettersSentCount': 0,
        'lettersReceivedCount': 0,
        'lockedLettersCount': 0,
        'openedLettersCount': 0,
        'followersCount': 0,
        'followingCount': 0,
        'lettersCount': 0,
        'language': 'pt-BR',
        'preferredLanguage': 'pt',
        'country': null,
        'subscriptionTier': subscriptionTierId(SubscriptionTier.free),
        'hasCompletedFirstAction': false,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
        'acceptedTermsVersion': kCurrentTermsVersion,
        'acceptedPrivacyVersion': kCurrentPrivacyVersion,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
      },
    );

    try {
      await batch.commit();
    } catch (e) {
      // Username já reservado ou outro erro — apagar o auth user orphan.
      debugPrint('[AuthRepo] register batch failed, deleting auth user: $e');
      await user.delete();
      rethrow;
    }

    // Send email verification — required before first login.
    await applyFirebaseLocale();
    await user.sendEmailVerification();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    await _authService.loginWithEmail(email: email, password: password);
    // Fire-and-forget: Marco Civil Art. 15 access log.
    AccessLogService.logLogin(authMethod: 'email');
  }

  /// Sign in (or sign up) with Apple.
  /// Returns `true` when the user is new and still needs to complete
  /// registration (age-gate + terms). The caller should then collect
  /// `dateOfBirth` and call [completeOAuthRegistration].
  Future<bool> signInWithApple() async {
    final credential = await _authService.signInWithApple();
    final needsSetup = await _needsRegistration(credential);

    // Fire-and-forget: Marco Civil Art. 15 access log.
    AccessLogService.logLogin(authMethod: 'apple');
    return needsSetup;
  }

  /// Sign in (or sign up) with Google.
  /// Returns `true` when the user is new and still needs to complete
  /// registration (age-gate + terms). The caller should then collect
  /// `dateOfBirth` and call [completeOAuthRegistration].
  Future<bool> signInWithGoogle() async {
    final credential = await _authService.signInWithGoogle();
    final needsSetup = await _needsRegistration(credential);

    // Fire-and-forget: Marco Civil Art. 15 access log.
    AccessLogService.logLogin(authMethod: 'google');
    return needsSetup;
  }

  /// Returns `true` if the user still needs to complete registration.
  /// Handles both genuinely new users AND edge cases where the Auth
  /// account exists but the Firestore user doc was lost (e.g. previous
  /// registration crashed, manual deletion, etc.).
  Future<bool> _needsRegistration(UserCredential credential) async {
    if (credential.additionalUserInfo?.isNewUser ?? false) return true;

    // Auth account exists — verify the Firestore doc is also present.
    final uid = credential.user!.uid;
    final doc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(uid)
        .get();
    return !doc.exists;
  }

  /// Completes registration for a new OAuth user by creating the Firestore
  /// user document. Must be called after [signInWithApple] or
  /// [signInWithGoogle] returns `true`.
  Future<void> completeOAuthRegistration({
    required DateTime dateOfBirth,
  }) async {
    final user = _authService.currentUser;
    if (user == null) {
      throw StateError('completeOAuthRegistration called without a signed-in user');
    }
    await _createOAuthUserDoc(
      user: user,
      dateOfBirth: dateOfBirth,
      photoUrl: user.photoURL,
    );
  }

  /// Cria user doc + reserva de username para signup via OAuth (Apple/Google).
  /// Usa batch atómico — se o username já estiver reservado, tenta
  /// outro candidato automaticamente via [_resolveUsername].
  Future<void> _createOAuthUserDoc({
    required User user,
    required DateTime dateOfBirth,
    String? photoUrl,
  }) async {
    final name = user.displayName ?? '';
    final email = user.email ?? '';
    final username = await _resolveUsername(name, user.uid);

    final searchTokens = buildUserSearchTokens(
      username: username,
      displayName: name,
      name: name,
    );

    final batch = _firestore.batch();

    batch.set(
      _firestore.collection(FirestoreCollections.usernames).doc(username),
      {'uid': user.uid},
    );

    batch.set(
      _firestore.collection(FirestoreCollections.users).doc(user.uid),
      {
        'uid': user.uid,
        'name': name,
        'displayName': name,
        'username': username,
        'searchTokens': searchTokens,
        'email': email,
        'photoUrl': photoUrl,
        'bio': null,
        'isPrivate': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lettersSentCount': 0,
        'lettersReceivedCount': 0,
        'lockedLettersCount': 0,
        'openedLettersCount': 0,
        'followersCount': 0,
        'followingCount': 0,
        'lettersCount': 0,
        'language': 'pt-BR',
        'preferredLanguage': 'pt',
        'country': null,
        'subscriptionTier': subscriptionTierId(SubscriptionTier.free),
        'hasCompletedFirstAction': false,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
        'acceptedTermsVersion': kCurrentTermsVersion,
        'acceptedPrivacyVersion': kCurrentPrivacyVersion,
        'termsAcceptedAt': FieldValue.serverTimestamp(),
      },
    );

    try {
      await batch.commit();
    } catch (e) {
      // Username já reservado ou outro erro — apagar o auth user orphan.
      debugPrint('[AuthRepo] OAuth batch failed, deleting auth user: $e');
      await user.delete();
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await FcmTokenManager.clearToken();
    } catch (e, st) {
      debugPrint('FcmTokenManager.clearToken failed (sign-out continues): $e\n$st');
    }
    await _authService.signOut();
  }

  Future<void> sendVerificationEmail() async {
    await applyFirebaseLocale();
    await _authService.currentUser?.sendEmailVerification();
  }

  Future<AppUser?> getUser(String uid) async {
    final doc = await _firestore.collection(FirestoreCollections.users).doc(uid).get();
    if (!doc.exists) return null;
    return AppUser.fromFirestore(doc);
  }

  /// Picks a unique, human-readable username for a new OAuth user.
  ///
  /// Tries pretty variants of [displayName] first (accent-stripped, with dot
  /// or underscore separators), then a numeric-suffix retry, then a uid-based
  /// fallback. Sign-up never fails on this step.
  Future<String> _resolveUsername(String displayName, String uid) async {
    final suggestions = displayName.trim().isNotEmpty
        ? generateUsernameSuggestions(displayName)
        : <String>[];

    for (final candidate in suggestions) {
      if (await _isUsernameAvailable(candidate)) return candidate;
    }

    final rawBase = suggestions.isNotEmpty
        ? suggestions.first.replaceAll(RegExp(r'[^a-z0-9]'), '')
        : 'user';
    // Cap base at 16 chars so base + 4-digit suffix stays within the 20-char limit.
    final base = rawBase.length > 16 ? rawBase.substring(0, 16) : rawBase;
    final rand = Random();
    for (var i = 0; i < 5; i++) {
      final candidate = '$base${1000 + rand.nextInt(9000)}';
      if (validateUsername(candidate) != null) continue;
      if (await _isUsernameAvailable(candidate)) return candidate;
    }

    return 'user${uid.substring(0, 8).toLowerCase()}';
  }

  Future<bool> _isUsernameAvailable(String username) async {
    try {
      final result = await SafeCallable.call(
        'checkUsernameAvailable',
        data: {'username': username},
        label: 'checkUsernameAvailable',
      );
      final data = result.data;
      return data is Map && data['available'] == true;
    } catch (e) {
      debugPrint('[AuthRepo] username availability check failed: $e');
      // On error (network/App Check), assume available — the server-side
      // registration will enforce uniqueness anyway.
      return true;
    }
  }
}
