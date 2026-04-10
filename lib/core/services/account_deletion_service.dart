import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'callable_queue.dart';

/// Deletion mode chosen by the user.
enum DeletionMode {
  /// Remove every document & file owned by the user.
  deleteAll,

  /// Keep letters/capsules but strip PII; delete everything else.
  anonymize,
}

/// Handles the full account-deletion flow:
///   1. Re-authenticate (required by Firebase before deleting auth)
///   2. Call the `deleteUserAccount` Cloud Function
///
/// Usage from UI:
/// ```dart
/// final result = await AccountDeletionService.reauthenticateWithPassword(password);
/// if (result == null) {
///   await AccountDeletionService.requestDeletion(DeletionMode.deleteAll);
/// }
/// ```
class AccountDeletionService {
  AccountDeletionService._();

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
      return e.code; // e.g. 'wrong-password', 'too-many-requests'
    } catch (e) {
      debugPrint('Reauth unexpected error: $e');
      return e.toString();
    }
  }

  /// Calls the `deleteUserAccount` Cloud Function.
  /// The function handles all server-side cleanup (Firestore, Storage, Stripe, Auth).
  ///
  /// Throws on failure so the caller can show an error.
  static Future<void> requestDeletion(DeletionMode mode) async {
    final modeStr = mode == DeletionMode.deleteAll ? 'delete_all' : 'anonymize';

    await CallableQueue.enqueue(
      () => FirebaseFunctions.instance
          .httpsCallable('deleteUserAccount')
          .call({'mode': modeStr}),
      label: 'deleteUserAccount',
    );
  }
}
