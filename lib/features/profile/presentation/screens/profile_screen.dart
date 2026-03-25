import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _uploadingAvatar = false;

  Future<void> _pickAndUploadAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    setState(() => _uploadingAvatar = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance.ref('avatars/$uid/avatar.jpg');
      await ref.putData(file.bytes!, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({'photoUrl': url});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foto atualizada!', style: GoogleFonts.dmSans()), backgroundColor: AppColors.accent),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e', style: GoogleFonts.dmSans()), backgroundColor: AppColors.accent),
        );
      }
    }
    setState(() => _uploadingAvatar = false);
  }

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
          final photoUrl = data?['photoUrl'] as String?;
          final displayName = data?['displayName'] ?? user?.displayName ?? 'Usuário';
          final username = data?['username'] ?? '';
          final bio = data?['bio'] ?? '';
          final followersCount = data?['followersCount'] ?? 0;
          final followingCount = data?['followingCount'] ?? 0;
          final lettersCount = data?['lettersCount'] ?? 0;

          return Column(children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1A1714), Color(0xFF2C1810), Color(0xFF1A1714)],
                ),
              ),
              child: SafeArea(bottom: false, child: Stack(children: [
                Positioned(top: -30, right: -30, child: Container(width: 180, height: 180, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppColors.accent.withOpacity(0.1), Colors.transparent])))),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
                  child: Column(children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Row(children: [
                        Text('Perfil', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: AppColors.white, fontStyle: FontStyle.italic)), const SizedBox(width: 6), const OwlWatermark(width: 20, height: 24),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isPrivate ? Colors.white.withOpacity(0.08) : AppColors.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: isPrivate ? Colors.white.withOpacity(0.1) : AppColors.accent.withOpacity(0.3)),
                          ),
                          child: Row(children: [
                            Icon(isPrivate ? Icons.lock : Icons.public, size: 10, color: isPrivate ? Colors.white.withOpacity(0.4) : AppColors.accent),
                            const SizedBox(width: 4),
                            Text(isPrivate ? 'Privada' : 'Publica', style: GoogleFonts.dmSans(fontSize: 10, color: isPrivate ? Colors.white.withOpacity(0.4) : AppColors.accent, fontWeight: FontWeight.w500)),
                          ]),
                        ),
                      ]),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                        child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white.withOpacity(0.08))), child: Icon(Icons.settings_outlined, size: 18, color: Colors.white.withOpacity(0.6))),
                      ),
                    ]),
                    const SizedBox(height: 24),
                    Row(children: [
                      // AVATAR
                      GestureDetector(
                        onTap: _uploadingAvatar ? null : _pickAndUploadAvatar,
                        child: Stack(children: [
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent.withOpacity(0.15),
                              border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 2),
                            ),
                            child: _uploadingAvatar
                                ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: AppColors.accent, strokeWidth: 2)))
                                : photoUrl != null
                                    ? ClipOval(child: Image.network(photoUrl, fit: BoxFit.cover, width: 72, height: 72))
                                    : Center(child: Text(displayName.substring(0, 1).toUpperCase(), style: GoogleFonts.dmSerifDisplay(fontSize: 28, color: AppColors.white))),
                          ),
                          Positioned(bottom: 0, right: 0, child: Container(
                            width: 22, height: 22,
                            decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF1A1714), width: 2)),
                            child: const Icon(Icons.camera_alt_rounded, size: 11, color: Colors.white),
                          )),
                        ]),
                      ),
                      const SizedBox(width: 20),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(displayName, style: GoogleFonts.dmSans(fontSize: 18, color: AppColors.white, fontWeight: FontWeight.w600)),
                        if (username.isNotEmpty) ...[
                          const SizedBox(height: 2),
                          Text('@$username', style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.4))),
                        ],
                        if (bio.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(bio, style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.6), height: 1.4)),
                        ],
                      ])),
                    ]),
                    const SizedBox(height: 24),
                    Row(children: [
                      _statItem(lettersCount.toString(), 'Cartas'),
                      _divider(),
                      _statItem(followersCount.toString(), 'Seguidores'),
                      _divider(),
                      _statItem(followingCount.toString(), 'Seguindo'),
                    ]),
                  ]),
                ),
              ])),
            ),
            Expanded(
              child: _buildLettersList(user?.uid ?? ''),
            ),
          ]);
        },
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Expanded(child: Column(children: [
      Text(value, style: GoogleFonts.dmSans(fontSize: 20, color: AppColors.white, fontWeight: FontWeight.w700)),
      const SizedBox(height: 2),
      Text(label, style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.4))),
    ]));
  }

  Widget _divider() {
    return Container(width: 1, height: 32, color: Colors.white.withOpacity(0.1));
  }

  Widget _buildLettersList(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .where('senderUid', isEqualTo: uid)
          .where('status', isEqualTo: 'opened')
          .where('isPublic', isEqualTo: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('💌', style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text('Nenhuma carta publicada', style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Text('Suas cartas abertas e publicas\naparecera aqui', textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5)),
          ]));
        }
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: docs.length,
          itemBuilder: (context, i) {
            final data = docs[i].data() as Map<String, dynamic>;
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
                const SizedBox(height: 6),
                Text(data['message'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5)),
              ]),
            );
          },
        );
      },
    );
  }
}
