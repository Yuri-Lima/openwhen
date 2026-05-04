import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/services/safe_callable.dart';
import '../../../../core/user_search/user_search_tokens.dart';
import '../../../../core/utils/username_generator.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../gamification/badge_unlock_service.dart';

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

  String _originalUsername = '';
  bool _checkingUsername = false;
  bool _usernameAvailable = true;
  String? _usernameError;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _usernameCtrl.addListener(_onUsernameChanged);
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
      _originalUsername = (data['username'] ?? '') as String;
      _usernameCtrl.text = _originalUsername;
      _bioCtrl.text = data['bio'] ?? '';
    }
    setState(() => _loading = false);
  }

  void _onUsernameChanged() {
    final raw = sanitizeUsername(_usernameCtrl.text);
    _debounce?.cancel();

    // No-op when the user hasn't actually changed their own username.
    if (raw == _originalUsername) {
      setState(() {
        _usernameError = null;
        _usernameAvailable = true;
        _checkingUsername = false;
      });
      return;
    }

    final error = validateUsername(raw);
    if (error != null) {
      setState(() {
        _usernameError = _localizedError(error);
        _usernameAvailable = false;
        _checkingUsername = false;
      });
      return;
    }

    setState(() {
      _usernameError = null;
      _checkingUsername = true;
      _usernameAvailable = false;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final available = await _isUsernameAvailable(raw);
      if (!mounted) return;
      setState(() {
        _checkingUsername = false;
        if (available) {
          _usernameAvailable = true;
          _usernameError = null;
        } else {
          _usernameAvailable = false;
          _usernameError =
              AppLocalizations.of(context)!.editProfileErrorUsernameTaken;
        }
      });
    });
  }

  String? _localizedError(String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'empty':
        return l10n.editProfileErrorUsernameEmpty;
      case 'short':
        return l10n.editProfileErrorUsernameShort;
      case 'long':
        return l10n.registerErrorUsernameLong;
      case 'invalid':
        return l10n.registerErrorUsernameInvalid;
      default:
        return null;
    }
  }

  Future<bool> _isUsernameAvailable(String username) async {
    try {
      final result = await SafeCallable.call(
        'checkUsernameAvailable',
        data: {'username': username},
        label: 'checkUsernameAvailable',
      );
      final data = result.data;
      return data is Map && data['available'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameCtrl.text.trim();
    final bio = _bioCtrl.text.trim();
    final username = sanitizeUsername(_usernameCtrl.text);
    final usernameChanged = username != _originalUsername;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.editProfileErrorNameEmpty)),
      );
      return;
    }

    if (usernameChanged) {
      final usernameError = validateUsername(username);
      if (usernameError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_localizedError(usernameError) ?? '')),
        );
        return;
      }
      if (!_usernameAvailable || _checkingUsername) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.editProfileErrorUsernameTaken)),
        );
        return;
      }
    }

    setState(() => _saving = true);

    final uid = FirebaseAuth.instance.currentUser?.uid;
    final searchTokens = buildUserSearchTokens(
      username: username,
      displayName: name,
      name: name,
    );

    final update = <String, dynamic>{
      'displayName': name,
      'name': name,
      'searchTokens': searchTokens,
      'bio': bio,
    };
    if (usernameChanged) {
      update['username'] = username;
    }

    await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .doc(uid)
        .update(update);

    // Check if profile is now complete (name, username, bio, avatar).
    if (uid != null) {
      BadgeUnlockHooks.afterProfileSaved(uid);
    }

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
    _debounce?.cancel();
    _usernameCtrl.removeListener(_onUsernameChanged);
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
                child: Container(width: 36, height: 36, decoration: BoxDecoration(color: Colors.white.withValues(alpha:0.08), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withValues(alpha:0.6))),
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
                    suffix: _buildUsernameStatus(),
                  ),
                  if (_usernameError != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      _usernameError!,
                      style: GoogleFonts.dmSans(fontSize: 12, color: Colors.redAccent),
                    ),
                  ],
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
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: readOnly ? context.pal.card.withValues(alpha:0.5) : context.pal.card,
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
        ?suffix,
      ]),
    );
  }

  Widget? _buildUsernameStatus() {
    if (_checkingUsername) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }
    final raw = sanitizeUsername(_usernameCtrl.text);
    if (raw == _originalUsername) return null;
    if (_usernameAvailable) {
      return const Icon(Icons.check_circle, size: 18, color: Colors.green);
    }
    if (_usernameError != null) {
      return const Icon(Icons.error_outline, size: 18, color: Colors.redAccent);
    }
    return null;
  }
}
