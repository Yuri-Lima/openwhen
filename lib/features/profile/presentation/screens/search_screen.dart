import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/user_search/user_search_follows.dart';
import '../../../../core/user_search/user_search_result.dart';
import '../../../../core/user_search/user_search_service.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../l10n/app_localizations.dart';
import 'user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchCtrl = TextEditingController();
  final _userSearch = UserSearchService();
  List<UserSearchResult> _results = [];
  bool _isSearching = false;
  String _query = '';
  Timer? _debounce;
  Set<String> _followingUids = {};
  DateTime? _lastRefresh;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _applySearchResults(List<UserSearchResult> results) async {
    final me = FirebaseAuth.instance.currentUser?.uid;
    if (me == null || results.isEmpty) {
      if (mounted) {
        setState(() {
          _results = results;
          _followingUids = {};
        });
      }
      return;
    }
    final following = await fetchFollowingUidsForTargets(
      firestore: FirebaseFirestore.instance,
      followerUid: me,
      targetUids: results.map((r) => r.uid),
    );
    if (!mounted) return;
    setState(() {
      _results = results;
      _followingUids = following;
    });
  }

  Future<void> _runSearch(String rawQuery) async {
    final q = UserSearchService.normalizeQuery(rawQuery);
    if (q.length < UserSearchService.minQueryLength) {
      if (mounted) {
        setState(() {
          _results = [];
          _followingUids = {};
          _isSearching = false;
        });
      }
      return;
    }
    if (mounted) setState(() => _isSearching = true);
    try {
      final results = await _userSearch.search(rawQuery);
      if (!mounted) return;
      await _applySearchResults(results);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _onSearchChanged(String text) {
    setState(() => _query = text);
    _debounce?.cancel();
    final q = UserSearchService.normalizeQuery(text);
    if (q.length < UserSearchService.minQueryLength) {
      setState(() {
        _results = [];
        _followingUids = {};
        _isSearching = false;
      });
      return;
    }
    setState(() => _isSearching = true);
    _debounce = Timer(const Duration(milliseconds: 300), () {
      unawaited(_runSearch(text));
    });
  }

  Future<void> _onRefresh() async {
    final now = DateTime.now();
    if (_lastRefresh != null &&
        now.difference(_lastRefresh!) < const Duration(seconds: 3)) {
      return;
    }
    _lastRefresh = now;
    final q = UserSearchService.normalizeQuery(_query);
    if (q.length < UserSearchService.minQueryLength) return;
    await _runSearch(_query);
  }

  Future<void> _toggleFollow(UserSearchResult r) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null || r.uid == uid) return;
    if (_followingUids.contains(r.uid)) {
      final snap = await FirebaseFirestore.instance
          .collection('follows')
          .where('followerUid', isEqualTo: uid)
          .where('followingUid', isEqualTo: r.uid)
          .limit(1)
          .get();
      if (snap.docs.isNotEmpty) await snap.docs.first.reference.delete();
      if (mounted) setState(() => _followingUids.remove(r.uid));
    } else {
      await FirebaseFirestore.instance.collection('follows').add({
        'followerUid': uid,
        'followingUid': r.uid,
        'createdAt': Timestamp.now(),
      });
      if (mounted) setState(() => _followingUids.add(r.uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final q = UserSearchService.normalizeQuery(_query);
    final shortQuery = q.length < UserSearchService.minQueryLength;

    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.pal.headerGradient,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha:0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              size: 18,
                              color: Colors.white.withValues(alpha:0.6),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Row(
                          children: [
                            Text(
                              l10n.searchTitle,
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 22,
                                color: context.pal.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const OwlFeedbackAffordance(
                              forDarkHeader: true,
                              child: OwlWatermark(
                                width: 18,
                                height: 22,
                                opacity: 2.2,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha:0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha:0.1),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            size: 18,
                            color: Colors.white.withValues(alpha:0.4),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchCtrl,
                              autofocus: true,
                              style: GoogleFonts.dmSans(
                                color: context.pal.white,
                                fontSize: 15,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: l10n.searchHint,
                                hintStyle: GoogleFonts.dmSans(
                                  color: Colors.white.withValues(alpha:0.3),
                                  fontSize: 15,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                              onChanged: _onSearchChanged,
                            ),
                          ),
                          if (_query.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchCtrl.clear();
                                _onSearchChanged('');
                              },
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white.withValues(alpha:0.4),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(child: _buildBody(context, l10n, shortQuery)),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AppLocalizations l10n,
    bool shortQuery,
  ) {
    if (shortQuery) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l10n.searchMinCharsHint,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              color: context.pal.inkSoft,
              height: 1.4,
            ),
          ),
        ),
      );
    }

    if (_isSearching && _results.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isSearching && _results.isEmpty) {
      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('😕', style: TextStyle(fontSize: 40)),
                    const SizedBox(height: 12),
                    Text(
                      l10n.searchEmpty,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 16,
                        color: context.pal.ink,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          if (_isSearching && _results.isNotEmpty)
            const LinearProgressIndicator(minHeight: 2),
          ..._results.map(_buildUserTile),
        ],
      ),
    );
  }

  Widget _buildUserTile(UserSearchResult r) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final l10n = AppLocalizations.of(context)!;
    final isFollowing = _followingUids.contains(r.uid);
    final isSelf = currentUid != null && r.uid == currentUid;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              UserProfileScreen(userId: r.uid, userName: r.publicName),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: context.pal.card,
          border: Border(bottom: BorderSide(color: context.pal.border)),
        ),
        child: Row(
          children: [
            UserAvatar(
              photoUrl: r.photoUrl,
              name: r.publicName,
              size: 48,
              backgroundColor: context.pal.accentWarm,
              textColor: context.pal.accent,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    r.publicName,
                    style: GoogleFonts.dmSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: context.pal.ink,
                    ),
                  ),
                  Text(
                    '@${r.username}',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: context.pal.inkFaint,
                    ),
                  ),
                ],
              ),
            ),
            if (!isSelf)
              GestureDetector(
                onTap: () => _toggleFollow(r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isFollowing
                        ? Colors.transparent
                        : context.pal.accent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isFollowing
                          ? context.pal.inkFaint
                          : context.pal.accent,
                    ),
                  ),
                  child: Text(
                    isFollowing
                        ? l10n.userProfileFollowing
                        : l10n.userProfileFollow,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isFollowing
                          ? context.pal.inkSoft
                          : context.pal.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
