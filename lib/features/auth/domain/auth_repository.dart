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

    await _firestore.collection(FirestoreCollections.users).doc(user.uid).set({
      'uid': user.uid,
      'name': name,
      'displayName': name,
      'username': username,
      'searchTokens': searchTokens,
      'email': email,
      'photoUrl': null,
      'bio': null,
      'isPrivate': false,
      'createdAt': Timestamp.now(),
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
    });

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
  /// Creates a Firestore user document on first login.
  /// [dateOfBirth] is collected from the age-gate dialog for new users.
  Future<void> signInWithApple({required DateTime dateOfBirth}) async {
    final credential = await _authService.signInWithApple();
    final user = credential.user!;
    final isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

    if (isNewUser) {
      final name = user.displayName ?? '';
      final email = user.email ?? '';
      final username = await _resolveUsername(name, user.uid);

      final searchTokens = buildUserSearchTokens(
        username: username,
        displayName: name,
        name: name,
      );

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'displayName': name,
        'username': username,
        'searchTokens': searchTokens,
        'email': email,
        'photoUrl': null,
        'bio': null,
        'isPrivate': false,
        'createdAt': Timestamp.now(),
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
      });
    }
    // Fire-and-forget: Marco Civil Art. 15 access log.
    AccessLogService.logLogin(authMethod: 'apple');
  }

  /// Sign in (or sign up) with Google.
  /// Creates a Firestore user document on first login.
  /// [dateOfBirth] is collected from the age-gate dialog for new users.
  Future<void> signInWithGoogle({required DateTime dateOfBirth}) async {
    final credential = await _authService.signInWithGoogle();
    final user = credential.user!;
    final isNewUser = credential.additionalUserInfo?.isNewUser ?? false;

    if (isNewUser) {
      final name = user.displayName ?? '';
      final email = user.email ?? '';
      final username = await _resolveUsername(name, user.uid);

      final searchTokens = buildUserSearchTokens(
        username: username,
        displayName: name,
        name: name,
      );

      await _firestore
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .set({
        'uid': user.uid,
        'name': name,
        'displayName': name,
        'username': username,
        'searchTokens': searchTokens,
        'email': email,
        'photoUrl': user.photoURL,
        'bio': null,
        'isPrivate': false,
        'createdAt': Timestamp.now(),
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
      });
    }
    // Fire-and-forget: Marco Civil Art. 15 access log.
    AccessLogService.logLogin(authMethod: 'google');
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
    } catch (_) {
      return false;
    }
  }
}
