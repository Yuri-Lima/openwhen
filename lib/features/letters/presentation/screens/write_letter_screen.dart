import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';

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
  final _emailController = TextEditingController();

  DateTime _openDate = DateTime.now().add(const Duration(days: 7));
  bool _isPublic = false;
  bool _isLoading = false;
  EmotionalState? _selectedEmotion;

  // Tipo de carta
  bool _isHandwritten = false;
  String? _handwrittenImageUrl;
  bool _uploadingImage = false;

  // Destinatario
  String? _receiverUid;
  String? _receiverName;
  String? _receiverUsername;
  String? _receiverPhotoUrl;
  bool _receiverHasAccount = false;

  // Busca
  List<Map<String, dynamic>> _searchResults = [];
  bool _searching = false;
  bool _showResults = false;

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    _searchController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _searchUsers(String query) async {
    if (query.length < 2) {
      setState(() { _searchResults = []; _showResults = false; });
      return;
    }
    setState(() => _searching = true);
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final allDocs = <String, Map<String, dynamic>>{};
    final q = query.toLowerCase().replaceAll('@', '');

    try {
      final snap = await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .get();

      for (final doc in snap.docs) {
        if (doc.id == currentUid) continue;
        final data = doc.data();
        final username = (data['username'] ?? '').toString().toLowerCase();
        final name = (data['name'] ?? '').toString().toLowerCase();
        final displayName = (data['displayName'] ?? '').toString().toLowerCase();
        final email = (data['email'] ?? '').toString().toLowerCase();
        if (username.contains(q) || name.contains(q) || displayName.contains(q) || email.contains(q)) {
          allDocs[doc.id] = {'uid': doc.id, ...data};
        }
      }
    } catch (e) {
      print('Erro busca: $e');
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
      _receiverName = user['displayName'] ?? user['name'] ?? '';
      _receiverUsername = user['username'] ?? '';
      _receiverPhotoUrl = user['photoUrl'];
      _receiverHasAccount = true;
      _searchResults = [];
      _showResults = false;
      _searchController.clear();
    });
  }

  void _selectByEmail() {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um email válido!')),
      );
      return;
    }
    setState(() {
      _receiverUid = null;
      _receiverName = email;
      _receiverUsername = '';
      _receiverPhotoUrl = null;
      _receiverHasAccount = false;
    });
  }

  void _clearReceiver() {
    setState(() {
      _receiverUid = null;
      _receiverName = null;
      _receiverUsername = null;
      _receiverPhotoUrl = null;
      _receiverHasAccount = false;
      _emailController.clear();
    });
  }

  Future<void> _pickHandwrittenImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    setState(() => _uploadingImage = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final ref = FirebaseStorage.instance
          .ref('handwritten/${uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await ref.putData(file.bytes!, SettableMetadata(contentType: 'image/jpeg'));
      final url = await ref.getDownloadURL();
      setState(() => _handwrittenImageUrl = url);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ative o Firebase Storage para usar esta função'),
            backgroundColor: AppColors.accent,
          ),
        );
      }
    }
    setState(() => _uploadingImage = false);
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
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Preencha o título!')));
      return;
    }
    if (!_isHandwritten && _messageController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escreva sua mensagem!')));
      return;
    }
    if (_isHandwritten && _handwrittenImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Adicione a foto da carta!')));
      return;
    }
    if (_receiverName == null || _receiverName!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Escolha o destinatário!')));
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

      bool areFriends = false;
      if (_receiverUid != null) {
        final followCheck = await firestore
            .collection('follows')
            .where('followerUid', isEqualTo: currentUser.uid)
            .where('followingUid', isEqualTo: _receiverUid)
            .get();
        areFriends = followCheck.docs.isNotEmpty || _receiverUid == currentUser.uid;
      }

      await firestore.collection(FirestoreCollections.letters).add({
        'senderUid': currentUser.uid,
        'senderName': senderName,
        'receiverUid': _receiverUid ?? '',
        'receiverName': _receiverName ?? '',
        'receiverEmail': _receiverHasAccount ? null : _receiverName,
        'receiverHasAccount': _receiverHasAccount,
        'title': _titleController.text.trim(),
        'message': _isHandwritten ? '' : _messageController.text.trim(),
        'isHandwritten': _isHandwritten,
        'handwrittenImageUrl': _handwrittenImageUrl,
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
          content: Text(_receiverHasAccount
              ? (areFriends ? 'Carta enviada! 💌' : 'Carta enviada! Aguardando aprovação. 💌')
              : 'Carta criada! Compartilhe o link com o destinatário. 💌'),
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
            decoration: const BoxDecoration(
              color: AppColors.white,
              border: Border(bottom: BorderSide(color: AppColors.border)),
            ),
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 14),
            child: Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: AppColors.ink)),
              const SizedBox(width: 16),
              Row(children: [
                Text('Escrever carta', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: AppColors.ink)),
                const SizedBox(width: 6),
                const OwlWatermark(width: 18, height: 22, color: AppColors.ink),
              ]),
            ]),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showResults = false),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [

                  // Estado emocional
                  Text('COMO VOCÊ ESTÁ SE SENTINDO?', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
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
                  _buildField(controller: _titleController, label: 'Título', hint: 'Ex: Abra quando sentir saudade'),
                  const SizedBox(height: 20),

                  // TIPO DE CARTA
                  Text('TIPO DE CARTA', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isHandwritten = false),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !_isHandwritten ? AppColors.accentWarm : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: !_isHandwritten ? AppColors.accent : AppColors.border, width: !_isHandwritten ? 2 : 1),
                          ),
                          child: Column(children: [
                            Text('⌨️', style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text('Digitada', style: GoogleFonts.dmSans(fontSize: 12, color: !_isHandwritten ? AppColors.accent : AppColors.inkSoft, fontWeight: !_isHandwritten ? FontWeight.w600 : FontWeight.w400)),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isHandwritten = true),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: _isHandwritten ? AppColors.accentWarm : AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _isHandwritten ? AppColors.accent : AppColors.border, width: _isHandwritten ? 2 : 1),
                          ),
                          child: Column(children: [
                            Text('✍️', style: const TextStyle(fontSize: 22)),
                            const SizedBox(height: 4),
                            Text('Manuscrita', style: GoogleFonts.dmSans(fontSize: 12, color: _isHandwritten ? AppColors.accent : AppColors.inkSoft, fontWeight: _isHandwritten ? FontWeight.w600 : FontWeight.w400)),
                          ]),
                        ),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 14),

                  // CONTEUDO DA CARTA
                  if (!_isHandwritten)
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
                    )
                  else
                    GestureDetector(
                      onTap: _pickHandwrittenImage,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: _handwrittenImageUrl != null ? null : 180,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: _handwrittenImageUrl != null ? AppColors.accent : AppColors.border,
                            width: _handwrittenImageUrl != null ? 2 : 1,
                          ),
                        ),
                        child: _uploadingImage
                            ? const Center(child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(color: AppColors.accent),
                              ))
                            : _handwrittenImageUrl != null
                                ? Stack(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(13),
                                      child: Image.network(_handwrittenImageUrl!, fit: BoxFit.cover, width: double.infinity),
                                    ),
                                    Positioned(
                                      top: 8, right: 8,
                                      child: GestureDetector(
                                        onTap: () => setState(() => _handwrittenImageUrl = null),
                                        child: Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                                          child: const Icon(Icons.close, size: 14, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ])
                                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    const Icon(Icons.add_photo_alternate_outlined, size: 40, color: AppColors.inkFaint),
                                    const SizedBox(height: 10),
                                    Text('Toque para adicionar a foto da carta', style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.inkSoft)),
                                    const SizedBox(height: 4),
                                    Text('Tire uma foto da sua carta escrita à mão', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                                  ]),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // DESTINATARIO
                  Text('PARA QUEM?', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),

                  if (_receiverName != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Row(children: [
                        Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(
                            color: _receiverHasAccount ? AppColors.accentWarm : const Color(0xFFEEF2FF),
                            shape: BoxShape.circle,
                          ),
                          child: Center(child: _receiverHasAccount
                              ? Text((_receiverName ?? 'U').substring(0, 1).toUpperCase(), style: GoogleFonts.dmSans(color: AppColors.accent, fontWeight: FontWeight.bold))
                              : const Icon(Icons.email_outlined, color: Color(0xFF6366F1), size: 18)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_receiverName ?? '', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                          Text(
                            _receiverHasAccount ? '@${_receiverUsername ?? ''}' : 'Receberá um link para criar conta',
                            style: GoogleFonts.dmSans(fontSize: 12, color: _receiverHasAccount ? AppColors.inkSoft : const Color(0xFF6366F1)),
                          ),
                        ])),
                        GestureDetector(onTap: _clearReceiver, child: const Icon(Icons.close, color: AppColors.accent, size: 20)),
                      ]),
                    )
                  else
                    Column(children: [
                      // Busca por usuario
                      Container(
                        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(children: [
                          const Icon(Icons.search, color: AppColors.inkFaint, size: 20),
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

                      // Resultados da busca
                      if (_showResults && _searchResults.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))]),
                          child: Column(children: _searchResults.map((u) {
                            final nome = u['displayName'] ?? u['name'] ?? '';
                            final foto = u['photoUrl'];
                            final username = u['username'] ?? '';
                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              leading: CircleAvatar(
                                radius: 20,
                                backgroundColor: AppColors.accentWarm,
                                backgroundImage: foto != null ? NetworkImage(foto) : null,
                                child: foto == null ? Text(nome.isNotEmpty ? nome.substring(0, 1).toUpperCase() : 'U', style: GoogleFonts.dmSans(color: AppColors.accent, fontWeight: FontWeight.bold)) : null,
                              ),
                              title: Text(nome, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              subtitle: Text('@$username', style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.inkSoft)),
                              onTap: () => _selectUser(u),
                            );
                          }).toList()),
                        ),

                      // Divisor OU
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(children: [
                          const Expanded(child: Divider(color: AppColors.border)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('ou envie para quem não tem conta', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                          ),
                          const Expanded(child: Divider(color: AppColors.border)),
                        ]),
                      ),

                      // Email para quem nao tem conta
                      Row(children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: GoogleFonts.dmSans(color: AppColors.ink),
                              decoration: InputDecoration(
                                hintText: 'email@exemplo.com',
                                hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _selectByEmail,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(14)),
                            child: Text('OK', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ]),
                    ]),
                  const SizedBox(height: 20),

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
                      title: Text('Carta pública', style: GoogleFonts.dmSans(color: AppColors.ink)),
                      subtitle: Text('Pode aparecer no feed após ser aberta', style: GoogleFonts.dmSans(color: AppColors.inkSoft, fontSize: 12)),
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
                  const SizedBox(height: 24),
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
