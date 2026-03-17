import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';

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
    if (picked != null) {
      setState(() => _openDate = picked);
    }
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

      // Busca o destinatário pelo email
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

      // Salva a carta no Firestore
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Escrever carta'),
        backgroundColor: const Color(0xFF2E7D32),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '💌 Nova carta',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título',
                hintText: 'Ex: Open when you miss me',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _receiverEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email do destinatário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 8,
              decoration: const InputDecoration(
                labelText: 'Sua mensagem',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 16),
            InkWell(
              onTap: _pickDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF2E7D32)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Data de abertura',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          '${_openDate.day}/${_openDate.month}/${_openDate.year}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Carta pública'),
              subtitle: const Text('Pode aparecer no feed após ser aberta'),
              value: _isPublic,
              activeColor: const Color(0xFF2E7D32),
              onChanged: (value) => setState(() => _isPublic = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _saveLetter,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enviar carta 💌', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
