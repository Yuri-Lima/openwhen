import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/feed_config.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../domain/feed_following_merge.dart';

/// Real-time merged feed of public letters from people the user follows.
/// Uses one Firestore listener per `whereIn` chunk (max 10 UIDs per chunk).
class FollowingFeedBody extends StatefulWidget {
  const FollowingFeedBody({
    super.key,
    required this.followerUid,
    required this.openedAtMin,
    required this.blockedSenderUids,
    required this.builder,
  });

  final String followerUid;
  final Timestamp openedAtMin;
  final Set<String> blockedSenderUids;

  /// Builds list UI from merged, sorted docs (may be empty).
  final Widget Function(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs,
  ) builder;

  @override
  State<FollowingFeedBody> createState() => _FollowingFeedBodyState();
}

class _FollowingFeedBodyState extends State<FollowingFeedBody> {
  final Map<int, QuerySnapshot<Map<String, dynamic>>> _chunkSnapshots = {};
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _followsSub;
  final List<StreamSubscription<QuerySnapshot<Map<String, dynamic>>>> _letterSubs = [];
  bool _followsFirstEvent = false;

  @override
  void initState() {
    super.initState();
    _followsSub = FirebaseFirestore.instance
        .collection('follows')
        .where('followerUid', isEqualTo: widget.followerUid)
        .snapshots()
        .listen(
      _onFollowsSnapshot,
      onError: (_) {
        if (mounted) setState(() {});
      },
    );
  }

  void _onFollowsSnapshot(QuerySnapshot<Map<String, dynamic>> snap) {
    _followsFirstEvent = true;
    final followingIds = snap.docs
        .map((d) => d.data()['followingUid'] as String?)
        .whereType<String>()
        .toSet()
        .toList();

    _cancelLetterSubs();
    _chunkSnapshots.clear();

    if (followingIds.isEmpty) {
      if (mounted) setState(() {});
      return;
    }

    final chunks = chunkIds(followingIds, chunkSize: FeedConfig.whereInChunkSize);
    for (var i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];
      final sub = FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('isPublic', isEqualTo: true)
          .where('status', isEqualTo: 'opened')
          .where('senderUid', whereIn: chunk)
          .limit(FeedConfig.perChunkFollowQueryLimit)
          .snapshots()
          .listen(
        (letterSnap) {
          if (!mounted) return;
          setState(() {
            _chunkSnapshots[i] = letterSnap;
          });
        },
        onError: (_) {
          if (mounted) setState(() {});
        },
      );
      _letterSubs.add(sub);
    }
    if (mounted) setState(() {});
  }

  void _cancelLetterSubs() {
    for (final s in _letterSubs) {
      unawaited(s.cancel());
    }
    _letterSubs.clear();
  }

  @override
  void dispose() {
    unawaited(_followsSub?.cancel());
    _cancelLetterSubs();
    super.dispose();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> _mergedDocs() {
    final all = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
    final keys = _chunkSnapshots.keys.toList()..sort();
    for (final k in keys) {
      final s = _chunkSnapshots[k];
      if (s != null) all.addAll(s.docs);
    }
    return mergeFollowChunkSnapshots(
      allDocs: all,
      openedAtMin: widget.openedAtMin,
      blockedSenderUids: widget.blockedSenderUids,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_followsSub == null || !_followsFirstEvent) {
      return const Center(child: CircularProgressIndicator());
    }
    final docs = _mergedDocs();
    return widget.builder(context, docs);
  }
}
