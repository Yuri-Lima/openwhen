import 'package:cloud_firestore/cloud_firestore.dart';

import 'feed_letter_filter.dart';

/// Splits [ids] into lists of at most [chunkSize] (Firestore `whereIn` limit).
List<List<String>> chunkIds(List<String> ids, {int chunkSize = 10}) {
  if (ids.isEmpty) return [];
  final out = <List<String>>[];
  for (var i = 0; i < ids.length; i += chunkSize) {
    out.add(ids.sublist(i, i + chunkSize > ids.length ? ids.length : i + chunkSize));
  }
  return out;
}

/// Merges letter docs from parallel `whereIn` chunks: dedupe by id, filter by
/// [openedAtMin], [blockedSenderUids], sort by `openedAt` descending.
List<QueryDocumentSnapshot<Map<String, dynamic>>> mergeFollowChunkSnapshots({
  required Iterable<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs,
  required Timestamp openedAtMin,
  required Set<String> blockedSenderUids,
}) {
  final byId = <String, QueryDocumentSnapshot<Map<String, dynamic>>>{};
  for (final d in allDocs) {
    final data = d.data();
    final openedAt = data['openedAt'] as Timestamp?;
    if (openedAt == null || openedAt.compareTo(openedAtMin) < 0) continue;
    if (!isFeedLetterVisibleForViewer(
      letterData: data,
      blockedSenderUids: blockedSenderUids,
    )) {
      continue;
    }
    byId[d.id] = d;
  }
  final list = byId.values.toList();
  list.sort((a, b) {
    final ta = a.data()['openedAt'] as Timestamp?;
    final tb = b.data()['openedAt'] as Timestamp?;
    if (ta == null && tb == null) return 0;
    if (ta == null) return 1;
    if (tb == null) return -1;
    return tb.compareTo(ta);
  });
  return list;
}

/// Destaques: sort by engagement (`likeCount` desc), then `openedAt` desc.
List<QueryDocumentSnapshot<Map<String, dynamic>>> sortByLikeCountThenOpenedAt(
  List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
  int maxItems = 50,
}) {
  final copy = List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(docs);
  copy.sort((a, b) {
    final la = (a.data()['likeCount'] as num?)?.toInt() ?? 0;
    final lb = (b.data()['likeCount'] as num?)?.toInt() ?? 0;
    if (lb != la) return lb.compareTo(la);
    final ta = a.data()['openedAt'] as Timestamp?;
    final tb = b.data()['openedAt'] as Timestamp?;
    if (ta == null && tb == null) return 0;
    if (ta == null) return 1;
    if (tb == null) return -1;
    return tb.compareTo(ta);
  });
  if (copy.length <= maxItems) return copy;
  return copy.sublist(0, maxItems);
}
