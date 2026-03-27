import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/user_avatar.dart';

class LetterRequestsScreen extends StatelessWidget {
  const LetterRequestsScreen({super.key});

  Future<void> _accept(String docId) async {
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(docId)
        .update({'requestStatus': 'accepted'});
  }

  Future<void> _decline(String docId) async {
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(docId)
        .delete();
  }

  Future<void> _block(BuildContext context, String docId, String senderUid) async {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance.collection('blocks').add({
      'blockedBy': currentUid,
      'blockedUid': senderUid,
      'createdAt': Timestamp.now(),
    });
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(docId)
        .delete();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Usuário bloqueado.',
            style: GoogleFonts.dmSans(fontSize: 13)),
          backgroundColor: AppColors.ink,
        ),
      );
    }
  }

  void _showOptions(BuildContext context, String docId, String senderUid, String senderName) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 36, height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('O que deseja fazer?',
              style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 6),
            Text('Carta de $senderName',
              style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft)),
            const SizedBox(height: 24),
            // Aceitar
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await _accept(docId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Carta aceita! Ela aparecerá no seu cofre. 💌',
                        style: GoogleFonts.dmSans(fontSize: 13)),
                      backgroundColor: AppColors.accent,
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text('Aceitar carta', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Recusar
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await _decline(docId);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Carta recusada.',
                        style: GoogleFonts.dmSans(fontSize: 13)),
                      backgroundColor: AppColors.ink,
                    ),
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.close_rounded, color: AppColors.inkSoft, size: 20),
                    const SizedBox(width: 8),
                    Text('Recusar carta', style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.inkSoft)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Bloquear
            GestureDetector(
              onTap: () async {
                Navigator.pop(context);
                await _block(context, docId, senderUid);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.block_rounded, color: AppColors.accent, size: 20),
                    const SizedBox(width: 8),
                    Text('Bloquear $senderName', style: GoogleFonts.dmSans(fontSize: 15, color: AppColors.accent)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
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
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Pedidos de carta',
                          style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: AppColors.white, fontStyle: FontStyle.italic)),
                        Text('De pessoas que você não segue',
                          style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.3))),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lista
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreCollections.letters)
                  .where('receiverUid', isEqualTo: uid)
                  .where('requestStatus', isEqualTo: 'pending')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data?.docs ?? [];
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💌', style: TextStyle(fontSize: 48)),
                        const SizedBox(height: 16),
                        Text('Nenhum pedido pendente',
                          style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: AppColors.ink, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Text('Quando alguém que você não segue\nte enviar uma carta, aparecerá aqui.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.6)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final openDate = (data['openDate'] as Timestamp).toDate();
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
                          Row(
                            children: [
                              StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection(FirestoreCollections.users)
                                    .doc(data['senderUid'] as String? ?? '')
                                    .snapshots(),
                                builder: (context, userSnap) {
                                  final map = userSnap.data?.data() as Map<String, dynamic>?;
                                  final photoUrl = map?['photoUrl'] as String?;
                                  return UserAvatar(
                                    photoUrl: photoUrl,
                                    name: data['senderName'] as String? ?? 'U',
                                    size: 40,
                                    backgroundColor: AppColors.accentWarm,
                                    textColor: AppColors.accent,
                                  );
                                },
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(data['senderName'] ?? '',
                                    style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink)),
                                  Text('Pessoa que você não segue',
                                    style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                                ],
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.accentWarm,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text('Pendente',
                                  style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(data['title'] ?? '',
                            style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: AppColors.ink, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 6),
                          // Mensagem desfocada
                          Stack(
                            children: [
                              Text(
                                data['message'] ?? '',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft, height: 1.5),
                              ),
                              Positioned.fill(
                                child: ClipRect(
                                  child: BackdropFilter(
                                    filter: const ColorFilter.matrix([
                                      0, 0, 0, 0, 1,
                                      0, 0, 0, 0, 1,
                                      0, 0, 0, 0, 1,
                                      0, 0, 0, 0.08, 0,
                                    ]),
                                    child: Container(color: AppColors.white.withOpacity(0.85)),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: Center(
                                  child: Text('Aceite para revelar a mensagem',
                                    style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkFaint, fontStyle: FontStyle.italic)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Abre em ${openDate.day}/${openDate.month}/${openDate.year}',
                            style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _showOptions(context, docs[i].id, data['senderUid'] ?? '', data['senderName'] ?? ''),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: AppColors.accent,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text('Ver opções', textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
