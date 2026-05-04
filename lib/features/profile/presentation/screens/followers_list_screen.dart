import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/models/app_user.dart';
import '../../domain/followers_paginator.dart';
import '../widgets/follower_tile.dart';

/// Full-screen list with two tabs: **Followers** and **Following**.
///
/// Uses [FollowersPaginator] for cursor-based lazy loading (20 items/page).
class FollowersListScreen extends StatefulWidget {
  const FollowersListScreen({
    super.key,
    required this.userId,
    this.initialTabFollowers = true,
  });

  final String userId;

  /// `true` opens on the **Followers** tab, `false` on **Following**.
  final bool initialTabFollowers;

  @override
  State<FollowersListScreen> createState() => _FollowersListScreenState();
}

class _FollowersListScreenState extends State<FollowersListScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabFollowers ? 0 : 1,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.pal.bg,
      appBar: AppBar(
        backgroundColor: context.pal.headerGradient.first,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha:0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withValues(alpha:0.6)),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: context.pal.accent,
          indicatorWeight: 2.5,
          labelColor: context.pal.white,
          unselectedLabelColor: Colors.white.withValues(alpha:0.4),
          labelStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400),
          tabs: [
            Tab(text: l10n.followersTabFollowers),
            Tab(text: l10n.followersTabFollowing),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _FollowersTab(userId: widget.userId, isFollowersList: true),
          _FollowersTab(userId: widget.userId, isFollowersList: false),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab body — one instance per tab (followers / following)
// ---------------------------------------------------------------------------

class _FollowersTab extends StatefulWidget {
  const _FollowersTab({
    required this.userId,
    required this.isFollowersList,
  });

  final String userId;
  final bool isFollowersList;

  @override
  State<_FollowersTab> createState() => _FollowersTabState();
}

class _FollowersTabState extends State<_FollowersTab>
    with AutomaticKeepAliveClientMixin {
  late final FollowersPaginator _paginator;
  final _users = <AppUser>[];
  final _followingSet = <String>{}; // UIDs the current user follows
  bool _loading = true;
  bool _loadingMore = false;

  final _currentUid = FirebaseAuth.instance.currentUser?.uid;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _paginator = FollowersPaginator(
      firestore: FirebaseFirestore.instance,
      userId: widget.userId,
      isFollowersList: widget.isFollowersList,
    );
    _loadFirstPage();
  }

  Future<void> _loadFirstPage() async {
    final page = await _paginator.fetchNextPage();
    if (!mounted) return;
    await _refreshFollowStatus(page);
    setState(() {
      _users.addAll(page);
      _loading = false;
    });
  }

  Future<void> _loadMore() async {
    if (_loadingMore || !_paginator.hasMore) return;
    setState(() => _loadingMore = true);
    final page = await _paginator.fetchNextPage();
    if (!mounted) return;
    await _refreshFollowStatus(page);
    setState(() {
      _users.addAll(page);
      _loadingMore = false;
    });
  }

  /// Check which of the given [users] the current user follows.
  Future<void> _refreshFollowStatus(List<AppUser> users) async {
    if (_currentUid == null || users.isEmpty) return;

    final uids = users.map((u) => u.uid).toList();
    for (var i = 0; i < uids.length; i += 10) {
      final chunk = uids.sublist(i, math.min(i + 10, uids.length));
      final snap = await FirebaseFirestore.instance
          .collection('follows')
          .where('followerUid', isEqualTo: _currentUid)
          .where('followingUid', whereIn: chunk)
          .get();
      for (final doc in snap.docs) {
        final data = doc.data();
        final uid = data['followingUid'] as String?;
        if (uid != null) _followingSet.add(uid);
      }
    }
  }

  Future<void> _toggleFollow(AppUser target) async {
    if (_currentUid == null || _currentUid == target.uid) return;

    final firestore = FirebaseFirestore.instance;
    final isFollowing = _followingSet.contains(target.uid);

    if (isFollowing) {
      final snap = await firestore
          .collection('follows')
          .where('followerUid', isEqualTo: _currentUid)
          .where('followingUid', isEqualTo: target.uid)
          .get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
      setState(() => _followingSet.remove(target.uid));
    } else {
      await firestore.collection('follows').add({
        'followerUid': _currentUid,
        'followingUid': target.uid,
        'createdAt': Timestamp.now(),
      });
      setState(() => _followingSet.add(target.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = AppLocalizations.of(context)!;

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.isFollowersList
                  ? Icons.people_outline_rounded
                  : Icons.person_add_alt_1_outlined,
              size: 48,
              color: context.pal.inkFaint,
            ),
            const SizedBox(height: 12),
            Text(
              widget.isFollowersList
                  ? l10n.followersEmpty
                  : l10n.followingEmpty,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: context.pal.inkSoft,
              ),
            ),
          ],
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification &&
            notification.metrics.pixels >=
                notification.metrics.maxScrollExtent - 200) {
          _loadMore();
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _users.length + (_paginator.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= _users.length) {
            // Loading indicator at the bottom
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            );
          }

          final user = _users[index];
          return FollowerTile(
            user: user,
            isFollowing: _followingSet.contains(user.uid),
            onToggleFollow: () => _toggleFollow(user),
          );
        },
      ),
    );
  }
}
