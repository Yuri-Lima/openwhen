import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/user_search/user_search_tokens.dart';

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

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    final bio = _bioCtrl.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.editProfileErrorNameEmpty)),
      );
      return;
    }

    setState(() => _saving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final username = _usernameCtrl.text.trim().toLowerCase();
    final searchTokens = buildUserSearchTokens(
      username: username,
      displayName: name,
      name: name,
    );

    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update({
      'displayName': name,
      'name': name,
      'searchTokens': searchTokens,
      'bio': bio,
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.editProfileSaved, style: GoogleFonts.dmSans()),
          backgroundColor: context.pal.accent,
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.bg,
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: context.pal.headerGradient,
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
              Text(l10n.editProfileTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: context.pal.white, fontStyle: FontStyle.italic)),
              const Spacer(),
              if (_saving)
                const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              else
                GestureDetector(
                  onTap: _save,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: context.pal.accent, borderRadius: BorderRadius.circular(20)),
                    child: Text(l10n.actionSave, style: GoogleFonts.dmSans(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ),
            ]),
          )),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(padding: const EdgeInsets.all(24), children: [

                  Text(l10n.editProfileSectionName, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _nameCtrl,
                    hint: l10n.editProfileHintName,
                    icon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 20),

                  Text(l10n.editProfileSectionUsername, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  _buildField(
                    controller: _usernameCtrl,
                    hint: l10n.editProfileHintUsername,
                    icon: Icons.alternate_email_rounded,
                    prefix: '@',
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),

                  Text(l10n.editProfileSectionBio, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.inkFaint, letterSpacing: 1.5, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: context.pal.card,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: context.pal.border),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _bioCtrl,
                      maxLines: 3,
                      maxLength: 150,
                      style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.ink),
                      decoration: InputDecoration(
                        hintText: l10n.editProfileHintBio,
                        hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                        border: InputBorder.none,
                        counterStyle: GoogleFonts.dmSans(fontSize: 11, color: context.pal.inkFaint),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: context.pal.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(l10n.editProfileSaveChanges, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
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
    bool readOnly = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? context.pal.card.withOpacity(0.5) : context.pal.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.pal.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: context.pal.inkFaint),
        const SizedBox(width: 10),
        if (prefix != null)
          Text(prefix, style: GoogleFonts.dmSans(fontSize: 14, color: context.pal.inkSoft, fontWeight: FontWeight.w500)),
        Expanded(child: TextField(
          controller: controller,
          readOnly: readOnly,
          enableInteractiveSelection: !readOnly,
          canRequestFocus: !readOnly,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: readOnly ? context.pal.inkFaint : context.pal.ink,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        )),
      ]),
    );
  }
}
