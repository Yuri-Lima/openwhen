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
  const EmotionalState({required this.key, required this.label, required this.emoji, required this.color, required this.bgColor});
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
  final _searchController = TextEditingController();

  DateTime _openDate = DateTime.now().add(const Duration(days: 7));
  bool _isPublic = false;
  bool _isLoading = false;
  EmotionalState? _selectedEmotion;

  // Destinatario selecionado
  String? _receiverUid;
  String? _receiverName;
  String? _receiverUsername;
  String? _receiverPhotoUrl;

  // Busca
  List<Map<String, dynamic>> _searchResults = [];
  bool _searching = false;
  bool _showResults = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) {
      setState(() { _searchResults = []; _showResults = false; });
      return;
    }
    setState(() => _searching = true);
    final q = query.toLowerCase().replaceAll('@', '');

    // Busca por username
    final byUsername = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .where('username', isGreaterThanOrEqualTo: q)
        .where('username', isLessThan: '${q}z')
        .limit(5)
        .get();

    // Busca por displayName
    final byName = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .where('displayName', isGreaterThanOrEqualTo: query)
        .where('displayName', isLessThan: '${query}z')
        .limit(5)
        .get();

    final allDocs = <String, Map<String, dynamic>>{};
    final currentUid = FirebaseAuth.instance.currentUser?.uid;

    for (final doc in [...byUsername.docs, ...byName.docs]) {
      if (doc.id != currentUid) {
        allDocs[doc.id] = {'uid': doc.id, ...doc.data()};
      }
    }

    setState(() {
      _searchResults = allDocs.values.toList();
      _searching = false;
      _showResults = true;
    });
  }

  void _selectUser(Map<String, dynamic> user) {
    setState(() {
      _receiverUid = user['uid'];
      _receiverName = user['displayName'] ?? '';
      _receiverUsername = user['username'] ?? '';
      _receiverPhotoUrl = user['photoUrl'];
      _searchResults = [];
      _showResults = false;
      _searchController.clear();
    });
  }

  void _clearReceiver() {
    setState(() {
      _receiverUid = null;
      _receiverName = null;
      _receiverUsername = null;
      _receiverPhotoUrl = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _openDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: AppColors.accent)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _openDate = picked);
  }

  Future<void> _saveLetter() async {
    if (_titleController.text.trim().isEmpty || _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha titulo e mensagem!')));
      return;
    }
    if (_receiverUid == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escolha o destinatario!')));
      return;
    }
    if (_selectedEmotion == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escolha o estado emocional!')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      final currentUser = FirebaseAuth.instance.currentUser!;
      final firestore = FirebaseFirestore.instance;

      final senderDoc = await firestore.collection(FirestoreCollections.users).doc(currentUser.uid).get();
      final senderName = senderDoc.data()?['displayName'] ?? senderDoc.data()?['name'] ?? currentUser.email ?? '';

      final followCheck = await firestore
          .collection('follows')
          .where('followerUid', isEqualTo: currentUser.uid)
          .where('followingUid', isEqualTo: _receiverUid)
          .get();
      final areFriends = followCheck.docs.isNotEmpty || _receiverUid == currentUser.uid;

      await firestore.collection(FirestoreCollections.letters).add({
        'senderUid': currentUser.uid,
        'senderName': senderName,
        'receiverUid': _receiverUid,
        'receiverName': _receiverName ?? '',
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(areFriends ? 'Carta enviada! 💌' : 'Carta enviada! Aguardando aprovacao. 💌'),
          backgroundColor: AppColors.accent,
        ));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            decoration: const BoxDecoration(color: AppColors.white, border: Border(bottom: BorderSide(color: AppColors.border))),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: AppColors.ink)),
              const SizedBox(width: 16),
              Text('Escrever carta', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink)),
            ]),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showResults = false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                  // Estado emocional
                  Text('COMO VOCE ESTA SE SENTINDO?', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 12),
                  Row(children: emotionalStates.map((e) {
                    final isSelected = _selectedEmotion?.key == e.key;
                    return Expanded(child: GestureDetector(
                      onTap: () => setState(() => _selectedEmotion = e),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? e.bgColor : AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isSelected ? e.color : AppColors.border, width: isSelected ? 2 : 1),
                        ),
                        child: Column(children: [
                          Text(e.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(height: 4),
                          Text(e.label, style: GoogleFonts.dmSans(fontSize: 9, color: isSelected ? e.color : AppColors.inkFaint, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400)),
                        ]),
                      ),
                    ));
                  }).toList()),
                  const SizedBox(height: 20),

                  // Titulo
                  _buildField(controller: _titleController, label: 'Titulo', hint: 'Ex: Open when you miss me'),
                  const SizedBox(height: 14),

                  // Destinatario — busca estilo Instagram
                  Text('PARA QUEM?', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),

                  if (_receiverUid != null)
                    // Usuario selecionado
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.accent)),
                      child: Row(children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.accentWarm,
                          backgroundImage: _receiverPhotoUrl != null ? NetworkImage(_receiverPhotoUrl!) : null,
                          child: _receiverPhotoUrl == null ? Text((_receiverName ?? 'U').substring(0, 1).toUpperCase(), style: GoogleFonts.dmSans(color: AppColors.accent, fontWeight: FontWeight.bold)) : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_receiverName ?? '', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                          Text('@${_receiverUsername ?? ''}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft)),
                        ])),
                        GestureDetector(onTap: _clearReceiver, child: const Icon(Icons.close, color: AppColors.accent, size: 20)),
                      ]),
                    )
                  else
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(children: [
                          Icon(Icons.search, color: AppColors.inkFaint, size: 20),
                          const SizedBox(width: 8),
                          Expanded(child: TextField(
                            controller: _searchController,
                            onChanged: _searchUsers,
                            style: GoogleFonts.dmSans(color: AppColors.ink),
                            decoration: InputDecoration(
                              hintText: 'Buscar por @usuario ou nome...',
                              hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          )),
                          if (_searching) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.accent)),
                        ]),
                      ),
                      if (_showResults && _searchResults.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
                          child: Column(children: _searchResults.map((u) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            leading: CircleAvatar(
                              radius: 20,
                              backgroundColor: AppColors.accentWarm,
                              backgroundImage: u['photoUrl'] != null ? NetworkImage(u['photoUrl']) : null,
                              child: u['photoUrl'] == null ? Text((u['displayName'] as String? ?? 'U').substring(0, 1).toUpperCase(), style: GoogleFonts.dmSans(color: AppColors.accent, fontWeight: FontWeight.bold)) : null,
                            ),
                            title: Text(u['displayName'] ?? '', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                            subtitle: Text('@${u['username'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft)),
                            onTap: () => _selectUser(u),
                          )).toList()),
                        ),
                      if (_showResults && _searchResults.isEmpty && !_searching && _searchController.text.length >= 2)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                          child: Text('Nenhum usuario encontrado', style: GoogleFonts.dmSans(color: AppColors.inkSoft, fontSize: 13), textAlign: TextAlign.center),
                        ),
                    ]),
                  const SizedBox(height: 14),

                  // Mensagem
                  Container(
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: TextField(
                      controller: _messageController,
                      maxLines: 8,
                      style: GoogleFonts.dmSerifDisplay(color: AppColors.ink, fontStyle: FontStyle.italic, fontSize: 15, height: 1.8),
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
                      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                      child: Row(children: [
                        const Icon(Icons.calendar_today, color: AppColors.accent, size: 20),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Data de abertura', style: GoogleFonts.dmSans(color: AppColors.inkSoft, fontSize: 11)),
                          Text('${_openDate.day}/${_openDate.month}/${_openDate.year}', style: GoogleFonts.dmSans(color: AppColors.ink, fontSize: 15, fontWeight: FontWeight.w500)),
                        ]),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Toggle publico
                  Container(
                    decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                    child: SwitchListTile(
                      title: Text('Carta publica', style: GoogleFonts.dmSans(color: AppColors.ink)),
                      subtitle: Text('Pode aparecer no feed apos ser aberta', style: GoogleFonts.dmSans(color: AppColors.inkSoft, fontSize: 12)),
                      value: _isPublic,
                      activeColor: AppColors.accent,
                      onChanged: (value) => setState(() => _isPublic = value),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Botao enviar
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveLetter,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: AppColors.white)
                        : Text('Enviar carta 💌', style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildField({required TextEditingController controller, required String label, required String hint, TextInputType keyboard = TextInputType.text}) {
    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
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
