import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/firestore_collections.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';

/// Privacy Center — lets the user see all stored data about them.
///
/// GDPR Art. 15 / LGPD Art. 18: right of access.
/// Reads directly from Firestore (client-side); no new backend required.
class PrivacyCenterScreen extends StatefulWidget {
  const PrivacyCenterScreen({super.key});

  @override
  State<PrivacyCenterScreen> createState() => _PrivacyCenterScreenState();
}

class _PrivacyCenterScreenState extends State<PrivacyCenterScreen> {
  final _uid = FirebaseAuth.instance.currentUser?.uid;
  final _firestore = FirebaseFirestore.instance;

  bool _loading = true;
  String? _error;

  // Collected data
  Map<String, dynamic>? _profile;
  int _sentLettersCount = 0;
  int _receivedLettersCount = 0;
  int _lockedLettersCount = 0;
  int _capsulesCount = 0;
  int _commentsCount = 0;
  int _likesCount = 0;
  int _followersCount = 0;
  int _followingCount = 0;
  int _blocksCount = 0;
  int _badgesCount = 0;
  int _lettersWithLocationCount = 0;

  List<Map<String, dynamic>> _sentLetters = [];
  List<Map<String, dynamic>> _receivedLetters = [];
  List<Map<String, dynamic>> _capsules = [];
  List<Map<String, dynamic>> _comments = [];
  List<Map<String, dynamic>> _badges = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    final uid = _uid;
    if (uid == null) {
      setState(() {
        _error = 'not_authenticated';
        _loading = false;
      });
      return;
    }

    try {
      // Run all queries in parallel (limited to 500 docs each to cap memory/cost).
      // Privacy center shows a summary; full export uses a dedicated function.
      const privacyLimit = 500;
      final results = await Future.wait([
        _firestore.collection(FirestoreCollections.users).doc(uid).get(),                                            // 0: profile
        _firestore.collection(FirestoreCollections.letters).where('senderUid', isEqualTo: uid).limit(privacyLimit).get(),    // 1: sent
        _firestore.collection(FirestoreCollections.letters).where('receiverUid', isEqualTo: uid).limit(privacyLimit).get(),  // 2: received
        _firestore.collection(FirestoreCollections.capsules).where('senderUid', isEqualTo: uid).limit(privacyLimit).get(),   // 3: capsules
        _firestore.collection(FirestoreCollections.comments).where('userUid', isEqualTo: uid).limit(privacyLimit).get(),     // 4: comments
        _firestore.collection(FirestoreCollections.likes).where('userUid', isEqualTo: uid).limit(privacyLimit).get(),        // 5: likes
        _firestore.collection(FirestoreCollections.follows).where('followingUid', isEqualTo: uid).limit(privacyLimit).get(), // 6: followers
        _firestore.collection(FirestoreCollections.follows).where('followerUid', isEqualTo: uid).limit(privacyLimit).get(),  // 7: following
        _firestore.collection(FirestoreCollections.blocks).where('blockedBy', isEqualTo: uid).limit(privacyLimit).get(),     // 8: blocks
        _firestore.collection('users/$uid/badgeUnlocks').limit(privacyLimit).get(),                                          // 9: badges
      ]);

      final profileSnap = results[0] as DocumentSnapshot;
      final sentSnap = results[1] as QuerySnapshot;
      final receivedSnap = results[2] as QuerySnapshot;
      final capsulesSnap = results[3] as QuerySnapshot;
      final commentsSnap = results[4] as QuerySnapshot;
      final likesSnap = results[5] as QuerySnapshot;
      final followersSnap = results[6] as QuerySnapshot;
      final followingSnap = results[7] as QuerySnapshot;
      final blocksSnap = results[8] as QuerySnapshot;
      final badgesSnap = results[9] as QuerySnapshot;

      // Count letters with GPS
      int locationCount = 0;
      for (final doc in sentSnap.docs) {
        if (doc.data() is Map && (doc.data() as Map)['senderLocation'] != null) {
          locationCount++;
        }
      }

      if (!mounted) return;

      setState(() {
        _profile = profileSnap.data() as Map<String, dynamic>?;

        _sentLettersCount = sentSnap.size;
        _receivedLettersCount = receivedSnap.size;
        _lockedLettersCount = sentSnap.docs.where((d) {
          final data = d.data() as Map<String, dynamic>?;
          return data?['status'] == 'locked';
        }).length;
        _capsulesCount = capsulesSnap.size;
        _commentsCount = commentsSnap.size;
        _likesCount = likesSnap.size;
        _followersCount = followersSnap.size;
        _followingCount = followingSnap.size;
        _blocksCount = blocksSnap.size;
        _badgesCount = badgesSnap.size;
        _lettersWithLocationCount = locationCount;

        _sentLetters = sentSnap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList();
        _receivedLetters = receivedSnap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList();
        _capsules = capsulesSnap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList();
        _comments = commentsSnap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList();
        _badges = badgesSnap.docs
            .map((d) => {'id': d.id, ...d.data() as Map<String, dynamic>})
            .toList();

        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.pal.bg,
      appBar: AppBar(
        backgroundColor: context.pal.headerGradient.first,
        foregroundColor: context.pal.white,
        title: Text(
          l10n.privacyCenterTitle,
          style: GoogleFonts.dmSerifDisplay(
              fontSize: 20, fontStyle: FontStyle.italic),
        ),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: context.pal.accent))
          : _error != null
              ? _buildError()
              : _buildContent(l10n),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(
          _error ?? '',
          style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.inkSoft),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    final createdAt = _profile?['createdAt'] as Timestamp?;
    final createdStr = createdAt != null
        ? _formatDate(createdAt.toDate())
        : '—';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ── Intro ──
        _buildInfoBox(l10n.privacyCenterIntro),

        const SizedBox(height: 16),

        // ── Profile ──
        _buildSection(
          icon: Icons.person_outline,
          title: l10n.privacyCenterProfile,
          children: [
            _buildDataRow(l10n.privacyCenterFieldName, _profile?['name'] ?? '—'),
            _buildDataRow(l10n.privacyCenterFieldUsername, _profile?['username'] ?? '—'),
            _buildDataRow(l10n.privacyCenterFieldEmail, _profile?['email'] ?? '—'),
            _buildDataRow(l10n.privacyCenterFieldBio, _profile?['bio'] ?? '—'),
            _buildDataRow(l10n.privacyCenterFieldCountry, _profile?['country'] ?? '—'),
            _buildDataRow(l10n.privacyCenterFieldLanguage, _profile?['language'] ?? '—'),
            _buildDataRow(l10n.privacyCenterFieldCreatedAt, createdStr),
            _buildDataRow(l10n.privacyCenterFieldPhoto, _profile?['photoUrl'] != null
                ? l10n.privacyCenterYes
                : l10n.privacyCenterNo),
          ],
        ),

        // ── Letters ──
        _buildSection(
          icon: Icons.mail_outline,
          title: l10n.privacyCenterLetters,
          children: [
            _buildCountRow(l10n.privacyCenterLettersSent, _sentLettersCount),
            _buildCountRow(l10n.privacyCenterLettersReceived, _receivedLettersCount),
            _buildCountRow(l10n.privacyCenterLettersLocked, _lockedLettersCount),
            _buildCountRow(l10n.privacyCenterLettersWithLocation, _lettersWithLocationCount),
            if (_sentLetters.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailList(
                _sentLetters,
                (item) => '${item['title'] ?? '—'} → ${item['receiverName'] ?? '?'}',
                (item) => item['status'] as String? ?? '',
              ),
            ],
          ],
        ),

        // ── Capsules ──
        _buildSection(
          icon: Icons.auto_awesome_outlined,
          title: l10n.privacyCenterCapsules,
          children: [
            _buildCountRow(l10n.privacyCenterCapsulesTotal, _capsulesCount),
            if (_capsules.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailList(
                _capsules,
                (item) => item['title'] as String? ?? '—',
                (item) => item['status'] as String? ?? '',
              ),
            ],
          ],
        ),

        // ── Social ──
        _buildSection(
          icon: Icons.people_outline,
          title: l10n.privacyCenterSocial,
          children: [
            _buildCountRow(l10n.privacyCenterFollowers, _followersCount),
            _buildCountRow(l10n.privacyCenterFollowing, _followingCount),
            _buildCountRow(l10n.privacyCenterBlocks, _blocksCount),
          ],
        ),

        // ── Engagement ──
        _buildSection(
          icon: Icons.favorite_outline,
          title: l10n.privacyCenterEngagement,
          children: [
            _buildCountRow(l10n.privacyCenterComments, _commentsCount),
            _buildCountRow(l10n.privacyCenterLikes, _likesCount),
          ],
        ),

        // ── Badges ──
        _buildSection(
          icon: Icons.emoji_events_outlined,
          title: l10n.privacyCenterBadges,
          children: [
            _buildCountRow(l10n.privacyCenterBadgesUnlocked, _badgesCount),
            if (_badges.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildDetailList(
                _badges,
                (item) => item['id'] as String? ?? '—',
                (item) {
                  final ts = item['unlockedAt'] as Timestamp?;
                  return ts != null ? _formatDate(ts.toDate()) : '';
                },
              ),
            ],
          ],
        ),

        // ── Billing ──
        _buildSection(
          icon: Icons.credit_card_outlined,
          title: l10n.privacyCenterBilling,
          children: [
            _buildDataRow(l10n.privacyCenterSubscriptionTier,
                _profile?['subscriptionTier'] ?? 'free'),
            _buildDataRow(l10n.privacyCenterSubscriptionStatus,
                _profile?['subscriptionStatus'] ?? '—'),
          ],
        ),

        // ── Location ──
        _buildSection(
          icon: Icons.location_on_outlined,
          title: l10n.privacyCenterLocation,
          children: [
            _buildInfoBox(l10n.privacyCenterLocationExplainer),
            _buildCountRow(l10n.privacyCenterLettersWithLocation, _lettersWithLocationCount),
          ],
        ),

        const SizedBox(height: 32),
      ],
    );
  }

  // ── UI Building Blocks ──

  Widget _buildSection({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        decoration: BoxDecoration(
          color: context.pal.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.pal.border),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            leading: Icon(icon, size: 20, color: context.pal.accent),
            title: Text(title,
                style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: context.pal.ink)),
            childrenPadding:
                const EdgeInsets.fromLTRB(16, 0, 16, 16),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 12,
                    color: context.pal.inkSoft,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: GoogleFonts.dmSans(
                    fontSize: 12, color: context.pal.ink)),
          ),
        ],
      ),
    );
  }

  Widget _buildCountRow(String label, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(label,
                style: GoogleFonts.dmSans(
                    fontSize: 12, color: context.pal.inkSoft)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: context.pal.accent.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('$count',
                style: GoogleFonts.dmSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: context.pal.accent)),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.pal.accent.withValues(alpha:0.06),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text,
          style: GoogleFonts.dmSans(
              fontSize: 12,
              color: context.pal.inkSoft,
              height: 1.5)),
    );
  }

  Widget _buildDetailList(
    List<Map<String, dynamic>> items,
    String Function(Map<String, dynamic>) titleBuilder,
    String Function(Map<String, dynamic>) subtitleBuilder,
  ) {
    // Show max 5 items with a "and X more" indicator
    final displayItems = items.take(5).toList();
    final remaining = items.length - displayItems.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in displayItems)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                Icon(Icons.circle, size: 4, color: context.pal.inkFaint),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    titleBuilder(item),
                    style: GoogleFonts.dmSans(
                        fontSize: 11, color: context.pal.ink),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  subtitleBuilder(item),
                  style: GoogleFonts.dmSans(
                      fontSize: 10, color: context.pal.inkFaint),
                ),
              ],
            ),
          ),
        if (remaining > 0)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '+$remaining',
              style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: context.pal.inkFaint,
                  fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
