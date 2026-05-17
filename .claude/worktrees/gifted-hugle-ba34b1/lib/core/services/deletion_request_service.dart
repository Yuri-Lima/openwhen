import 'package:flutter/foundation.dart';
import 'safe_callable.dart';

/// Client-side service for the soft-delete account lifecycle.
///
/// Flow:
///   1. [exportUserData] — generates and emails a data export
///   2. [requestDeletion] — marks account as `pending_deletion` (15-day grace)
///   3. [cancelDeletion]  — reverts to `active` during the grace period
///
/// The actual deletion is executed by the scheduled Cloud Function
/// `processScheduledDeletions` after the grace period expires.
class DeletionRequestService {
  DeletionRequestService._();

  /// Triggers the server-side data export. Returns the signed download URL.
  ///
  /// The export is best-effort: if it fails, the user can still proceed with
  /// the deletion request (right to erasure cannot be blocked by export failure).
  static Future<String?> exportUserData() async {
    try {
      final result = await SafeCallable.call(
        'exportUserData',
        label: 'exportUserData',
      );
      final data = result.data as Map?;
      return data?['downloadUrl'] as String?;
    } catch (e) {
      debugPrint('DeletionRequestService.exportUserData failed: $e');
      return null;
    }
  }

  /// Requests account deletion with a 15-day grace period.
  ///
  /// [mode] must be `delete_all` or `anonymize`.
  ///
  /// Returns the scheduled deletion date on success, or throws on failure.
  static Future<DateTime> requestDeletion(String mode) async {
    final result = await SafeCallable.call(
      'requestAccountDeletion',
      data: {'mode': mode},
      label: 'requestAccountDeletion',
    );
    final data = result.data as Map;
    final scheduledFor = data['scheduledFor'] as String;
    return DateTime.parse(scheduledFor);
  }

  /// Cancels a pending deletion request, reverting the account to active.
  ///
  /// Throws if the account is not in `pending_deletion` state.
  static Future<void> cancelDeletion() async {
    await SafeCallable.call(
      'cancelAccountDeletion',
      label: 'cancelAccountDeletion',
    );
  }
}
