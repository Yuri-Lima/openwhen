import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'deletion_request_service.dart';
import 'safe_callable.dart';

/// Deletion mode chosen by the user.
enum DeletionMode {
  /// Remove every document & file owned by the user.
  deleteAll,

  /// Keep letters/capsules but strip PII; delete everything else.
  anonymize,
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
