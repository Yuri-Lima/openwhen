import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/firestore_collections.dart';

/// Batch size for paginated export queries.
const _exportBatchSize = 500;

/// Fetches letter documents the signed-in user may export: only participations
/// (sent or received), opened — no other users' private mail.
///
/// Uses paginated batches to avoid loading an unbounded number of documents
/// into memory at once.
Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> fetchLettersForUserExport({
  required FirebaseFirestore firestore,
  required String uid,
}) async {
  final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

  // Fetch sent letters in batches
  await _fetchAllInBatches(
    query: firestore
        .collection(FirestoreCollections.letters)
        .where('senderUid', isEqualTo: uid)
        .where('status', isEqualTo: 'opened')
        .orderBy(FieldPath.documentId),
    into: byId,
  );

  // Fetch received letters in batches
  await _fetchAllInBatches(
    query: firestore
        .collection(FirestoreCollections.letters)
        .where('receiverUid', isEqualTo: uid)
        .where('status', isEqualTo: 'opened')
        .orderBy(FieldPath.documentId),
    into: byId,
  );

  return byId.values.toList();
}

/// Fetches all documents matching [query] in batches of [_exportBatchSize],
/// deduplicating by document ID into [into].
Future<void> _fetchAllInBatches({
  required Query<Map<String, dynamic>> query,
  required Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> into,
}) async {
  DocumentSnapshot? lastDoc;
  while (true) {
    var page = query.limit(_exportBatchSize);
    if (lastDoc != null) {
      page = page.startAfterDocument(lastDoc);
    }
    final snap = await page.get();
    for (final d in snap.docs) {
      into[d.id] = d;
    }
    if (snap.docs.length < _exportBatchSize) break;
    lastDoc = snap.docs.last;
  }
}
