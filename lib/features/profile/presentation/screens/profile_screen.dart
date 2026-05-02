import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/avatar_upload_helper.dart';
import '../../../gamification/profile_badges_strip.dart';
import '../widgets/sealed_letter_card.dart';
import 'settings_screen.dart';
import 'followers_list_screen.dart';
import '../../../letters/presentation/screens/vault_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _uploadingAvatar = false;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.pal.bg,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final isPrivate = data?['isPrivate'] ?? false;
          final photoUrl = data?['photoUrl'] as String?;
          final displayName = data?['displayName'] ?? user?.displayName ?? 'Usuário';
          final username = data?['username'] ?? '';
          final bio = data?['bio'] ?? '';
          final followersCount = data?['followersCount'] ?? 0;
          final followingCount = data?['followingCount'] ?? 0;
          final lettersCount = data?['lettersCount'] ?? 0;

          return Column(
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
                  child: Stack(
                    children: [
                      Positioned(
                        top: -30, right: -30,
                        child: Container(
                          width: 180, height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [context.pal.accent.withOpacity(0.1), Colors.transparent]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(l10n.profileTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: context.pal.white, fontStyle: FontStyle.italic)),
                                    const SizedBox(width: 6),
                                    const OwlFeedbackAffordance(
                                      forDarkHeader: true,
                                      child: OwlWatermark(width: 20, height: 24, opacity: 2.2),
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                                  child: Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                                    ),
                                    child: Icon(Icons.settings_outlined, size: 18, color: Colors.white.withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: user?.uid == null || _uploadingAvatar
                                      ? null
                                      : () async {
                                          setState(() => _uploadingAvatar = true);
                                          try {
                                            await AvatarUploadHelper.showAvatarOptions(context, user!.uid);
                                          } finally {
                                            if (mounted) setState(() => _uploadingAvatar = false);
                                          }
                                        },
                                  child: Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 72,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                                        ),
                                        child: ClipOval(
                                          child: UserAvatar(
                                            photoUrl: data?['photoUrl'] as String?,
                                            name: data?['name'] as String? ?? 'U',
                                            size: 72,
                                            backgroundColor: context.pal.accent,
                                            textColor: context.pal.white,
                                          ),
                                        ),
                                      ),
                                      if (_uploadingAvatar)
                                        Positioned.fill(
                                          child: Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.black38,
                                            ),
                                            child: const Center(
                                              child: SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ),
                                      Positioned(
                                        right: -2,
                                        bottom: -2,
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: context.pal.accent,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: const Color(0xFF1A1714), width: 2),
                                          ),
                                          child: Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white.withOpacity(0.95)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(data?['name'] ?? l10n.profileDefaultName,
                                              style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.white)),
                                            const SizedBox(height: 4),
                                            Text('@${data?['username'] ?? ''}',
                                              style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.35), fontWeight: FontWeight.w300)),
                                            if (data?['bio'] != null && (data?['bio'] as String).isNotEmpty) ...[
                                              const SizedBox(height: 4),
                                              Text(data?['bio'] ?? '',
                                                style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.5))),
                                            ],
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      _buildPrivacyBadge(context, isPrivate, l10n),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Builder(
                              builder: (context) {
                                final followers = (data?['followersCount'] as num?)?.toInt() ?? 0;
                                final following = (data?['followingCount'] as num?)?.toInt() ?? 0;
                                final lettersSent = (data?['lettersSentCount'] as num?)?.toInt() ?? 0;
                                final opened = (data?['openedLettersCount'] as num?)?.toInt() ?? 0;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      children: [
                                        _buildTappableCounter(l10n.profileStatFollowers, followers, () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (_) => FollowersListScreen(userId: user!.uid, initialTabFollowers: true),
                                          ));
                                        }),
                                        _buildDividerVertical(),
                                        _buildTappableCounter(l10n.profileStatFollowing, following, () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (_) => FollowersListScreen(userId: user!.uid, initialTabFollowers: false),
                                          ));
                                        }),
                                        _buildDividerVertical(),
                                        _buildTappableCounter(l10n.profileStatSent, lettersSent, () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (_) => const VaultScreen(initialTabIndex: 1),
                                          ));
                                        }),
                                        _buildDividerVertical(),
                                        _buildTappableCounter(l10n.profileStatOpened, opened, () {
                                          Navigator.push(context, MaterialPageRoute(
                                            builder: (_) => const VaultScreen(initialTabIndex: 0),
                                          ));
                                        }),
                                      ],
                                    ),
                                    const ProfileBadgesStrip(),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // ── Tabs: Abertas | Seladas ──
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: context.pal.border, width: 1)),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: context.pal.accent,
                  unselectedLabelColor: context.pal.inkFaint,
                  labelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600),
                  unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w400),
                  indicatorColor: context.pal.accent,
                  indicatorWeight: 2.5,
                  tabs: [
                    Tab(text: l10n.profileTabOpened),
                    Tab(text: l10n.profileTabSealed),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLettersList(user?.uid ?? ''),
                    _buildSealedLettersList(user?.uid ?? ''),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPrivacyBadge(BuildContext context, bool isPrivate, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPrivate ? Colors.white.withOpacity(0.08) : context.pal.accent.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isPrivate ? Colors.white.withOpacity(0.1) : context.pal.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPrivate ? Icons.lock : Icons.public,
            size: 10,
            color: isPrivate ? Colors.white.withOpacity(0.4) : context.pal.accent,
          ),
          const SizedBox(width: 4),
          Text(
            isPrivate ? l10n.profilePrivate : l10n.profilePublic,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: isPrivate ? Colors.white.withOpacity(0.4) : context.pal.accent,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int value) {
    return Expanded(
      child: Column(
        children: [
          Text(value.toString(), style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: context.pal.white)),
          const SizedBox(height: 2),
          Text(label, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w300)),
        ],
      ),
    );
  }

  Widget _buildTappableCounter(String label, int value, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Text(value.toString(), style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: context.pal.white)),
            const SizedBox(height: 2),
            Text(label, style: GoogleFonts.dmSans(fontSize: 10, color: Colors.white.withOpacity(0.3), fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }

  Widget _buildDividerVertical() {
    return Container(width: 1, height: 32, color: Colors.white.withOpacity(0.08));
  }

  Widget _buildLettersList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('senderUid', isEqualTo: uid)
          .where('status', isEqualTo: 'opened')
          .where('isPublic', isEqualTo: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context)!;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('💌', style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(l10n.profileEmptyTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: context.pal.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Text(l10n.profileEmptySubtitle, textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
          ]));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final letterData = docs[i].data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: context.pal.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: context.pal.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(letterData['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: context.pal.ink, fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(letterData['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.5)),
              ]),
            );
          },
        );
      },
    );
  }

  Widget _buildSealedLettersList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('receiverUid', isEqualTo: uid)
          .where('status', isEqualTo: 'locked')
          .orderBy('openDate')
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        final l10n = AppLocalizations.of(context)!;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🔒', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 12),
                Text(l10n.profileSealedEmptyTitle,
                    style: GoogleFonts.dmSerifDisplay(
                        fontSize: 16,
                        color: context.pal.ink,
                        fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(l10n.profileSealedEmptySubtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: context.pal.inkSoft,
                        height: 1.5)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final letterData = docs[i].data() as Map<String, dynamic>;
            return SealedLetterCard(data: letterData);
          },
        );
      },
    );
  }
}
