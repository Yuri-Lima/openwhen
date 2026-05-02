import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../constants/firestore_collections.dart';

/// Best-effort logging of privacy-related actions (export, deletion, etc.)
/// to the `privacyRequestLogs` Firestore collection.
class PrivacyLogService {
  PrivacyLogService._();

  static Future<void> logExport({
    required String uid,
    required int letterCount,
    required bool success,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.privacyRequestLogs)
          .add({
        'uid': uid,
        'type': 'export',
        'status': success ? 'completed' : 'failed',
        'metadata': {'letterCount': letterCount},
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'client',
      });
    } catch (e) {
      debugPrint('PrivacyLogService.logExport failed (best-effort): $e');
    }
  }

  /// Logs a complete data export (GDPR Art. 20 / LGPD Art. 18).
  static Future<void> logCompleteExport({
    required String uid,
    required Map<String, int> metadata,
    required bool success,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.privacyRequestLogs)
          .add({
        'uid': uid,
        'type': 'complete_export',
        'status': success ? 'completed' : 'failed',
        'metadata': metadata,
        'createdAt': FieldValue.serverTimestamp(),
        'source': 'client',
      });
    } catch (e) {
      debugPrint('PrivacyLogService.logCompleteExport failed (best-effort): $e');
    }
  }
}
