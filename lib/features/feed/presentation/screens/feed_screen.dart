import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_urls.dart';
import '../../../../core/constants/feed_config.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/config/system_config_provider.dart';
import '../../domain/feed_letter_filter.dart';
import '../../domain/feed_following_merge.dart';
import '../widgets/explore_feed_paged.dart';
import '../widgets/following_feed_body.dart';
import '../widgets/pinned_feed_filters_sheet.dart';
import '../providers/feed_pinned_filters_provider.dart';
import '../../../../shared/moderation/report_flow.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../shared/utils/date_formatter.dart';
import 'comments_screen.dart';
import '../../../profile/presentation/screens/user_profile_screen.dart';
import '../../../letters/presentation/screens/letter_detail_screen.dart';
import '../../../letters/data/letter_repository_actions.dart';
import '../../../profile/presentation/screens/moderation_notifications_screen.dart';
import '../../../../shared/social/instagram_stories_share_service.dart';
import '../../../../shared/social/story_share_content.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  int _selectedFilter = 0;
  /// 0 = Explorar, 1 = Destaques, 2 = Seguindo
  int _feedLayer = 0;

  /// Rolling window lower bound, fixed for this screen lifetime so the Firestore
  /// listener is not recreated every frame (would duplicate reads).
  late final Timestamp _feedOpenedAtMin = Timestamp.fromDate(
    DateTime.now().subtract(const Duration(days: FeedConfig.openedAtWindowDays)),
  );

  Query<Map<String, dynamic>> _publicFeedQuery() {
    return FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'opened')
        .where('openedAt', isGreaterThanOrEqualTo: _feedOpenedAtMin)
        .orderBy('openedAt', descending: true)
        .limit(FeedConfig.publicMaxDocuments);
  }

  /// Explorar: smaller page + `startAfter` for load-more (see [ExploreFeedPaged]).
  Query<Map<String, dynamic>> _explorePageQuery() {
    return FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .where('isPublic', isEqualTo: true)
        .where('status', isEqualTo: 'opened')
        .where('openedAt', isGreaterThanOrEqualTo: _feedOpenedAtMin)
        .orderBy('openedAt', descending: true)
        .limit(FeedConfig.explorePageSize);
  }

  static const Map<int, List<String>> _filterEmotions = {
    1: ['love'],
    2: ['advice', 'achievement'],
    3: ['nostalgia', 'farewell'],
  };

  String _filterLabelForId(int id, AppLocalizations l10n) {
    switch (id) {
      case 0:
        return l10n.feedFilterAll;
      case 1:
        return l10n.feedFilterLove;
      case 2:
        return l10n.feedFilterFriendship;
      case 3:
        return l10n.feedFilterFamily;
      default:
        return l10n.feedFilterAll;
    }
  }

  void _showPinnedFiltersSheet(BuildContext context) {
    final pinned = ref.read(feedPinnedFiltersProvider);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => PinnedFeedFiltersSheet(
        initialPins: pinned,
        onSave: (pins) {
          ref.read(feedPinnedFiltersProvider.notifier).setPins(pins);
        },
      ),
    );
  }

  void _showFeedLayerSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      decoration: BoxDecoration(
                        color: context.pal.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.feedFiltersSheetTitle,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: context.pal.ink,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    selected: _feedLayer == 0,
                    selectedTileColor: context.pal.accent.withValues(alpha: 0.12),
                    title: Text(
                      l10n.feedLayerExplore,
                      style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.ink),
                    ),
                    onTap: () {
                      setState(() => _feedLayer = 0);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                  ListTile(
                    selected: _feedLayer == 1,
                    selectedTileColor: context.pal.accent.withValues(alpha: 0.12),
                    title: Text(
                      l10n.feedLayerHighlights,
                      style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.ink),
                    ),
                    onTap: () {
                      setState(() => _feedLayer = 1);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                  ListTile(
                    selected: _feedLayer == 2,
                    selectedTileColor: context.pal.accent.withValues(alpha: 0.12),
                    title: Text(
                      l10n.feedLayerFollowing,
                      style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.ink),
                    ),
                    onTap: () {
                      setState(() => _feedLayer = 2);
                      Navigator.of(sheetContext).pop();
                    },
                  ),
                  const Divider(height: 24),
                  ListTile(
                    leading: Icon(Icons.push_pin_outlined, color: context.pal.accent),
                    title: Text(
                      l10n.feedCustomizePinnedFilters,
                      style: GoogleFonts.dmSans(fontSize: 15, color: context.pal.ink, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      l10n.feedCustomizePinnedFiltersHint,
                      style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkSoft),
                    ),
                    onTap: () {
                      Navigator.of(sheetContext).pop();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) _showPinnedFiltersSheet(context);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reportsEnabled = ref.watch(systemConfigProvider).value?.reportsEnabled ?? true;
    final pinned = ref.watch(feedPinnedFiltersProvider);
    ref.listen(feedPinnedFiltersProvider, (previous, next) {
      if (!next.contains(_selectedFilter)) {
        setState(() => _selectedFilter = next.first);
      }
    });
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(
        children: [
          // Header escuro
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
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Whenote',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 26,
                                    color: context.pal.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const OwlFeedbackAffordance(
                                  forDarkHeader: true,
                                  child: OwlWatermark(width: 20, height: 24, opacity: 2.2),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(l10n.feedPublicHeader, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withValues(alpha:0.25), fontWeight: FontWeight.w300, letterSpacing: 2)),
                          ],
                        ),
                        Row(
                          children: [
                            _iconBtn(
                              Icons.search,
                              onTap: () => Navigator.pushNamed(context, '/search'),
                              tooltip: l10n.searchTitle,
                            ),
                            const SizedBox(width: 4),
                            _notificationBellBtn(l10n),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Pinned mood chips scroll; filter icon fixed at the right edge
                  SizedBox(
                    height: 46,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.fromLTRB(12, 0, 4, 8),
                            itemCount: pinned.length,
                            itemBuilder: (_, i) {
                              final filterId = pinned[i];
                              final selected = _selectedFilter == filterId;
                              return Align(
                                alignment: Alignment.center,
                                child: GestureDetector(
                                  onTap: () => setState(() => _selectedFilter = filterId),
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 6),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: selected ? context.pal.accent : Colors.white.withValues(alpha:0.08),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: selected ? context.pal.accent : Colors.white.withValues(alpha:0.08)),
                                    ),
                                    child: Text(
                                      _filterLabelForId(filterId, l10n),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                        fontSize: 11,
                                        height: 1.0,
                                        color: selected ? context.pal.white : Colors.white.withValues(alpha:0.4),
                                        fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12, bottom: 8),
                          child: Center(
                            child: Semantics(
                              button: true,
                              label: l10n.feedFiltersButtonSemantic,
                              child: GestureDetector(
                                onTap: () => _showFeedLayerSheet(context),
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha:0.12),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white.withValues(alpha:0.2)),
                                  ),
                                  child: Icon(
                                    Icons.tune,
                                    size: 18,
                                    color: Colors.white.withValues(alpha:0.9),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Feed — bounded query (limit + openedAt window); blocked senders hidden per viewer.
          Expanded(
            child: Builder(
              builder: (context) {
                final uid = FirebaseAuth.instance.currentUser?.uid;

                Widget feedForBlocked(Set<String> blocked) {
                  if (_feedLayer == 2) {
                    if (uid == null) {
                      return _buildFollowingSignedOut();
                    }
                    return FollowingFeedBody(
                      followerUid: uid,
                      openedAtMin: _feedOpenedAtMin,
                      blockedSenderUids: blocked,
                      builder: (context, docs) {
                        if (docs.isEmpty) return _buildFollowingEmpty();
                        return _buildLetterListFromDocs(
                          docs,
                          reportsEnabled: reportsEnabled,
                        );
                      },
                    );
                  }

                  if (_feedLayer == 0) {
                    return ExploreFeedPaged(
                      baseQuery: _explorePageQuery(),
                      blockedSenderUids: blocked,
                      reportsEnabled: reportsEnabled,
                      buildLetterList: _buildLetterListFromDocs,
                      buildEmpty: _buildEmpty,
                      buildFilterEmpty: _buildFilterEmpty,
                      buildError: () => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            AppLocalizations.of(context)!.feedLoadError,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.inkSoft),
                          ),
                        ),
                      ),
                    );
                  }

                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _publicFeedQuery().snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              AppLocalizations.of(context)!.feedLoadError,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.inkSoft),
                            ),
                          ),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final allDocs = snapshot.data?.docs ?? [];
                      if (allDocs.isEmpty) return _buildEmpty();

                      var visibleDocs = allDocs.where((d) {
                        final data = d.data();
                        return isFeedLetterVisibleForViewer(
                          letterData: data,
                          blockedSenderUids: blocked,
                        );
                      }).toList();
                      if (visibleDocs.isEmpty) return _buildEmpty();

                      if (_feedLayer == 1) {
                        visibleDocs = sortByLikeCountThenOpenedAt(
                          visibleDocs,
                          maxItems: FeedConfig.highlightsMaxVisible,
                        );
                      }

                      return _buildLetterListFromDocs(
                        visibleDocs,
                        reportsEnabled: reportsEnabled,
                      );
                    },
                  );
                }

                if (uid == null) {
                  return feedForBlocked(<String>{});
                }
                return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('blocks')
                      .where('blockedBy', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, blocksSnap) {
                    final blocked = <String>{};
                    for (final d in blocksSnap.data?.docs ?? []) {
                      final m = d.data();
                      final blockedUid = m['blockedUid'] as String?;
                      if (blockedUid != null && blockedUid.isNotEmpty) blocked.add(blockedUid);
                    }
                    return feedForBlocked(blocked);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Bell icon with a red dot when there are unread notifications.
  Widget _notificationBellBtn(AppLocalizations l10n) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      return _iconBtn(
        Icons.notifications_outlined,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ModerationNotificationsScreen()),
        ),
        tooltip: l10n.moderationNotificationsTitle,
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(uid)
          .collection(FirestoreCollections.userNotifications)
          .where('read', isEqualTo: false)
          .limit(1)
          .snapshots(),
      builder: (context, snap) {
        final hasUnread = snap.hasData && snap.data!.docs.isNotEmpty;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _iconBtn(
              Icons.notifications_outlined,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ModerationNotificationsScreen()),
              ),
              tooltip: l10n.moderationNotificationsTitle,
            ),
            if (hasUnread)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _iconBtn(IconData icon, {VoidCallback? onTap, String? tooltip}) {
    Widget btn = Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha:0.08)),
      ),
      child: Icon(icon, size: 18, color: Colors.white.withValues(alpha:0.5)),
    );
    if (onTap != null) {
      btn = Semantics(
        button: true,
        label: tooltip,
        child: Tooltip(
          message: tooltip ?? '',
          child: SizedBox(
            width: 48, height: 48,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: onTap,
                child: Center(child: btn),
              ),
            ),
          ),
        ),
      );
    }
    return btn;
  }

  Widget _buildLetterListFromDocs(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> docs, {
    required bool reportsEnabled,
    ScrollController? scrollController,
  }) {
    final allowedKeys = _filterEmotions[_selectedFilter];
    final filtered = allowedKeys == null
        ? docs
        : docs.where((d) {
            final emotion = d.data()['emotionalState'] as String?;
            return emotion != null && allowedKeys.contains(emotion);
          }).toList();

    if (filtered.isEmpty) return _buildFilterEmpty();

    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
      itemCount: filtered.length,
      itemBuilder: (_, i) {
        final data = filtered[i].data();
        return _FeedCard(
          data: data,
          docId: filtered[i].id,
          isFeatured: i == 0,
          reportsEnabled: reportsEnabled,
        );
      },
    );
  }

  Widget _buildFollowingSignedOut() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('👋', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              l10n.feedFollowingSignedOutTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: context.pal.ink, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.feedFollowingSignedOutSubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFollowingEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💌', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            l10n.feedFollowingEmptyTitle,
            style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              l10n.feedFollowingEmptySubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('✨', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(l10n.feedEmptyTitle,
            style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          Text(l10n.feedEmptySubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildFilterEmpty() {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 40)),
          const SizedBox(height: 14),
          Text(l10n.feedFilterEmptyTitle,
            style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: context.pal.ink, fontStyle: FontStyle.italic)),
          const SizedBox(height: 6),
          Text(l10n.feedFilterEmptySubtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
        ],
      ),
    );
  }
}

// ── Card individual do feed ──────────────────────────────────
class _FeedCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  final bool isFeatured;
  final bool reportsEnabled;

  const _FeedCard({
    required this.data,
    required this.docId,
    required this.isFeatured,
    required this.reportsEnabled,
  });

  @override
  State<_FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<_FeedCard> with SingleTickerProviderStateMixin {
  bool _showAllComments = false;
  final Set<String> _expandedCommentPreviewIds = <String>{};
  bool _expanded = false;
  bool _sharingStory = false;
  late AnimationController _heartCtrl;
  late Animation<double> _heartScale;

  Color _bg(BuildContext ctx) => widget.isFeatured ? ctx.pal.headerGradient.first : ctx.pal.card;
  Color _text(BuildContext ctx) => widget.isFeatured ? Colors.white : ctx.pal.ink;
  Color _textSoft(BuildContext ctx) => widget.isFeatured ? Colors.white.withValues(alpha:0.6) : ctx.pal.inkSoft;
  Color _textFaint(BuildContext ctx) => widget.isFeatured ? Colors.white.withValues(alpha:0.4) : ctx.pal.inkFaint;
  Color _textMuted(BuildContext ctx) => widget.isFeatured ? Colors.white.withValues(alpha:0.25) : ctx.pal.inkFaint;
  Color _iconFaint(BuildContext ctx) => widget.isFeatured ? Colors.white.withValues(alpha:0.5) : ctx.pal.inkFaint;

  @override
  void initState() {
    super.initState();
    _heartCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _heartScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _heartCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _heartCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final data = widget.data;
    final openedAt = data['openedAt'] != null ? (data['openedAt'] as Timestamp).toDate() : DateTime.now();

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: _bg(context),
        border: Border(
          bottom: BorderSide(color: context.pal.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header do card — autor
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                // ── Identificação do remetente ─────────────────────────────
                Builder(builder: (context) {
                  final hideSender = (data['hideSenderName'] ?? false) == true;
                  final senderUid  = data['senderUid'] as String? ?? '';
                  final senderName = data['senderName'] as String? ?? 'U';

                  Widget avatarSection;
                  if (hideSender) {
                    // Remetente ocultado: avatar genérico, sem link para perfil
                    avatarSection = Row(
                      children: [
                        Container(
                          decoration: widget.isFeatured
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: context.pal.accent.withValues(alpha:0.4)),
                                )
                              : null,
                          child: ClipOval(
                            child: UserAvatar(
                              photoUrl: null,
                              name: '?',
                              size: 38,
                              backgroundColor: widget.isFeatured
                                  ? context.pal.accent.withValues(alpha:0.35)
                                  : context.pal.accentWarm,
                              textColor: widget.isFeatured ? Colors.white : context.pal.accent,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.feedSenderAnonymous,
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: _text(context),
                              )),
                            Text(l10n.feedCardTo(data['receiverName'] as String? ?? ''),
                              style: GoogleFonts.dmSans(fontSize: 11, color: _textFaint(context))),
                          ],
                        ),
                      ],
                    );
                  } else {
                    // Remetente visível: avatar real + link para perfil
                    avatarSection = GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => UserProfileScreen(userId: senderUid, userName: senderName),
                      )),
                      child: Row(
                        children: [
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(FirestoreCollections.users)
                                .doc(senderUid)
                                .snapshots(),
                            builder: (context, userSnap) {
                              final map = userSnap.data?.data() as Map<String, dynamic>?;
                              final photoUrl = map?['photoUrl'] as String?;
                              return Container(
                                decoration: widget.isFeatured
                                    ? BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: context.pal.accent.withValues(alpha:0.4)),
                                      )
                                    : null,
                                child: ClipOval(
                                  child: UserAvatar(
                                    photoUrl: photoUrl,
                                    name: senderName,
                                    size: 38,
                                    backgroundColor: widget.isFeatured
                                        ? context.pal.accent.withValues(alpha:0.35)
                                        : context.pal.accentWarm,
                                    textColor: widget.isFeatured ? Colors.white : context.pal.accent,
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(senderName,
                                style: GoogleFonts.dmSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: _text(context),
                                )),
                              Text(l10n.feedCardTo(data['receiverName'] as String? ?? ''),
                                style: GoogleFonts.dmSans(fontSize: 11, color: _textFaint(context))),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return avatarSection;
                }),

                const Spacer(),

                // ── Menu ··· — visível apenas para o destinatário ──────────
                Builder(builder: (context) {
                  // isReceiver: o usuário logado é quem recebeu (e publicou) a carta
                  final isReceiver = uid != null &&
                      (data['receiverUid'] as String? ?? '') == uid;
                  // isStranger: nem remetente nem destinatário
                  final isSender   = uid != null && (data['senderUid'] as String? ?? '') == uid;
                  final isStranger = uid != null && !isReceiver && !isSender;

                  final isPublic    = data['isPublic'] == true;
                  final hideSender  = (data['hideSenderName'] ?? false) == true;

                  if (isReceiver) {
                    return PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 20, color: _textFaint(context)),
                      tooltip: '',
                      onSelected: (value) async {
                        switch (value) {
                          case 'toggle_public':
                            await setLetterPublic(
                              docId: widget.docId,
                              isPublic: !isPublic,
                            );
                            break;
                          case 'toggle_sender':
                            await setLetterHideSenderName(
                              docId: widget.docId,
                              hide: !hideSender,
                            );
                            break;
                          case 'remove_feed':
                            await setLetterPublic(
                              docId: widget.docId,
                              isPublic: false,
                            );
                            break;
                        }
                      },
                      itemBuilder: (ctx) => [
                        // 1. Tornar privada / pública
                        PopupMenuItem<String>(
                          value: 'toggle_public',
                          child: Row(children: [
                            Icon(
                              isPublic
                                  ? Icons.lock_outline_rounded
                                  : Icons.public_rounded,
                              size: 18,
                            ),
                            const SizedBox(width: 10),
                            Text(isPublic
                                ? l10n.vaultLetterSheetMakePrivate
                                : l10n.vaultLetterSheetMakePublic),
                          ]),
                        ),
                        // 2. Ocultar / mostrar nome do remetente (só quando pública)
                        if (isPublic)
                          PopupMenuItem<String>(
                            value: 'toggle_sender',
                            child: Row(children: [
                              Icon(
                                hideSender
                                    ? Icons.person_rounded
                                    : Icons.person_off_rounded,
                                size: 18,
                              ),
                              const SizedBox(width: 10),
                              Text(hideSender
                                  ? l10n.feedShowSenderName
                                  : l10n.feedHideSenderName),
                            ]),
                          ),
                        // 3. Remover do feed (divisor visual)
                        const PopupMenuDivider(),
                        PopupMenuItem<String>(
                          value: 'remove_feed',
                          child: Row(children: [
                            Icon(
                              Icons.remove_circle_outline_rounded,
                              size: 18,
                              color: Colors.red.shade700,
                            ),
                            const SizedBox(width: 10),
                            Text(l10n.feedRemoveFromFeed,
                              style: TextStyle(color: Colors.red.shade700)),
                          ]),
                        ),
                      ],
                    );
                  }

                  if (isStranger && widget.reportsEnabled) {
                    return PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 20, color: _textFaint(context)),
                      tooltip: '',
                      onSelected: (value) {
                        if (value == 'report') {
                          showReportContentSheet(
                            context,
                            targetType: 'letter',
                            targetId: widget.docId,
                            letterId: widget.docId,
                          );
                        }
                      },
                      itemBuilder: (ctx) => [
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Text(l10n.reportMenuLabel),
                        ),
                      ],
                    );
                  }

                  return const SizedBox.shrink();
                }),

                if (widget.isFeatured) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: context.pal.accent.withValues(alpha:0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: context.pal.accent.withValues(alpha:0.3)),
                    ),
                    child: Text(l10n.feedCardFeatured,
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        color: context.pal.accent,
                        fontWeight: FontWeight.w500,
                      )),
                  ),
                ],
              ],
            ),
          ),

          // Conteúdo da carta
          if (!_expanded) ...[
            // ── Preview com fade gradual ──────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? '',
                    style: GoogleFonts.dmSerifDisplay(fontSize: 18,
                      color: _text(context),
                      fontStyle: FontStyle.italic, height: 1.3)),
                  const SizedBox(height: 8),
                  Stack(
                    children: [
                      Text(data['message'] ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.clip,
                        style: GoogleFonts.dmSans(fontSize: 14,
                          color: _textSoft(context),
                          height: 1.6)),
                      // Fade gradual para esconder o final
                      Positioned(
                        left: 0, right: 0, bottom: 0,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _bg(context).withValues(alpha:0.0),
                                _bg(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => setState(() => _expanded = true),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mail_outline_rounded, size: 16, color: context.pal.accent),
                        const SizedBox(width: 6),
                        Text(l10n.feedOpenLetter,
                          style: GoogleFonts.dmSans(fontSize: 13,
                            color: context.pal.accent,
                            fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.feedOpenedOnDate(formatShortDate(openedAt, locale)),
                    style: GoogleFonts.dmSans(fontSize: 10,
                      color: _textMuted(context),
                      letterSpacing: 1),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ] else ...[
            // ── Carta expandida com layout de papel ──────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Builder(
                builder: (ctx) => _FeedPaperLetter(
                  data: data,
                  accentColor: context.pal.accent,
                  onClose: () => setState(() => _expanded = false),
                  onShare: () => _sharePaperLetter(ctx),
                  isSharing: _sharingStory,
                ),
              ),
            ),
          ],

          // Ações — like e comentário
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
            child: Row(
              children: [
                // Like
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.likes)
                      .where('letterId', isEqualTo: widget.docId)
                      .where('userUid', isEqualTo: uid)
                      .snapshots(),
                  builder: (_, likeSnap) {
                    final liked = (likeSnap.data?.docs ?? []).isNotEmpty;
                    return GestureDetector(
                      onTap: () async {
                        _heartCtrl.forward(from: 0);
                        if (liked) {
                          await FirebaseFirestore.instance.collection(FirestoreCollections.likes).doc(likeSnap.data!.docs.first.id).delete();
                          await FirebaseFirestore.instance.collection(FirestoreCollections.letters).doc(widget.docId).update({'likeCount': FieldValue.increment(-1)});
                        } else {
                          await FirebaseFirestore.instance.collection(FirestoreCollections.likes).add({'letterId': widget.docId, 'userUid': uid, 'createdAt': Timestamp.now()});
                          await FirebaseFirestore.instance.collection(FirestoreCollections.letters).doc(widget.docId).update({'likeCount': FieldValue.increment(1)});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            AnimatedBuilder(
                              animation: _heartScale,
                              builder: (_, __) => Transform.scale(
                                scale: _heartScale.value,
                                child: Icon(
                                  liked ? Icons.favorite : Icons.favorite_border,
                                  size: 22,
                                  color: liked ? context.pal.accent : _iconFaint(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('${widget.data['likeCount'] ?? 0}',
                              style: GoogleFonts.dmSans(fontSize: 13,
                                color: _iconFaint(context))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 8),
                // Comentário
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => CommentsScreen(letterId: widget.docId, letterTitle: widget.data['title'] ?? ''),
                  )),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 22,
                          color: _iconFaint(context)),
                        const SizedBox(width: 4),
                        Text('${widget.data['commentCount'] ?? 0}',
                          style: GoogleFonts.dmSans(fontSize: 13,
                            color: _iconFaint(context))),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                // Share
                Builder(
                  builder: (ctx) => GestureDetector(
                    onTap: _sharingStory ? null : () => _sharePaperLetter(ctx),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _sharingStory
                          ? SizedBox(
                              width: 20, height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: _iconFaint(context),
                              ),
                            )
                          : Icon(Icons.share_outlined, size: 20,
                              color: _iconFaint(context)),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Preview de comentários
          if ((widget.data['commentCount'] ?? 0) > 0)
            _buildCommentsPreview(uid),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Future<void> _sharePaperLetter(BuildContext triggerContext) async {
    if (_sharingStory) return;
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final data = widget.data;
    final deepLink = AppUrls.letterUrl(widget.docId);
    final openedAt = data['openedAt'] != null
        ? (data['openedAt'] as Timestamp).toDate()
        : DateTime.now();

    final hideSender = (data['hideSenderName'] ?? false) == true;
    final senderName = hideSender
        ? l10n.feedSenderAnonymous
        : (data['senderName'] as String? ?? '');

    final content = StoryShareContent.paperLetter(
      docId: widget.docId,
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      senderName: senderName,
      receiverName: data['receiverName'] ?? '',
      dateSubtitle: l10n.feedOpenedOnDate(formatShortDate(openedAt, locale)),
    );

    final box = triggerContext.findRenderObject() as RenderBox?;
    final origin = box != null ? box.localToGlobal(Offset.zero) & box.size : null;

    setState(() => _sharingStory = true);
    try {
      await InstagramStoriesShareService.share(
        context: context,
        content: content,
        shareText: l10n.qrShareText(data['title'] ?? '', deepLink),
        shareSubject: l10n.qrShareSubject,
        sharePositionOrigin: origin,
      );
    } finally {
      if (mounted) setState(() => _sharingStory = false);
    }
  }

  Widget _buildCommentsPreview(String? uid) {
    final l10n = AppLocalizations.of(context)!;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.comments)
          .where('letterId', isEqualTo: widget.docId)
          .orderBy('createdAt', descending: false)
          .limit(_showAllComments ? 20 : 2)
          .snapshots(),
      builder: (_, snap) {
        final docs = snap.data?.docs ?? [];
        if (docs.isEmpty) return const SizedBox();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(height: 1, color: widget.isFeatured ? Colors.white.withValues(alpha:0.08) : context.pal.border),
            ...docs.map((doc) {
              final c = doc.data() as Map<String, dynamic>;
              final message = c['message'] as String? ?? '';
              final commentExpanded = _expandedCommentPreviewIds.contains(doc.id);
              final showReadMore = !commentExpanded &&
                  (message.length > 120 || message.split('\n').length >= 4);
              return Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: '${c['userName'] ?? ''}  ',
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: widget.isFeatured ? Colors.white.withValues(alpha:0.8) : context.pal.ink,
                            ),
                          ),
                          TextSpan(
                            text: message,
                            style: GoogleFonts.dmSans(fontSize: 13, color: _textSoft(context)),
                          ),
                        ],
                      ),
                      maxLines: commentExpanded ? null : 4,
                      overflow: commentExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    ),
                    if (showReadMore)
                      GestureDetector(
                        onTap: () => setState(() => _expandedCommentPreviewIds.add(doc.id)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            l10n.feedReadMore,
                            style: GoogleFonts.dmSans(
                              fontSize: 13,
                              color: _textFaint(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }),
            if (!_showAllComments && (widget.data['commentCount'] ?? 0) > 2)
              GestureDetector(
                onTap: () => setState(() => _showAllComments = true),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 0),
                  child: Text(l10n.feedViewAllComments(widget.data['commentCount'] as int? ?? 0),
                    style: GoogleFonts.dmSans(fontSize: 12,
                      color: _textMuted(context))),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Carta expandida no feed com layout de papel ─────────────────────────
class _FeedPaperLetter extends StatelessWidget {
  final Map<String, dynamic> data;
  final Color accentColor;
  final VoidCallback onClose;
  final VoidCallback onShare;
  final bool isSharing;

  const _FeedPaperLetter({
    required this.data,
    required this.accentColor,
    required this.onClose,
    required this.onShare,
    this.isSharing = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final createdAt = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final hideSender = (data['hideSenderName'] ?? false) == true;
    final senderName = hideSender
        ? l10n.feedSenderAnonymous
        : (data['senderName'] as String? ?? '');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF2E8D5),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.25),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra colorida no topo
          Container(
            height: 5,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ),
          // Conteúdo com linhas de papel
          Stack(
            children: [
              // Linhas ruled do papel
              Positioned.fill(
                child: CustomPaint(
                  painter: _FeedPaperLinesPainter(),
                ),
              ),
              // Conteúdo da carta
              Padding(
                padding: const EdgeInsets.fromLTRB(48, 28, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FROM
                    Text(l10n.letterDetailHeaderFrom,
                      style: TextStyle(
                        fontSize: 9,
                        letterSpacing: 4,
                        color: accentColor.withValues(alpha:0.8),
                      )),
                    const SizedBox(height: 8),
                    // Nome do remetente
                    Text(senderName,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 20,
                        color: const Color(0xFF160D04),
                      )),
                    const SizedBox(height: 4),
                    // Para: destinatário
                    Text(l10n.letterDetailTo(data['receiverName'] ?? ''),
                      style: GoogleFonts.dmSans(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF7A5C3A),
                      )),
                    const SizedBox(height: 16),
                    // Divider
                    Container(width: 24, height: 1, color: accentColor.withValues(alpha:0.5)),
                    const SizedBox(height: 8),
                    // Título
                    Text(data['title'] ?? '',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 17,
                        color: const Color(0xFF160D04),
                        fontStyle: FontStyle.italic,
                      )),
                    const SizedBox(height: 16),
                    // Mensagem completa
                    Text(data['message'] ?? '',
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF241608),
                        height: 2.0,
                      )),
                    const SizedBox(height: 24),
                    // Assinatura
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text('— $senderName',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF4A2E14),
                        )),
                    ),
                    const SizedBox(height: 4),
                    // Data
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        formatShortDate(createdAt, locale),
                        style: TextStyle(
                          fontSize: 8,
                          letterSpacing: 2,
                          color: accentColor.withValues(alpha:0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Botões: fechar e compartilhar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: onClose,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFFD4C5B0)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(l10n.feedCloseLetter,
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: const Color(0xFF7A5C3A),
                                fontWeight: FontWeight.w500,
                              )),
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: isSharing ? null : onShare,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: accentColor.withValues(alpha:0.12),
                              border: Border.all(color: accentColor.withValues(alpha:0.4)),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: isSharing
                                ? SizedBox(
                                    width: 16, height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: accentColor,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.share_outlined, size: 14, color: accentColor),
                                      const SizedBox(width: 6),
                                      Text(l10n.letterDetailShareTitle,
                                        style: GoogleFonts.dmSans(
                                          fontSize: 12,
                                          color: accentColor,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    ],
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Painter de linhas do papel para o feed ──────────────────────────────
class _FeedPaperLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.black.withValues(alpha:0.04)
      ..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    // Margem vermelha
    canvas.drawLine(
      const Offset(36, 0),
      Offset(36, size.height),
      Paint()
        ..color = const Color(0xFFC0392B).withValues(alpha:0.12)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
