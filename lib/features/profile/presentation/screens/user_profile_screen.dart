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

class UserProfileScreen extends ConsumerStatefulWidget {
  final String userId;
  final String userName;

  const UserProfileScreen({
    super.key,
    required this.userId,
    required this.userName,
  });

  @override
  ConsumerState<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  final _currentUid = FirebaseAuth.instance.currentUser?.uid;

  static int _asInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> _toggleFollow(bool isFollowing) async {
    if (_currentUid == null || _currentUid == widget.userId) return;

    final firestore = FirebaseFirestore.instance;

    if (isFollowing) {
      final snap = await firestore
          .collection('follows')
          .where('followerUid', isEqualTo: _currentUid)
          .where('followingUid', isEqualTo: widget.userId)
          .get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } else {
      await firestore.collection('follows').add({
        'followerUid': _currentUid,
        'followingUid': widget.userId,
        'createdAt': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

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
                        top: 12,
                        right: 16,
                        child: const OwlFeedbackAffordance(
                          forDarkHeader: true,
                          child: OwlWatermark(opacity: 2.2),
                        ),
                      ),
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
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 36, height: 36,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
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
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data?['name'] ?? widget.userName,
                                        style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: context.pal.white)),
                                      const SizedBox(height: 4),
                                      Text('@${data?['username'] ?? ''}',
                                        style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.35), fontWeight: FontWeight.w300)),
                                    ],
                                  ),
                                ),
                                if (_currentUid != widget.userId)
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('follows')
                                        .where('followerUid', isEqualTo: _currentUid)
                                        .where('followingUid', isEqualTo: widget.userId)
                                        .snapshots(),
                                    builder: (context, followSnap) {
                                      final isFollowing = (followSnap.data?.docs ?? []).isNotEmpty;
                                      return GestureDetector(
                                        onTap: () => _toggleFollow(isFollowing),
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: isFollowing ? Colors.transparent : context.pal.accent,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isFollowing ? Colors.white.withOpacity(0.2) : context.pal.accent,
                                            ),
                                            boxShadow: isFollowing ? null : [
                                              BoxShadow(color: context.pal.accent.withOpacity(0.3), blurRadius: 12),
                                            ],
                                          ),
                                          child: Text(
                                            isFollowing ? l10n.userProfileFollowing : l10n.userProfileFollow,
                                            style: GoogleFonts.dmSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: isFollowing ? Colors.white.withOpacity(0.6) : context.pal.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('follows')
                                  .where('followingUid', isEqualTo: widget.userId)
                                  .snapshots(),
                              builder: (context, followersSnap) {
                                final followers = followersSnap.data?.docs.length ?? 0;
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('follows')
                                      .where('followerUid', isEqualTo: widget.userId)
                                      .snapshots(),
                                  builder: (context, followingSnap) {
                                    final following = followingSnap.data?.docs.length ?? 0;
                                    return Row(
                                      children: [
                                        _buildCounter(l10n.profileStatFollowers, followers),
                                        _buildDivider(),
                                        _buildCounter(l10n.profileStatFollowing, following),
                                        _buildDivider(),
                                        _buildCounter(l10n.profileStatLetters, _asInt(data?['lettersSentCount'])),
                                      ],
                                    );
                                  },
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
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.letters)
                      .where('senderUid', isEqualTo: widget.userId)
                      .where('isPublic', isEqualTo: true)
                      .where('status', isEqualTo: 'opened')
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('💌', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(l10n.userProfileEmptyLetters,
                              style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: context.pal.ink, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final data = docs[i].data() as Map<String, dynamic>;
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
                              Text(data['title'] ?? '',
                                style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.ink, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                              Text(data['message'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.inkSoft, height: 1.6)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.favorite_border, size: 14, color: context.pal.inkFaint),
                                  const SizedBox(width: 4),
                                  Text('${data['likeCount'] ?? 0}',
                                    style: GoogleFonts.dmSans(fontSize: 12, color: context.pal.inkFaint)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
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

  Widget _buildDivider() {
    return Container(width: 1, height: 32, color: Colors.white.withOpacity(0.08));
  }
}
