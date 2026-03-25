import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();
  bool _loading = false;
  bool _saving = false;
  String? _usernameError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .get();
    final data = doc.data();
    if (data != null) {
      _nameCtrl.text = data['displayName'] ?? data['name'] ?? '';
      _usernameCtrl.text = data['username'] ?? '';
      _bioCtrl.text = data['bio'] ?? '';
    }
    setState(() => _loading = false);
  }

  Future<bool> _isUsernameAvailable(String username) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final snap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    // Permite se for o proprio usuario
    return snap.docs.isEmpty || (snap.docs.length == 1 && snap.docs.first.id == uid);
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final username = _usernameCtrl.text.trim().toLowerCase().replaceAll('@', '').replaceAll(' ', '');
    final bio = _bioCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome nao pode ser vazio')),
      );
      return;
    }

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username nao pode ser vazio')),
      );
      return;
    }

    if (username.length < 3) {
      setState(() => _usernameError = 'Username deve ter pelo menos 3 caracteres');
      return;
    }

    setState(() { _saving = true; _usernameError = null; });

    final available = await _isUsernameAvailable(username);
    if (!available) {
      setState(() { _usernameError = 'Este username ja esta em uso'; _saving = false; });
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({
      'displayName': name,
      'name': name,
      'username': username,
      'bio': bio,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Perfil atualizado!', style: GoogleFonts.dmSans()),
          backgroundColor: AppColors.accent,
        ),
      );
      Navigator.pop(context);
    }
    setState(() => _saving = false);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _usernameCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1714), Color(0xFF2C1810), Color(0xFF1A1714)],
            ),
          ),
          child: SafeArea(bottom: false, child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6))),
              ),
              const SizedBox(width: 16),
              Text('Editar perfil', style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: AppColors.white, fontStyle: FontStyle.italic)),
              const Spacer(),
              if (_saving)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              else
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(20)),
                    child: Text('Salvar', style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
            ]),
          )),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(padding: const EdgeInsets.all(24), children: [

                  // Nome
                  Text('NOME', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _nameCtrl,
                    hint: 'Seu nome completo',
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),

                  // Username
                  Text('USERNAME', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _usernameCtrl,
                    hint: 'seu_username',
                    icon: Icons.alternate_email_rounded,
                    prefix: '@',
                    error: _usernameError,
                    onChanged: (_) => setState(() => _usernameError = null),
                  ),
                  const SizedBox(height: 4),
                  Text('Apenas letras, numeros e _', style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint)),
                  const SizedBox(height: 20),

                  // Bio
                  Text('BIO', style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _bioCtrl,
                      maxLines: 3,
                      maxLength: 150,
                      style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink),
                      decoration: InputDecoration(
                        hintText: 'Conte um pouco sobre voce...',
                        hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint),
                        border: InputBorder.none,
                        counterStyle: GoogleFonts.dmSans(fontSize: 11, color: AppColors.inkFaint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Botao salvar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text('Salvar alteracoes', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
                    ),
                  ),
                ]),
        ),
      ]),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    String? prefix,
    String? error,
    ValueChanged<String>? onChanged,
  }) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: error != null ? AppColors.accent : AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(children: [
          Icon(icon, size: 18, color: AppColors.inkFaint),
          const SizedBox(width: 10),
          if (prefix != null)
            Text(prefix, style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.inkSoft, fontWeight: FontWeight.w500)),
          Expanded(child: TextField(
            controller: controller,
            onChanged: onChanged,
            style: GoogleFonts.dmSans(fontSize: 14, color: AppColors.ink),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          )),
        ]),
      ),
      if (error != null) ...[
        const SizedBox(height: 4),
        Text(error, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.accent)),
      ],
    ]);
  }
}
