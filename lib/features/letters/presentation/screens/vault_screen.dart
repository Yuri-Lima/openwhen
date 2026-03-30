import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/navigation/home_tab_provider.dart';
import '../../data/letter_repository_actions.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';
import 'letter_detail_screen.dart';
import '../../../capsules/data/capsule_vault_streams.dart';
import '../../../capsules/presentation/screens/create_capsule_screen.dart';
import '../../../capsules/presentation/screens/capsule_detail_screen.dart';
import '../../../../shared/utils/open_with_proximity.dart';
import '../vault_list_filters.dart';
import '../widgets/vault_filter_sheet.dart';

class VaultScreen extends ConsumerStatefulWidget {
  const VaultScreen({super.key});

  @override
  ConsumerState<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends ConsumerState<VaultScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VaultFiltersState _vaultFilters = VaultFiltersState.initial;
  /// `null` until prefs load; then whether the vault ⋯ hint was already seen.
  bool? _vaultMenuHintSeen;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    SharedPreferences.getInstance().then((p) {
      if (!mounted) return;
      setState(() => _vaultMenuHintSeen = p.getBool('vault_menu_hint_seen') ?? false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _openVaultFilterSheet() async {
    final next = await showVaultFilterSheet(
      context: context,
      tabIndex: _tabController.index,
      current: _vaultFilters,
    );
    if (next != null && mounted) setState(() => _vaultFilters = next);
  }

  String _countdown(DateTime openDate, AppLocalizations l10n) {
    final now = DateTime.now();
    final diff = openDate.difference(now);
    if (diff.isNegative) return l10n.vaultCountdownReady;
    if (diff.inDays > 0) return l10n.vaultCountdownDays(diff.inDays);
    if (diff.inHours > 0) return l10n.vaultCountdownHours(diff.inHours);
    return l10n.vaultCountdownMinutes(diff.inMinutes);
  }

  double _progress(DateTime createdAt, DateTime openDate) {
    final total = openDate.difference(createdAt).inSeconds;
    final elapsed = DateTime.now().difference(createdAt).inSeconds;
    if (total <= 0) return 1.0;
    return (elapsed / total).clamp(0.0, 1.0);
  }

  Future<void> _dismissVaultMenuHint() async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('vault_menu_hint_seen', true);
    if (mounted) setState(() => _vaultMenuHintSeen = true);
  }

  Future<void> _setLetterPublicFromVault(String docId, bool isPublic) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await setLetterPublic(docId: docId, isPublic: isPublic);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    }
  }

  Future<void> _setHideReceiverFromVault(String docId, bool hide) async {
    try {
      await setLetterHideReceiverName(docId: docId, hide: hide);
    } catch (_) {}
  }

  Future<void> _deleteLetterFromVault(String docId) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      await deleteLetterDocument(docId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    }
  }

  void _confirmDeleteLetter(BuildContext context, String docId) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.vaultLetterDeleteTitle),
        content: Text(l10n.vaultLetterDeleteMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.actionCancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _deleteLetterFromVault(docId);
            },
            child: Text(l10n.actionDelete),
          ),
        ],
      ),
    );
  }

  void _showReceivedLetterActionsSheet(
    BuildContext context, {
    required Map<String, dynamic> data,
    required String docId,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final isPublic = data['isPublic'] == true;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: context.pal.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(isPublic ? Icons.lock_outline_rounded : Icons.public_rounded),
              title: Text(isPublic ? l10n.vaultLetterSheetMakePrivate : l10n.vaultLetterSheetMakePublic),
              onTap: () {
                Navigator.pop(ctx);
                _setLetterPublicFromVault(docId, !isPublic);
              },
            ),
            if (isPublic) ListTile(
              leading: Icon(
                (data['hideReceiverName'] ?? false) == true
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: context.pal.inkSoft,
              ),
              title: Text(
                (data['hideReceiverName'] ?? false) == true
                    ? l10n.vaultLetterSheetShowReceiver
                    : l10n.vaultLetterSheetHideReceiver,
              ),
              onTap: () {
                Navigator.pop(ctx);
                _setHideReceiverFromVault(docId, !((data['hideReceiverName'] ?? false) as bool));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline_rounded, color: Colors.red.shade700),
              title: Text(
                l10n.vaultLetterSheetDelete,
                style: TextStyle(color: Colors.red.shade700),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _confirmDeleteLetter(context, docId);
              },
            ),
            ListTile(
              leading: Icon(Icons.star_outline_rounded, color: context.pal.inkFaint),
              title: Text(
                l10n.vaultLetterSheetFavoriteSoon,
                style: GoogleFonts.dmSans(color: context.pal.inkFaint),
              ),
              enabled: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVaultMenuHintBanner(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: context.pal.accentWarm,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lightbulb_outline_rounded, size: 20, color: context.pal.accent),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.vaultMenuHint, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.ink, height: 1.35))),
              TextButton(
                onPressed: _dismissVaultMenuHint,
                child: Text(l10n.vaultMenuHintGotIt, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyReceivedWithCta(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💌', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 16),
            Text(l10n.vaultEmptyReceivedTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(l10n.vaultEmptyReceivedSubtitle, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
            const SizedBox(height: 8),
            Text(l10n.vaultEmptyReceivedCta, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => ref.read(homeTabIndexProvider.notifier).setTab(2),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.pal.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                elevation: 0,
              ),
              child: Text(l10n.vaultEmptyReceivedCtaButton, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(children: [
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.pal.headerGradient,
              ),
            ),
          child: SafeArea(bottom: false, child: Column(children: [
            Stack(children: [
              Positioned(top: -20, right: -20, child: Container(width: 150, height: 150, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [context.pal.accent.withOpacity(0.1), Colors.transparent])))),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Text(l10n.vaultTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: context.pal.white, fontStyle: FontStyle.italic)),
                      const SizedBox(width: 6),
                      const OwlFeedbackAffordance(
                        forDarkHeader: true,
                        child: OwlWatermark(width: 20, height: 24, opacity: 2.2),
                      ),
                    ]),
                    const SizedBox(height: 4),
                    Text(l10n.vaultSubtitle, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.25), fontWeight: FontWeight.w300, letterSpacing: 2)),
                  ]),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Badge(
                      isLabelVisible: _vaultFilters.isActiveForTab(_tabController.index),
                      backgroundColor: context.pal.accent,
                      smallSize: 7,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        tooltip: l10n.vaultFilterTitle,
                        onPressed: _openVaultFilterSheet,
                        icon: Icon(Icons.tune_rounded, size: 18, color: Colors.white.withOpacity(0.85)),
                      ),
                    ),
                  ),
                ]),
              ),
            ]),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              labelColor: context.pal.white,
              unselectedLabelColor: Colors.white.withOpacity(0.3),
              indicatorColor: context.pal.accent,
              indicatorWeight: 2,
              isScrollable: true,
              labelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500),
              unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 13),
              tabs: [
                Tab(text: l10n.vaultTabReceived),
                Tab(text: l10n.vaultTabSent),
                Tab(text: l10n.vaultTabCapsules),
              ],
            ),
          ])),
        ),
        Expanded(child: TabBarView(controller: _tabController, children: [
          _buildReceivedTab(uid),
          _buildSentTab(uid),
          _buildCapsulesTab(uid),
        ])),
      ]),
    );
  }

  Widget _buildReceivedTab(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('receiverUid', isEqualTo: uid)
          .where('status', isEqualTo: 'locked')
          .snapshots(),
      builder: (context, lockedSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirestoreCollections.letters)
              .where('receiverUid', isEqualTo: uid)
              .where('status', isEqualTo: 'opened')
              .snapshots(),
          builder: (context, openedSnap) {
            final l10n = AppLocalizations.of(context)!;
            if (lockedSnap.connectionState == ConnectionState.waiting ||
                openedSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final allDocs = <String, QueryDocumentSnapshot>{};
            for (final doc in [
              ...(lockedSnap.data?.docs ?? []),
              ...(openedSnap.data?.docs ?? []),
            ]) {
              allDocs[doc.id] = doc;
            }
            final raw = allDocs.values.toList();
            if (raw.isEmpty) {
              return _buildEmptyReceivedWithCta(l10n);
            }
            final docs = filterAndSortWaiting(raw, _vaultFilters.waiting);
            if (docs.isEmpty) return _buildFilterEmpty(context);
            final hasOpened = docs.any((d) {
              final m = d.data() as Map<String, dynamic>;
              return (m['status'] ?? 'locked') == 'opened';
            });
            final showHintBanner = _vaultMenuHintSeen == false && hasOpened;
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: docs.length + (showHintBanner ? 1 : 0),
              itemBuilder: (context, i) {
                if (showHintBanner && i == 0) {
                  return _buildVaultMenuHintBanner(l10n);
                }
                final docIndex = showHintBanner ? i - 1 : i;
                final data = docs[docIndex].data() as Map<String, dynamic>;
                final status = data['status'] ?? 'locked';
                if (status == 'opened') {
                  return _buildOpenedCard(context: context, data: data, docId: docs[docIndex].id);
                }
                final openDate = (data['openDate'] as Timestamp).toDate();
                final createdAt = (data['createdAt'] as Timestamp).toDate();
                final canOpen = DateTime.now().isAfter(openDate);
                return _buildLockedCard(
                  context: context,
                  data: data,
                  docId: docs[docIndex].id,
                  openDate: openDate,
                  createdAt: createdAt,
                  canOpen: canOpen,
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSentTab(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('senderUid', isEqualTo: uid)
          .where('status', isEqualTo: 'locked')
          .snapshots(),
      builder: (context, lockedSnap) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(FirestoreCollections.letters)
              .where('senderUid', isEqualTo: uid)
              .where('status', isEqualTo: 'opened')
              .snapshots(),
          builder: (context, openedSnap) {
            final l10n = AppLocalizations.of(context)!;
            if (lockedSnap.connectionState == ConnectionState.waiting ||
                openedSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final allDocs = <String, QueryDocumentSnapshot>{};
            for (final doc in [
              ...(lockedSnap.data?.docs ?? []),
              ...(openedSnap.data?.docs ?? []),
            ]) {
              allDocs[doc.id] = doc;
            }
            final raw = allDocs.values.toList();
            if (raw.isEmpty) {
              return _buildEmpty(
                emoji: '✉️',
                title: l10n.vaultEmptySentTitle,
                subtitle: l10n.vaultEmptySentSubtitle,
              );
            }
            final docs = filterAndSortSent(raw, _vaultFilters.sent);
            if (docs.isEmpty) return _buildFilterEmpty(context);
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final data = docs[i].data() as Map<String, dynamic>;
                final openDate = (data['openDate'] as Timestamp).toDate();
                final createdAt = (data['createdAt'] as Timestamp).toDate();
                return _buildSentCard(context: context, data: data, docId: docs[i].id, openDate: openDate, createdAt: createdAt);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildCapsulesTab(String uid) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: lockedCapsulesSenderStream(uid),
      builder: (context, senderSnap) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: lockedCapsulesCollectiveParticipantStream(uid),
          builder: (context, participantSnap) {
            if (senderSnap.connectionState == ConnectionState.waiting ||
                participantSnap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final raw = mergeLockedCapsuleVaultDocs(senderSnap.data, participantSnap.data);
            if (raw.isEmpty) return _buildEmptyCapsules(context);
            final docs = filterAndSortCapsules(raw, _vaultFilters.capsules);
            if (docs.isEmpty) return _buildFilterEmpty(context);
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: docs.length,
              itemBuilder: (context, i) {
                final data = docs[i].data() as Map<String, dynamic>;
                return _buildCapsuleCard(context: context, data: data, docId: docs[i].id);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSentCard({required BuildContext context, required Map<String, dynamic> data, required String docId, required DateTime openDate, required DateTime createdAt}) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final status = data['status'] ?? 'locked';
    final requestStatus = data['requestStatus'] ?? 'accepted';
    final isOpened = status == 'opened';
    final isPending = requestStatus == 'pending';
    final canOpen = DateTime.now().isAfter(openDate);

    Color statusColor = context.pal.inkSoft;
    String statusLabel = l10n.vaultStatusWaiting;
    String statusEmoji = '🔒';

    if (isPending) {
      statusColor = const Color(0xFFF59E0B);
      statusLabel = l10n.vaultStatusPending;
      statusEmoji = '⏳';
    } else if (isOpened) {
      statusColor = const Color(0xFF10B981);
      statusLabel = l10n.vaultStatusOpened;
      statusEmoji = '💌';
    } else if (canOpen) {
      statusColor = context.pal.accent;
      statusLabel = l10n.vaultStatusReady;
      statusEmoji = '✨';
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LetterDetailScreen(data: data, docId: docId)),
      ),
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.pal.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.pal.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            child: Text('$statusEmoji $statusLabel', style: GoogleFonts.dmSans(fontSize: 11, color: statusColor == context.pal.inkSoft ? context.pal.ink : statusColor, fontWeight: FontWeight.w500)),
          ),
          const Spacer(),
          Text(l10n.vaultTo(data['receiverName'] ?? ''), style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
        ]),
        const SizedBox(height: 12),
        Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: _progress(createdAt, openDate), backgroundColor: const Color(0xFFF0EBE6), valueColor: AlwaysStoppedAnimation<Color>(isOpened ? const Color(0xFF10B981) : canOpen ? context.pal.accent : context.pal.inkFaint), minHeight: 4),
        ),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            isOpened ? l10n.vaultAlreadyOpened : _countdown(openDate, l10n),
            style: GoogleFonts.dmSans(fontSize: 12, color: isOpened ? const Color(0xFF10B981) : canOpen ? context.pal.accent : context.pal.inkSoft, fontWeight: FontWeight.w500),
          ),
          Text(formatShortDate(openDate, locale), style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
        ]),
        if (isPending) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              const Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 14),
              const SizedBox(width: 8),
              Expanded(child: Text(l10n.vaultPendingRecipient, style: GoogleFonts.dmSans(fontSize: 11, color: const Color(0xFFF59E0B)))),
            ]),
          ),
        ],
      ]),
      ),
    );
  }

  Widget _buildCapsuleCard({required BuildContext context, required Map<String, dynamic> data, required String docId}) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final status = data['status'] ?? 'locked';
    final isOpen = status == 'opened';
    final theme = data['theme'] ?? 'memories';
    final title = data['title'] ?? '';
    final openDate = data['openDate'] != null ? (data['openDate'] as Timestamp).toDate() : null;
    final createdAt = data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now();
    final canOpen = openDate != null && DateTime.now().isAfter(openDate);
    final questions = (data['questions'] as List?)?.length ?? 0;
    final photos = (data['photos'] as List?)?.length ?? 0;
    final isCollectiveCapsule = data['isCollective'] == true;

    final themeMap = {
      'memories':      ('🧠', l10n.capsuleThemeMemories,       const Color(0xFF6B6560)),
      'goals':         ('🎯', l10n.capsuleThemeGoals,           const Color(0xFFC0392B)),
      'feelings':      ('💛', l10n.capsuleThemeFeelings,     const Color(0xFFC9A84C)),
      'relationships': ('👥', l10n.capsuleThemeRelationships, const Color(0xFF5B8DB8)),
      'growth':        ('🌱', l10n.capsuleThemeGrowth,     const Color(0xFF4A8C6F)),
    };
    final td = themeMap[theme] ?? ('⏳', l10n.capsuleThemeDefault, const Color(0xFF6B6560));

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isOpen ? context.pal.headerGradient.first : context.pal.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isOpen ? Colors.transparent : context.pal.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: isOpen ? Colors.white.withOpacity(0.1) : td.$3.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Text('${td.$1} ${td.$2}', style: GoogleFonts.dmSans(fontSize: 11, color: isOpen ? Colors.white.withOpacity(0.7) : td.$3, fontWeight: FontWeight.w500)),
          ),
          if (isCollectiveCapsule) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isOpen ? Colors.white.withOpacity(0.12) : context.pal.accentWarm,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isOpen ? Colors.white.withOpacity(0.25) : context.pal.border),
              ),
              child: Text(
                l10n.vaultCapsuleCollectiveBadge,
                style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: isOpen ? Colors.white.withOpacity(0.9) : context.pal.inkSoft),
              ),
            ),
          ],
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: canOpen ? context.pal.accentWarm : (isOpen ? Colors.white.withOpacity(0.08) : context.pal.border), borderRadius: BorderRadius.circular(20), border: Border.all(color: isOpen ? Colors.white.withOpacity(0.15) : (canOpen ? context.pal.accent : context.pal.inkFaint), width: 1)),
            child: Text(isOpen ? l10n.vaultStatusOpened : (canOpen ? l10n.vaultStatusReady : l10n.vaultCapsuleSealed), style: GoogleFonts.dmSans(fontSize: 10, color: isOpen ? context.pal.white : (canOpen ? context.pal.accent : context.pal.ink), fontWeight: FontWeight.w500)),
          ),
        ]),
        const SizedBox(height: 12),
        Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: isOpen ? context.pal.white : context.pal.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 6),
        Row(children: [
          if (photos > 0) ...[
            Icon(Icons.photo_outlined, size: 13, color: isOpen ? Colors.white.withOpacity(0.4) : context.pal.inkSoft),
            const SizedBox(width: 4),
            Text(l10n.vaultPhotoCount(photos), style: GoogleFonts.dmSans(fontSize: 12, color: isOpen ? Colors.white.withOpacity(0.4) : context.pal.inkSoft)),
            const SizedBox(width: 12),
          ],
          Icon(Icons.help_outline_rounded, size: 13, color: isOpen ? Colors.white.withOpacity(0.4) : context.pal.inkSoft),
          const SizedBox(width: 4),
          Text(l10n.vaultAnswerCount(questions), style: GoogleFonts.dmSans(fontSize: 12, color: isOpen ? Colors.white.withOpacity(0.4) : context.pal.inkSoft)),
        ]),
        if (openDate != null) ...[
          const SizedBox(height: 12),
          if (!isOpen) ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _progress(createdAt, openDate), backgroundColor: const Color(0xFFF0EBE6), valueColor: AlwaysStoppedAnimation<Color>(canOpen ? context.pal.accent : context.pal.inkFaint), minHeight: 4)),
          const SizedBox(height: 8),
          if (isOpen)
            Text(l10n.vaultCapsuleOpenedOn(formatShortDate(openDate, locale)), style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w500))
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _countdown(openDate, l10n),
                    style: GoogleFonts.dmSans(fontSize: 12, color: canOpen ? context.pal.accent : context.pal.inkSoft, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(width: 8),
                Text(formatShortDate(openDate, locale), style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
              ],
            ),
        ],
        if (canOpen && !isOpen) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openCapsuleWithProximityGate(
                    context,
                    data: Map<String, dynamic>.from(data),
                    docId: docId,
                  ),
              style: ElevatedButton.styleFrom(backgroundColor: context.pal.accent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
              child: Text(l10n.vaultOpenCapsule, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: context.pal.white)),
            ),
          ),
        ],
        if (isOpen) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CapsuleDetailScreen(data: data, docId: docId),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white.withOpacity(0.2)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                l10n.vaultViewFullCapsule,
                style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withOpacity(0.85)),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildLockedCard({required BuildContext context, required Map<String, dynamic> data, required String docId, required DateTime openDate, required DateTime createdAt, required bool canOpen}) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final isReceiver = data['receiverUid'] == uid;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(18), border: Border.all(color: context.pal.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: canOpen ? context.pal.accentWarm : context.pal.bg, borderRadius: BorderRadius.circular(20)), child: Text(canOpen ? l10n.vaultStatusReady : l10n.vaultStatusLocked, style: GoogleFonts.dmSans(fontSize: 10, color: canOpen ? context.pal.accent : context.pal.inkSoft, fontWeight: FontWeight.w500))),
          const Spacer(),
          Text(isReceiver ? l10n.vaultFrom(data['senderName'] ?? '') : l10n.vaultTo(data['receiverName'] ?? ''), style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
        ]),
        const SizedBox(height: 12),
        Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 12),
        ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: _progress(createdAt, openDate), backgroundColor: const Color(0xFFF0EBE6), valueColor: AlwaysStoppedAnimation<Color>(canOpen ? context.pal.accent : context.pal.inkFaint), minHeight: 4)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(_countdown(openDate, l10n), style: GoogleFonts.dmSans(fontSize: 12, color: canOpen ? context.pal.accent : context.pal.inkSoft, fontWeight: FontWeight.w500)),
          Text(formatShortDate(openDate, locale), style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
        ]),
        if (canOpen && isReceiver) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => openLetterWithProximityGate(
                    context,
                    data: Map<String, dynamic>.from(data),
                    docId: docId,
                  ),
              style: ElevatedButton.styleFrom(backgroundColor: context.pal.accent, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 8, shadowColor: context.pal.accent.withOpacity(0.4)),
              child: Text(l10n.vaultOpenLetter, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: context.pal.white, letterSpacing: 0.5)),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildOpenedCard({required BuildContext context, required Map<String, dynamic> data, required String docId}) {
    final l10n = AppLocalizations.of(context)!;
    final isPublic = data['isPublic'] == true;

    void openDetail() {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LetterDetailScreen(data: data, docId: docId)));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.pal.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: context.pal.border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.pal.accentWarm,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: context.pal.border),
                ),
                child: Text(l10n.vaultLetterOpened, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.accent, fontWeight: FontWeight.w500, letterSpacing: 0.5)),
              ),
              const Spacer(),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: GestureDetector(
                    onTap: () => _setLetterPublicFromVault(docId, !isPublic),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isPublic ? const Color(0xFF10B981).withOpacity(0.1) : Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isPublic ? const Color(0xFF10B981).withOpacity(0.35) : context.pal.border,
                        ),
                      ),
                      child: Text(
                        isPublic ? l10n.vaultLetterChipPublic : l10n.vaultLetterChipPrivate,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: isPublic ? const Color(0xFF10B981) : context.pal.inkSoft,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: Icon(Icons.more_horiz_rounded, color: context.pal.inkSoft),
                onPressed: () => _showReceivedLetterActionsSheet(context, data: data, docId: docId),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(l10n.vaultFrom(data['senderName'] ?? ''), style: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint)),
          const SizedBox(height: 12),
          InkWell(
            onTap: openDetail,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 8),
                  Text(data['message'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: openDetail,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: context.pal.border),
                foregroundColor: context.pal.accent,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(l10n.vaultReadFullLetter, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: context.pal.accent)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty({required String emoji, required String title, required String subtitle}) {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(emoji, style: const TextStyle(fontSize: 48)),
      const SizedBox(height: 16),
      Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      Text(subtitle, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
    ]));
  }

  Widget _buildFilterEmpty(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.filter_alt_off_rounded, size: 48, color: context.pal.inkFaint),
            const SizedBox(height: 16),
            Text(
              l10n.vaultFilterEmptyTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.vaultFilterEmptySubtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCapsules(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text('⏳', style: TextStyle(fontSize: 48)),
      const SizedBox(height: 16),
      Text(l10n.vaultEmptyCapsulesTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
      const SizedBox(height: 8),
      Text(l10n.vaultEmptyCapsulesSubtitle, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
      const SizedBox(height: 24),
      ElevatedButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateCapsuleScreen())),
        style: ElevatedButton.styleFrom(backgroundColor: context.pal.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), elevation: 0),
        child: Text(l10n.vaultCreateCapsule, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600)),
      ),
    ]));
  }
}
