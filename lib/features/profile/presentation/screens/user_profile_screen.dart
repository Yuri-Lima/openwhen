import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';

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

  Future<void> _toggleFollow(bool isFollowing) async {
    final firestore = FirebaseFirestore.instance;

    if (isFollowing) {
      // Deixar de seguir
      final snap = await firestore
          .collection('follows')
          .where('followerUid', isEqualTo: _currentUid)
          .where('followingUid', isEqualTo: widget.userId)
          .get();
      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } else {
      // Seguir
      await firestore.collection('follows').add({
        'followerUid': _currentUid,
        'followingUid': widget.userId,
        'createdAt': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          return Column(
            children: [
              // Header escuro
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1A1714), Color(0xFF2C1810), Color(0xFF1A1714)],
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
                            gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.1), Colors.transparent]),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
                        child: Column(
                          children: [
                            // Voltar
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
                            // Avatar + info
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
                                      backgroundColor: AppColors.accent,
                                      textColor: AppColors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(data?['name'] ?? widget.userName,
                                        style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.white)),
                                      const SizedBox(height: 4),
                                      Text('@${data?['username'] ?? ''}',
                                        style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.35), fontWeight: FontWeight.w300)),
                                    ],
                                  ),
                                ),
                                // Botão seguir
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
                                            color: isFollowing ? Colors.transparent : AppColors.accent,
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(
                                              color: isFollowing ? Colors.white.withOpacity(0.2) : AppColors.accent,
                                            ),
                                            boxShadow: isFollowing ? null : [
                                              BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12),
                                            ],
                                          ),
                                          child: Text(
                                            isFollowing ? 'Seguindo' : 'Seguir',
                                            style: GoogleFonts.dmSans(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: isFollowing ? Colors.white.withOpacity(0.6) : AppColors.white,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Contadores
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
                                        _buildCounter('Seguidores', followers),
                                        _buildDivider(),
                                        _buildCounter('Seguindo', following),
                                        _buildDivider(),
                                        _buildCounter('Cartas', data?['lettersSentCount'] ?? 0),
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
              // Cartas públicas do usuário
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
                            Text('Nenhuma carta pública ainda',
                              style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
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
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['title'] ?? '',
                                style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                              Text(data['message'] ?? '', maxLines: 3, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.favorite_border, size: 14, color: AppColors.inkFaint),
                                  const SizedBox(width: 4),
                                  Text('${data['likeCount'] ?? 0}',
                                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkFaint)),
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
          Text(value.toString(), style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: AppColors.white)),
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
