import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/feed_config.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../domain/feed_sort.dart';

/// Splits [items] into lists of at most [chunkSize] (Firestore `whereIn` limit).
List<List<T>> chunkList<T>(List<T> items, int chunkSize) {
  if (chunkSize <= 0) return [items];
  final out = <List<T>>[];
  for (var i = 0; i < items.length; i += chunkSize) {
    final end = i + chunkSize > items.length ? items.length : i + chunkSize;
    out.add(items.sublist(i, end));
  }
  return out;
}

/// Reactive merged list of public opened letters from people [followerUid] follows.
///
/// Each chunk uses a separate Firestore snapshot listener; results are merged and
/// sorted by [openedAt] descending.
Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> followingFeedMergedStream({
  required FirebaseFirestore firestore,
  required String followerUid,
  required Timestamp openedAtMin,
}) {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? followsSub;
  final letterSubs = <StreamSubscription<QuerySnapshot<Map<String, dynamic>>>>[];

  void cancelLetterSubs() {
    for (final s in letterSubs) {
      s.cancel();
    }
    letterSubs.clear();
  }

  void cancelAll() {
    followsSub?.cancel();
    followsSub = null;
    cancelLetterSubs();
  }

  late final StreamController<List<QueryDocumentSnapshot<Map<String, dynamic>>>> controller;
  controller = StreamController<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
    onListen: () {
      followsSub = firestore
          .collection('follows')
          .where('followerUid', isEqualTo: followerUid)
          .snapshots()
          .listen(
        (followSnap) {
          cancelLetterSubs();
          final uids = followSnap.docs
              .map((d) => d.data()['followingUid'] as String?)
              .whereType<String>()
              .where((u) => u.isNotEmpty)
              .toList();
          if (uids.isEmpty) {
            controller.add([]);
            return;
          }
          final chunks = chunkList(uids, 10);
          final chunkDocIds = List<Set<String>>.generate(chunks.length, (_) => {});
          final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};

          void emitMerged() {
            final list = byId.values.toList()..sort(compareLettersByOpenedAtDesc);
            controller.add(list);
          }

          for (var ci = 0; ci < chunks.length; ci++) {
            final chunk = chunks[ci];
            final q = firestore
                .collection(FirestoreCollections.letters)
                .where('isPublic', isEqualTo: true)
                .where('status', isEqualTo: 'opened')
                .where('senderUid', whereIn: chunk)
                .where('openedAt', isGreaterThanOrEqualTo: openedAtMin)
                .orderBy('openedAt', descending: true)
                .limit(FeedConfig.publicMaxDocuments);

            final sub = q.snapshots().listen(
              (snap) {
                for (final id in chunkDocIds[ci]) {
                  byId.remove(id);
                }
                chunkDocIds[ci].clear();
                for (final d in snap.docs) {
                  byId[d.id] = d;
                  chunkDocIds[ci].add(d.id);
                }
                emitMerged();
              },
              onError: controller.addError,
            );
            letterSubs.add(sub);
          }
        },
        onError: controller.addError,
      );
    },
    onCancel: cancelAll,
  );

  return controller.stream;
}
