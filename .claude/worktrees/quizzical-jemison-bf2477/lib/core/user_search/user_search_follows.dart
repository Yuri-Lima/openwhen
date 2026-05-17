import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';

/// Batches `follows` reads (Firestore `whereIn` max 10 per query).
Future<Set<String>> fetchFollowingUidsForTargets({
  required FirebaseFirestore firestore,
  required String followerUid,
  required Iterable<String> targetUids,
}) async {
  final list = targetUids.toList();
  if (list.isEmpty) return {};
  final out = <String>{};
  const chunk = 10;
  for (var i = 0; i < list.length; i += chunk) {
    final part = list.sublist(i, math.min(i + chunk, list.length));
    final snap = await firestore
        .collection('follows')
        .where('followerUid', isEqualTo: followerUid)
        .where('followingUid', whereIn: part)
        .get();
    for (final d in snap.docs) {
      final m = d.data();
      final uid = m['followingUid'] as String?;
      if (uid != null) out.add(uid);
    }
  }
  return out;
}
