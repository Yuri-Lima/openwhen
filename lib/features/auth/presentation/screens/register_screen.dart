import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/utils/username_generator.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  bool _acceptedTerms = false;
  bool _confirmedAge = false;

  // ── Username state ───────────────────────────────────────────────────
  List<String> _suggestions = [];
  String? _usernameError;
  bool _usernameAvailable = false;
  bool _checkingUsername = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onNameChanged);
    _usernameController.addListener(_onUsernameChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.removeListener(_onNameChanged);
    _usernameController.removeListener(_onUsernameChanged);
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  // ── Suggestions from name ────────────────────────────────────────────
  void _onNameChanged() {
    final name = _nameController.text.trim();
    if (name.length >= 2) {
      setState(() => _suggestions = generateUsernameSuggestions(name));
    } else {
      setState(() => _suggestions = []);
    }
  }

  void _pickSuggestion(String suggestion) {
    _usernameController.text = suggestion;
    // _onUsernameChanged will fire automatically via listener
  }

  // ── Availability check with debounce ─────────────────────────────────
  void _onUsernameChanged() {
    final raw = sanitizeUsername(_usernameController.text);
    final error = validateUsername(raw);

    _debounce?.cancel();

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
              AppLocalizations.of(context)!.registerErrorUsernameTaken;
        }
      });
    });
  }

  String? _localizedError(String key) {
    final l10n = AppLocalizations.of(context)!;
    switch (key) {
      case 'empty':
        return l10n.registerErrorUsernameEmpty;
      case 'short':
        return l10n.registerErrorUsernameShort;
      case 'long':
        return l10n.registerErrorUsernameLong;
      case 'invalid':
        return l10n.registerErrorUsernameInvalid;
      default:
        return null;
    }
  }

  Future<bool> _isUsernameAvailable(String username) async {
    final snap = await FirebaseFirestore.instance
        .collection(FirestoreCollections.users)
        .where('username', isEqualTo: username.toLowerCase())
        .get();
    return snap.docs.isEmpty;
  }

  // ── Register ─────────────────────────────────────────────────────────
  Future<void> _register() async {
    final l10n = AppLocalizations.of(context)!;
    final username = sanitizeUsername(_usernameController.text);

    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.snackFillAllFields)),
      );
      return;
    }

    // Username validation
    final usernameError = validateUsername(username);
    if (usernameError != null) {
      setState(
          () => _usernameError = _localizedError(usernameError));
      return;
    }
    if (!_usernameAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registerErrorUsernameTaken)),
      );
      return;
    }

    if (!_acceptedTerms || !_confirmedAge) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registerMustAcceptTerms)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            username: username,
          );
      if (!mounted) return;
      final registerState = ref.read(authNotifierProvider);
      if (registerState.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(l10n.errorGeneric(registerState.error.toString()))),
        );
      } else {
        try {
          await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        } catch (_) {}
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.registerSuccessVerify)),
        );
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── UI helpers ───────────────────────────────────────────────────────
  Widget _buildCheckRow({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required Widget child,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: context.pal.accent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String label,
    bool obscure = false,
    bool hasToggle = false,
    TextInputType keyboard = TextInputType.text,
    String? prefixText,
    Widget? suffix,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: context.pal.inkFaint,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: context.pal.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.pal.border, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: Row(
            children: [
              Icon(icon, size: 18,
                  color: context.pal.inkFaint.withOpacity(0.6)),
              const SizedBox(width: 10),
              if (prefixText != null)
                Text(
                  prefixText,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: context.pal.inkFaint,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enableInteractiveSelection: false,
                  obscureText: obscure && !_showPassword,
                  keyboardType: keyboard,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: context.pal.ink,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle:
                        GoogleFonts.dmSans(color: context.pal.inkFaint),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (hasToggle)
                GestureDetector(
                  onTap: () =>
                      setState(() => _showPassword = !_showPassword),
                  child: Icon(
                    _showPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: context.pal.inkFaint.withOpacity(0.6),
                  ),
                ),
              if (suffix != null) suffix,
            ],
          ),
        ),
      ],
    );
  }

  /// Builds the username field block (field + status + suggestions).
  Widget _buildUsernameSection(AppLocalizations l10n) {
    // Status indicator (right side of field)
    Widget? statusIcon;
    if (_checkingUsername) {
      statusIcon = SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: context.pal.inkFaint,
        ),
      );
    } else if (_usernameAvailable &&
        _usernameController.text.trim().isNotEmpty) {
      statusIcon = Icon(Icons.check_circle, size: 18, color: Colors.green);
    } else if (_usernameError != null) {
      statusIcon = Icon(Icons.cancel, size: 18, color: Colors.red.shade400);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildField(
          controller: _usernameController,
          icon: Icons.alternate_email,
          hint: l10n.registerHintUsername,
          label: l10n.registerSectionUsername,
          suffix: statusIcon,
        ),
        const SizedBox(height: 6),

        // Status text
        if (_checkingUsername)
          _statusText(l10n.registerUsernameChecking, context.pal.inkFaint)
        else if (_usernameAvailable &&
            _usernameController.text.trim().isNotEmpty)
          _statusText(l10n.registerUsernameAvailable, Colors.green)
        else if (_usernameError != null)
          _statusText(_usernameError!, Colors.red.shade400)
        else
          _statusText(l10n.registerUsernameRules, context.pal.inkFaint),

        // Suggestion chips
        if (_suggestions.isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            l10n.registerUsernameSuggestions,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: context.pal.inkFaint,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: _suggestions.map((s) {
              final selected =
                  sanitizeUsername(_usernameController.text) == s;
              return GestureDetector(
                onTap: () => _pickSuggestion(s),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? context.pal.accent.withOpacity(0.15)
                        : context.pal.bg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? context.pal.accent
                          : context.pal.border,
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    '@$s',
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: selected
                          ? context.pal.accent
                          : context.pal.inkSoft,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _statusText(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: GoogleFonts.dmSans(fontSize: 11, color: color),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.card,
      body: Column(
        children: [
          // Hero escuro
          Container(
            height: 310,
            color: context.pal.headerGradient.first,
            child: Stack(
              children: [
                Center(
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          context.pal.accent.withOpacity(0.12),
                          context.pal.accent.withOpacity(0.03),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      SizedBox(
                        width: 160,
                        height: 110,
                        child: Stack(
                          children: [
                            Container(
                              width: 160,
                              height: 110,
                              decoration: BoxDecoration(
                                color: const Color(0xFF1F1B18),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.07),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 32,
                                    offset: const Offset(0, 16),
                                  ),
                                  BoxShadow(
                                    color:
                                        context.pal.accent.withOpacity(0.2),
                                    blurRadius: 30,
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CustomPaint(
                                  painter: _EnvelopePainter(),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: context.pal.accent,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: context.pal.accent
                                            .withOpacity(0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    margin: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFA93226),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        'OW',
                                        style: GoogleFonts.dmSerifDisplay(
                                          fontSize: 14,
                                          color: context.pal.white,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'OpenWhen',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 26,
                          color: context.pal.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.loginHeroCreateAccount,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: context.pal.ink.withOpacity(0.4),
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Formulário
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildField(
                    controller: _nameController,
                    icon: Icons.person_outline,
                    hint: l10n.hintName,
                    label: l10n.labelName,
                  ),
                  const SizedBox(height: 16),

                  // ── Username field with @ prefix + suggestions ──
                  _buildUsernameSection(l10n),
                  const SizedBox(height: 16),

                  _buildField(
                    controller: _emailController,
                    icon: Icons.mail_outline,
                    hint: l10n.hintEmail,
                    label: l10n.labelEmail,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _passwordController,
                    icon: Icons.lock_outline,
                    hint: l10n.hintCreatePassword,
                    label: l10n.labelPassword,
                    obscure: true,
                    hasToggle: true,
                  ),
                  const SizedBox(height: 16),

                  // Terms of Use + Privacy Policy checkbox
                  _buildCheckRow(
                    value: _acceptedTerms,
                    onChanged: (v) =>
                        setState(() => _acceptedTerms = v ?? false),
                    child: Text.rich(
                      TextSpan(
                        text: l10n.registerAcceptTermsPrefix,
                        style: GoogleFonts.dmSans(
                            fontSize: 12,
                            color: context.pal.inkSoft,
                            height: 1.4),
                        children: [
                          TextSpan(
                            text: l10n.settingsTerms,
                            style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: context.pal.accent,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                          ),
                          TextSpan(text: l10n.registerAcceptTermsAnd),
                          TextSpan(
                            text: l10n.settingsPrivacy,
                            style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: context.pal.accent,
                                fontWeight: FontWeight.w500,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Age 13+ checkbox (COPPA compliance)
                  _buildCheckRow(
                    value: _confirmedAge,
                    onChanged: (v) =>
                        setState(() => _confirmedAge = v ?? false),
                    child: Text(
                      l10n.registerConfirmAge,
                      style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: context.pal.inkSoft,
                          height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        (_isLoading || !_acceptedTerms || !_confirmedAge)
                            ? null
                            : _register,
                    child: _isLoading
                        ? CircularProgressIndicator(
                            color: context.pal.white)
                        : Text(
                            l10n.registerCreateAccount,
                            style: GoogleFonts.dmSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      l10n.registerAlreadyHaveAccount,
                      style: GoogleFonts.dmSans(fontSize: 15),
                    ),
                  ),
                  // Legal footer removed — replaced by explicit checkboxes above
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF171411)
      ..style = PaintingStyle.fill;

    final abPath = Path();
    abPath.moveTo(0, 0);
    abPath.lineTo(size.width / 2, size.height * 0.48);
    abPath.lineTo(size.width, 0);
    abPath.close();
    canvas.drawPath(abPath, paint);

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
        const Offset(0, 0),
        Offset(size.width / 2, size.height * 0.48), linePaint);
    canvas.drawLine(
        Offset(size.width, 0),
        Offset(size.width / 2, size.height * 0.48), linePaint);
    canvas.drawLine(
        Offset(0, size.height),
        Offset(size.width / 2, size.height * 0.55), linePaint);
    canvas.drawLine(
        Offset(size.width, size.height),
        Offset(size.width / 2, size.height * 0.55), linePaint);
  }

  @override
  bool shouldRepaint(_) => false;
}
