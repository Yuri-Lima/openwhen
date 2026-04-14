import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../auth/models/app_user.dart';

/// Cursor-based paginator for the followers / following list.
///
/// Uses `startAfterDocument` on `createdAt DESC` so each page is a single
/// Firestore query (≤ [pageSize] docs).  User profiles are fetched in
/// `whereIn` chunks of 10 (Firestore limit).
class FollowersPaginator {
  FollowersPaginator({
    required FirebaseFirestore firestore,
    required this.userId,
    required this.isFollowersList,
  }) : _firestore = firestore;

  static const int pageSize = 20;

  final FirebaseFirestore _firestore;
  final String userId;

  /// `true`  → people who follow [userId]  (`followingUid == userId`)
  /// `false` → people [userId] follows      (`followerUid  == userId`)
  final bool isFollowersList;

  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  /// Fetches the next page and returns hydrated [AppUser] objects
  /// in the same order as the follow relationships (newest first).
  Future<List<AppUser>> fetchNextPage() async {
    if (!_hasMore) return [];

    // 1. Query the follows collection
    Query query = _firestore
        .collection('follows')
        .where(
          isFollowersList ? 'followingUid' : 'followerUid',
          isEqualTo: userId,
        )
        .orderBy('createdAt', descending: true)
        .limit(pageSize);

    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    final snap = await query.get();
    if (snap.docs.length < pageSize) _hasMore = false;
    if (snap.docs.isNotEmpty) _lastDoc = snap.docs.last;

    // 2. Extract the UIDs on the "other side" of the relationship
    final uids = snap.docs.map((d) {
      final data = d.data() as Map<String, dynamic>;
      return (isFollowersList ? data['followerUid'] : data['followingUid'])
          as String;
    }).toList();

    if (uids.isEmpty) return [];

    // 3. Fetch user profiles in whereIn chunks of 10
    final profileMap = <String, AppUser>{};
    for (var i = 0; i < uids.length; i += 10) {
      final chunk = uids.sublist(i, math.min(i + 10, uids.length));
      final profileSnap = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      for (final doc in profileSnap.docs) {
        profileMap[doc.id] = AppUser.fromFirestore(doc);
      }
    }

    // 4. Return in the original order (newest follow first)
    return uids
        .where((uid) => profileMap.containsKey(uid))
        .map((uid) => profileMap[uid]!)
        .toList();
  }

  void reset() {
    _lastDoc = null;
    _hasMore = true;
  }
}
