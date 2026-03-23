import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';

class EmotionalState {
  final String key;
  final String label;
  final String emoji;
  final Color color;
  final Color bgColor;

  const EmotionalState({
    required this.key,
    required this.label,
    required this.emoji,
    required this.color,
    required this.bgColor,
  });
}

const List<EmotionalState> emotionalStates = [
  EmotionalState(key: 'love', label: 'Amor', emoji: '💕', color: Color(0xFFE91E8C), bgColor: Color(0xFFFCE4F3)),
  EmotionalState(key: 'achievement', label: 'Conquista', emoji: '🏆', color: Color(0xFFF59E0B), bgColor: Color(0xFFFEF3C7)),
  EmotionalState(key: 'advice', label: 'Conselho', emoji: '🌿', color: Color(0xFF10B981), bgColor: Color(0xFFD1FAE5)),
  EmotionalState(key: 'nostalgia', label: 'Saudade', emoji: '🍂', color: Color(0xFFD97706), bgColor: Color(0xFFFEF3C7)),
  EmotionalState(key: 'farewell', label: 'Despedida', emoji: '🦋', color: Color(0xFF8B5CF6), bgColor: Color(0xFFEDE9FE)),
];

class WriteLetterScreen extends ConsumerStatefulWidget {
  const WriteLetterScreen({super.key});

  @override
  ConsumerState<WriteLetterScreen> createState() => _WriteLetterScreenState();
}

class _WriteLetterScreenState extends ConsumerState<WriteLetterScreen> {
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();
  final _receiverEmailController = TextEditingController();
  DateTime _openDate = DateTime.now().add(const Duration(days: 7));
  bool _isPublic = false;
  bool _isLoading = false;
  EmotionalState? _selectedEmotion;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _receiverEmailController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _openDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) setState(() => _openDate = picked);
  }

  Future<void> _saveLetter() async {
    if (_titleController.text.trim().isEmpty ||
        _messageController.text.trim().isEmpty ||
        _receiverEmailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    if (_selectedEmotion == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escolha o estado emocional da carta!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final firestore = FirebaseFirestore.instance;

      final senderDoc = await firestore
          .collection(FirestoreCollections.users)
          .doc(currentUser.uid)
          .get();
      final senderName = senderDoc.data()?['name'] ?? currentUser.email ?? '';

      final receiverQuery = await firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: _receiverEmailController.text.trim())
          .get();

      if (receiverQuery.docs.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Destinatário não encontrado!')),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      final receiver = receiverQuery.docs.first;
      final receiverUid = receiver.id;

      // Verifica se são amigos (seguidores mútuos)
      final followCheck = await firestore
          .collection('follows')
          .where('followerUid', isEqualTo: currentUser.uid)
          .where('followingUid', isEqualTo: receiverUid)
          .get();

      final areFriends = followCheck.docs.isNotEmpty || receiverUid == currentUser.uid;

      await firestore.collection(FirestoreCollections.letters).add({
        'senderUid': currentUser.uid,
        'senderName': senderName,
        'receiverUid': receiverUid,
        'receiverName': receiver.data()['name'] ?? '',
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'openDate': Timestamp.fromDate(_openDate),
        'status': 'locked',
        'isPublic': _isPublic,
        'canBeShared': _isPublic,
        'emotionalState': _selectedEmotion!.key,
        'requestStatus': areFriends ? 'accepted' : 'pending',
        'createdAt': Timestamp.now(),
        'openedAt': null,
        'publishedAt': null,
        'likeCount': 0,
        'commentCount': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              areFriends ? 'Carta enviada com sucesso! 💌' : 'Carta enviada! Aguardando aprovação. 💌',
            ),
          ),
        );
        Navigator.pop(context);
      }
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.ink),
                  ),
                  const SizedBox(width: 16),
                  Text('Escrever carta',
                    style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Estado emocional — obrigatório
                    Text('COMO VOCÊ ESTÁ SE SENTINDO?',
                      style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Row(
                      children: emotionalStates.map((e) {
                        final isSelected = _selectedEmotion?.key == e.key;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedEmotion = e),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected ? e.bgColor : AppColors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? e.color : AppColors.border,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text(e.emoji, style: const TextStyle(fontSize: 20)),
                                  const SizedBox(height: 4),
                                  Text(e.label,
                                    style: GoogleFonts.dmSans(
                                      fontSize: 9,
                                      color: isSelected ? e.color : AppColors.inkFaint,
                                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                    )),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    // Título
                    _buildField(
                      controller: _titleController,
                      label: 'Título',
                      hint: 'Ex: Open when you miss me',
                    ),
                    const SizedBox(height: 14),

                    // Destinatário
                    _buildField(
                      controller: _receiverEmailController,
                      label: 'Email do destinatário',
                      hint: 'email@exemplo.com',
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),

                    // Mensagem
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 8,
                        style: GoogleFonts.dmSerifDisplay(
                          color: AppColors.ink,
                          fontStyle: FontStyle.italic,
                          fontSize: 15,
                          height: 1.8,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Sua mensagem',
                          labelStyle: GoogleFonts.dmSans(color: AppColors.inkSoft),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                          alignLabelWithHint: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Data de abertura
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.accent, size: 20),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Data de abertura',
                                  style: GoogleFonts.dmSans(color: AppColors.inkSoft, fontSize: 11)),
                                Text('${_openDate.day}/${_openDate.month}/${_openDate.year}',
                                  style: GoogleFonts.dmSans(color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Toggle público
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: SwitchListTile(
                        title: Text('Carta pública',
                          style: GoogleFonts.dmSans(color: AppColors.ink)),
                        subtitle: Text('Pode aparecer no feed após ser aberta',
                          style: GoogleFonts.dmSans(color: AppColors.inkSoft, fontSize: 12)),
                        value: _isPublic,
                        activeColor: AppColors.accent,
                        onChanged: (value) => setState(() => _isPublic = value),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão enviar
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveLetter,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: AppColors.white)
                          : Text('Enviar carta 💌',
                              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        style: GoogleFonts.dmSans(color: AppColors.ink),
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          labelStyle: GoogleFonts.dmSans(color: AppColors.inkSoft),
          hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
