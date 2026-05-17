import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../constants/firestore_collections.dart';

/// GDPR Art. 18 — Right to Restriction of Processing.
///
/// When restricted:
/// - User data is kept in storage but not processed.
/// - `accountStatus` is set to `restricted`.
/// - `canSendContent` returns false (no new letters, capsules, comments, likes).
/// - User can still log in, view their data, and export it.
/// - User can lift the restriction at any time.
///
/// This is distinct from account deletion (which removes data) and from
/// a `pending_deletion` state (which has a scheduled deletion date).
class ProcessingRestrictionService {
  ProcessingRestrictionService._();

  /// Request restriction of processing for the current user.
  static Future<void> restrictProcessing() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({
      'accountStatus': 'restricted',
      'restrictionRequestedAt': FieldValue.serverTimestamp(),
    });

    debugPrint('ProcessingRestrictionService: account restricted');
  }

  /// Lift the processing restriction (resume normal processing).
  static Future<void> liftRestriction() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({
      'accountStatus': 'active',
      'restrictionRequestedAt': FieldValue.delete(),
    });

    debugPrint('ProcessingRestrictionService: restriction lifted');
  }
}
