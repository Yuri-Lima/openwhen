import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/firestore_collections.dart';

/// Merge docs from sender query and collective-participant query (dedupe by id).
List<QueryDocumentSnapshot<Map<String, dynamic>>> mergeLockedCapsuleVaultDocs(
  QuerySnapshot<Map<String, dynamic>>? senderSnap,
  QuerySnapshot<Map<String, dynamic>>? participantSnap,
) {
  final map = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};
  for (final d in senderSnap?.docs ?? []) {
    map[d.id] = d;
  }
  for (final d in participantSnap?.docs ?? []) {
    map[d.id] = d;
  }
  return map.values.toList();
}

/// Stream: locked capsules where user is sender (covers legacy + personal).
Stream<QuerySnapshot<Map<String, dynamic>>> lockedCapsulesSenderStream(String uid) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.capsules)
      .where('senderUid', isEqualTo: uid)
      .where('status', isEqualTo: 'locked')
      .snapshots();
}

/// Stream: locked collective capsules where user is participant (invitee).
Stream<QuerySnapshot<Map<String, dynamic>>> lockedCapsulesCollectiveParticipantStream(
  String uid,
) {
  return FirebaseFirestore.instance
      .collection(FirestoreCollections.capsules)
      .where('participantUids', arrayContains: uid)
      .where('status', isEqualTo: 'locked')
      .where('isCollective', isEqualTo: true)
      .snapshots();
}
