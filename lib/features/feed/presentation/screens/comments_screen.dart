import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';

// Lista de palavras proibidas
const List<String> _palavrasProibidas = [
  'idiota', 'imbecil', 'burro', 'estupido', 'estúpido',
  'lixo', 'merda', 'puta', 'viado', 'fdp',
  'canalha', 'vagabundo', 'prostituta', 'desgraça',
  'maldito', 'inferno', 'otario', 'otário',
  'odeio', 'morra', 'morte',
];

bool _contemPalavraProibida(String texto) {
  final textoLower = texto.toLowerCase();
  for (final palavra in _palavrasProibidas) {
    if (textoLower.contains(palavra)) return true;
  }
  return false;
}

class CommentsScreen extends StatefulWidget {
  final String letterId;
  final String letterTitle;

  const CommentsScreen({
    super.key,
    required this.letterId,
    required this.letterTitle,
  });

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final _commentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _sendComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // Filtro de palavras ofensivas
    if (_contemPalavraProibida(text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Sua mensagem contém palavras inadequadas. O OpenWhen é um espaço de amor e respeito. 💌',
            style: GoogleFonts.dmSans(fontSize: 13),
          ),
          backgroundColor: AppColors.accent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final userDoc = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(user.uid)
          .get();
      final userName = userDoc.data()?['name'] ?? user.email ?? '';

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.comments)
          .add({
        'letterId': widget.letterId,
        'userUid': user.uid,
        'userName': userName,
        'message': text,
        'createdAt': Timestamp.now(),
      });

      await FirebaseFirestore.instance
          .collection(FirestoreCollections.letters)
          .doc(widget.letterId)
          .update({'commentCount': FieldValue.increment(1)});

      _commentController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: $e')),
        );
      }
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                          border: Border.all(color: Colors.white.withOpacity(0.08)),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Comentários', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.white, fontStyle: FontStyle.italic)),
                          Text(widget.letterTitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.dmSans(fontSize: 11, color: Colors.white.withOpacity(0.3))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lista de comentários
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection(FirestoreCollections.comments)
                  .where('letterId', isEqualTo: widget.letterId)
                  .orderBy('createdAt', descending: false)
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
                        const Text('💬', style: TextStyle(fontSize: 40)),
                        const SizedBox(height: 12),
                        Text('Nenhum comentário ainda', style: GoogleFonts.dmSerifDisplay(fontSize: 16, color: AppColors.ink, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 8),
                        Text('Seja o primeiro a comentar', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft)),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: docs.length,
                  itemBuilder: (context, i) {
                    final data = docs[i].data() as Map<String, dynamic>;
                    final createdAt = (data['createdAt'] as Timestamp).toDate();
                    final isMe = data['userUid'] == FirebaseAuth.instance.currentUser?.uid;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isMe ? AppColors.ink : AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: isMe ? Colors.transparent : AppColors.border),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 36, height: 36,
                            decoration: BoxDecoration(
                              color: isMe ? AppColors.accent : AppColors.accentWarm,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (data['userName'] as String? ?? 'U').substring(0, 1).toUpperCase(),
                                style: GoogleFonts.dmSerifDisplay(fontSize: 14, color: isMe ? AppColors.white : AppColors.accent, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data['userName'] ?? '',
                                      style: GoogleFonts.dmSans(fontSize: 13, color: isMe ? AppColors.white : AppColors.ink, fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${createdAt.day}/${createdAt.month}',
                                      style: GoogleFonts.dmSans(fontSize: 11, color: isMe ? Colors.white.withOpacity(0.3) : AppColors.inkFaint),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  data['message'] ?? '',
                                  style: GoogleFonts.dmSans(fontSize: 14, color: isMe ? Colors.white.withOpacity(0.8) : AppColors.inkSoft, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // Campo de comentário
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 12,
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.bg,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _commentController,
                      style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Escreva com amor... 💌',
                        hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint, fontSize: 14),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _isLoading ? null : _sendComment,
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: _isLoading
                        ? const Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
