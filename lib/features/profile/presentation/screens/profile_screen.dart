import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                                    const SizedBox(width: 8),
                                    // Badge conta privada/pública
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
                                GestureDetector(
                                  onTap: () => ref.read(authNotifierProvider.notifier).signOut(),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                                    ),
                                    child: Text('Sair', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.6))),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Avatar
                            Row(
                              children: [
                                Container(
                                  width: 72, height: 72,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white.withOpacity(0.1), width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      (data?['name'] as String? ?? 'U').substring(0, 1).toUpperCase(),
                                      style: GoogleFonts.dmSerifDisplay(fontSize: 28, color: AppColors.white, fontStyle: FontStyle.italic),
                                    ),
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
              // Conteúdo
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Toggle conta privada/pública
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: SwitchListTile(
                          title: Text('Conta privada',
                            style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.ink)),
                          subtitle: Text(
                            isPrivate
                                ? 'Suas cartas não aparecem no feed público'
                                : 'Suas cartas podem aparecer no feed público',
                            style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft)),
                          secondary: Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: isPrivate ? AppColors.bg : AppColors.accentWarm,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(isPrivate ? Icons.lock_outline : Icons.public,
                              size: 18, color: isPrivate ? AppColors.inkSoft : AppColors.accent),
                          ),
                          value: isPrivate,
                          activeColor: AppColors.accent,
                          onChanged: (value) async {
                            await FirebaseFirestore.instance
                                .collection(FirestoreCollections.users)
                                .doc(user?.uid)
                                .update({'isPrivate': value});
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Sobre
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Sobre', style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink)),
                            const SizedBox(height: 12),
                            _buildInfoRow(Icons.mail_outline, user?.email ?? ''),
                            const SizedBox(height: 8),
                            _buildInfoRow(Icons.language, data?['language'] ?? 'pt-BR'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Menu
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          children: [
                            _buildMenuItem(Icons.notifications_outlined, 'Notificações', () {}),
                            Divider(height: 1, color: AppColors.border),
                            _buildMenuItem(Icons.help_outline, 'Ajuda', () {}),
                            Divider(height: 1, color: AppColors.border),
                            _buildMenuItem(Icons.logout, 'Sair', () {
                              ref.read(authNotifierProvider.notifier).signOut();
                            }, color: AppColors.accent),
                          ],
                        ),
                      ),
                    ],
                  ),
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

  Widget _buildInfoRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.inkFaint),
        const SizedBox(width: 10),
        Text(label, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.inkSoft)),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color ?? AppColors.inkSoft),
            const SizedBox(width: 14),
            Text(label, style: GoogleFonts.dmSans(fontSize: 15, color: color ?? AppColors.ink)),
            const Spacer(),
            if (color == null) Icon(Icons.chevron_right, size: 18, color: AppColors.inkFaint),
          ],
        ),
      ),
    );
  }
}
