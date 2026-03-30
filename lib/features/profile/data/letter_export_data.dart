import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/firestore_collections.dart';

/// Fetches letter documents the signed-in user may export: only participations
/// (sent or received), opened — no other users’ private mail.
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchLettersForUserExport({
  required FirebaseFirestore firestore,
  required String uid,
}) async {
  final sent = await firestore
      .collection(FirestoreCollections.letters)
      .where('senderUid', isEqualTo: uid)
      .where('status', isEqualTo: 'opened')
      .get();
  final received = await firestore
      .collection(FirestoreCollections.letters)
      .where('receiverUid', isEqualTo: uid)
      .where('status', isEqualTo: 'opened')
      .get();

  final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};
  for (final d in sent.docs) {
    byId[d.id] = d;
  }
  for (final d in received.docs) {
    byId[d.id] = d;
  }
  return byId.values.toList();
}
