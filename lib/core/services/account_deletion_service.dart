import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'deletion_request_service.dart';
import 'safe_callable.dart';

/// Deletion mode chosen by the user.
enum DeletionMode {
  /// Remove every document & file owned by the user.
  deleteAll,

  /// Keep letters/capsules but strip PII; delete everything else.
  anonymize,
}

/// The sign-in provider the current user authenticated with.
enum AuthProvider {
  password,
  google,
  apple,
  unknown,
}

/// Handles the full account-deletion flow.
///
/// **New flow (soft delete with 15-day grace period):**
///   1. Re-authenticate (required by Firebase)
///   2. Export user data (best-effort, sent via email)
///   3. Request soft delete (marks account as `pending_deletion`)
///   4. Sign out locally
///
/// The actual deletion happens via a scheduled Cloud Function after 15 days.
/// The user can cancel during this period via [DeletionRequestService.cancelDeletion].
///
/// **Legacy flow (immediate deletion):**
///   Still available via [requestImmediateDeletion] for admin use or fallback.
class AccountDeletionService {
  AccountDeletionService._();

  /// Detect the primary auth provider for the current user.
  ///
  /// Prioritises social providers over password because Firebase's
  /// [User.providerData] order is not guaranteed. A user who linked
  /// both Google and password will get [AuthProvider.google].
  static AuthProvider currentAuthProvider() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return AuthProvider.unknown;

    AuthProvider? social;
    AuthProvider? pass;
    for (final info in user.providerData) {
      if (info.providerId == 'apple.com') return AuthProvider.apple;
      if (info.providerId == 'google.com') social = AuthProvider.google;
      if (info.providerId == 'password') pass = AuthProvider.password;
    }
    return social ?? pass ?? AuthProvider.unknown;
  }

  /// Re-authenticate using the appropriate provider.
  /// For password users, [password] must be provided.
  /// For social users, the native sign-in flow is triggered.
  /// Returns `null` on success, or an error code string on failure.
  static Future<String?> reauthenticate({String? password}) async {
    final provider = currentAuthProvider();
    switch (provider) {
      case AuthProvider.password:
        if (password == null || password.isEmpty) return 'no_password';
        return reauthenticateWithPassword(password);
      case AuthProvider.google:
        return _reauthenticateWithGoogle();
      case AuthProvider.apple:
        return _reauthenticateWithApple();
      case AuthProvider.unknown:
        return 'unknown_provider';
    }
  }

  /// Re-authenticate the current user with email + password.
  /// Returns `null` on success, or an error message string on failure.
  static Future<String?> reauthenticateWithPassword(String password) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'no_user';
      if (user.email == null) return 'no_email';

      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
      return null; // success
    } on FirebaseAuthException catch (e) {
      debugPrint('Reauth failed: ${e.code} ${e.message}');
      return e.code;
    } catch (e) {
      debugPrint('Reauth unexpected error: $e');
      return e.toString();
    }
  }

  /// Re-authenticate the current user with Google sign-in.
  static Future<String?> _reauthenticateWithGoogle() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'no_user';

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return 'cancelled';

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await user.reauthenticateWithCredential(credential);
      return null; // success
    } on FirebaseAuthException catch (e) {
      debugPrint('Google reauth failed: ${e.code} ${e.message}');
      return e.code;
    } catch (e) {
      debugPrint('Google reauth unexpected error: $e');
      if (e.toString().contains('google-sign-in-cancelled')) return 'cancelled';
      return e.toString();
    }
  }

  /// Re-authenticate the current user with Apple sign-in.
  static Future<String?> _reauthenticateWithApple() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return 'no_user';

      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );
      await user.reauthenticateWithCredential(oauthCredential);
      return null; // success
    } on SignInWithAppleAuthorizationException catch (e) {
      debugPrint('Apple reauth cancelled: ${e.code}');
      return 'cancelled';
    } on FirebaseAuthException catch (e) {
      debugPrint('Apple reauth failed: ${e.code} ${e.message}');
      return e.code;
    } catch (e) {
      debugPrint('Apple reauth unexpected error: $e');
      return e.toString();
    }
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// **New flow:** Exports data and requests soft deletion with 15-day grace.
  ///
  /// Steps:
  ///   1. Trigger server-side data export (email with download link)
  ///   2. Mark account as `pending_deletion`
  ///
  /// Returns the scheduled deletion date.
  /// Export failures are logged but don't block the deletion request.
  static Future<DateTime> requestSoftDeletion(DeletionMode mode) async {
    final modeStr = mode == DeletionMode.deleteAll ? 'delete_all' : 'anonymize';

    // Step 1: Export data (best-effort — don't block right to erasure)
    try {
      await DeletionRequestService.exportUserData();
    } catch (e) {
      debugPrint('Data export before deletion failed (non-blocking): $e');
    }

    // Step 2: Request soft delete with grace period
    return DeletionRequestService.requestDeletion(modeStr);
  }

  /// **Legacy flow:** Calls the `deleteUserAccount` Cloud Function directly
  /// for immediate deletion. Kept for admin use or fallback scenarios.
  ///
  /// Throws on failure so the caller can show an error.
  static Future<void> requestImmediateDeletion(DeletionMode mode) async {
    final modeStr = mode == DeletionMode.deleteAll ? 'delete_all' : 'anonymize';

    await SafeCallable.call(
      'deleteUserAccount',
      data: {'mode': modeStr},
      label: 'deleteUserAccount',
    );
  }
}
