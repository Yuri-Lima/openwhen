import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../data/avatar_upload_helper.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _uploadingAvatar = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(FirestoreCollections.users)
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          final data = snapshot.data?.data() as Map<String, dynamic>?;
          final isPrivate = data?['isPrivate'] ?? false;

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
                        padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text('Perfil', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: AppColors.white, fontStyle: FontStyle.italic)),
                                    const SizedBox(width: 6),
                                    const OwlWatermark(width: 20, height: 24),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isPrivate ? Colors.white.withOpacity(0.08) : AppColors.accent.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: isPrivate ? Colors.white.withOpacity(0.1) : AppColors.accent.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(isPrivate ? Icons.lock : Icons.public, size: 10,
                                            color: isPrivate ? Colors.white.withOpacity(0.4) : AppColors.accent),
                                          const SizedBox(width: 4),
                                          Text(isPrivate ? 'Privada' : 'Pública',
                                            style: GoogleFonts.dmSans(fontSize: 10,
                                              color: isPrivate ? Colors.white.withOpacity(0.4) : AppColors.accent,
                                              fontWeight: FontWeight.w500)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                // Botão configurações
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
                            // Avatar
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
                                            backgroundColor: AppColors.accent,
                                            textColor: AppColors.white,
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
                                            color: AppColors.accent,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data?['name'] ?? 'Usuário',
                                      style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.white)),
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
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Contadores
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('follows').where('followingUid', isEqualTo: user?.uid).snapshots(),
                              builder: (context, followersSnap) {
                                final followers = followersSnap.data?.docs.length ?? 0;
                                return StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance.collection('follows').where('followerUid', isEqualTo: user?.uid).snapshots(),
                                  builder: (context, followingSnap) {
                                    final following = followingSnap.data?.docs.length ?? 0;
                                    return Row(
                                      children: [
                                        _buildCounter('Seguidores', followers),
                                        _buildDividerVertical(),
                                        _buildCounter('Seguindo', following),
                                        _buildDividerVertical(),
                                        _buildCounter('Enviadas', data?['lettersSentCount'] ?? 0),
                                        _buildDividerVertical(),
                                        _buildCounter('Abertas', data?['openedLettersCount'] ?? 0),
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
              // Cartas públicas
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection(FirestoreCollections.letters)
                      .where('senderUid', isEqualTo: user?.uid)
                      .where('isPublic', isEqualTo: true)
                      .where('status', isEqualTo: 'opened')
                      .snapshots(),
                  builder: (context, snap) {
                    final docs = snap.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('💌', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text('Nenhuma carta pública ainda',
                              style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
                            const SizedBox(height: 8),
                            Text('Suas cartas públicas abertas\naparecerão aqui',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: docs.length,
                      itemBuilder: (context, i) {
                        final d = docs[i].data() as Map<String, dynamic>;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d['title'] ?? '',
                                style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: AppColors.ink, fontStyle: FontStyle.italic)),
                              const SizedBox(height: 8),
                              Text(d['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.favorite_border, size: 14, color: AppColors.inkFaint),
                                  const SizedBox(width: 4),
                                  Text('${d['likeCount'] ?? 0}',
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

  Widget _buildDividerVertical() => Container(width: 1, height: 32, color: Colors.white.withOpacity(0.08));
}
