import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';

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

    setState(() => _isLoading = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final firestore = FirebaseFirestore.instance;

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

      await firestore.collection(FirestoreCollections.letters).add({
        'senderUid': currentUser.uid,
        'senderName': currentUser.email ?? '',
        'receiverUid': receiver.id,
        'receiverName': receiver.data()['name'] ?? '',
        'title': _titleController.text.trim(),
        'message': _messageController.text.trim(),
        'openDate': Timestamp.fromDate(_openDate),
        'status': 'locked',
        'isPublic': _isPublic,
        'canBeShared': _isPublic,
        'createdAt': Timestamp.now(),
        'openedAt': null,
        'publishedAt': null,
        'likeCount': 0,
        'commentCount': 0,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Carta enviada com sucesso! 💌')),
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.dmSans(color: AppColors.inkSoft),
      filled: true,
      fillColor: AppColors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.cardBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.ink),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.white,
                border: Border(
                  bottom: BorderSide(color: AppColors.cardBorder),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back, color: AppColors.ink),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Escrever carta',
                    style: GoogleFonts.dmSerifDisplay(
                      fontSize: 20,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _titleController,
                      style: GoogleFonts.dmSans(color: AppColors.ink),
                      decoration: _inputDecoration('Título — ex: Open when you miss me'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _receiverEmailController,
                      keyboardType: TextInputType.emailAddress,
                      style: GoogleFonts.dmSans(color: AppColors.ink),
                      decoration: _inputDecoration('Email do destinatário'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _messageController,
                      maxLines: 8,
                      style: GoogleFonts.dmSerifDisplay(
                        color: AppColors.ink,
                        fontStyle: FontStyle.italic,
                      ),
                      decoration: _inputDecoration('Sua mensagem...').copyWith(
                        alignLabelWithHint: true,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _pickDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: AppColors.accent),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Data de abertura',
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.inkSoft,
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  '${_openDate.day}/${_openDate.month}/${_openDate.year}',
                                  style: GoogleFonts.dmSans(
                                    color: AppColors.ink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.cardBorder),
                      ),
                      child: SwitchListTile(
                        title: Text(
                          'Carta pública',
                          style: GoogleFonts.dmSans(color: AppColors.ink),
                        ),
                        subtitle: Text(
                          'Pode aparecer no feed após ser aberta',
                          style: GoogleFonts.dmSans(
                            color: AppColors.inkSoft,
                            fontSize: 12,
                          ),
                        ),
                        value: _isPublic,
                        activeColor: AppColors.accent,
                        onChanged: (value) => setState(() => _isPublic = value),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _saveLetter,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: AppColors.white)
                          : Text(
                              'Enviar carta 💌',
                              style: GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
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
}
