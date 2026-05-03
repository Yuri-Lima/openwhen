import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import '../../../../shared/widgets/owl_logo.dart' show OwlSealOpeningAnimation;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/firebase_locale_helper.dart';
import '../../../../core/utils/age_verification.dart';
import '../auth_error_messages.dart';
import '../providers/auth_provider.dart';

/// Quando `true`, mostra botões de social sign-in (Apple) no login.
const bool kSocialSignInEnabled = true;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  int _selectedTab = 0;
  String? _passwordError;

  /// Inicialização lazy: após hot reload `initState` não corre outra vez, mas o primeiro
  /// acesso em `build` inicializa o controller.
  late final AnimationController _sealCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 5500),
  );

  late final AnimationController _shakeCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  late final Animation<double> _shakeAnim = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 8.0), weight: 1),
    TweenSequenceItem(tween: Tween(begin: 8.0, end: -8.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: 6.0, end: -6.0), weight: 2),
    TweenSequenceItem(tween: Tween(begin: -6.0, end: 0.0), weight: 1),
  ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeOut));

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_clearPasswordErrorOnEdit);
    _passwordController.addListener(_clearPasswordErrorOnEdit);
  }

  void _clearPasswordErrorOnEdit() {
    if (_passwordError != null) {
      setState(() => _passwordError = null);
    }
  }

  @override
  void dispose() {
    _sealCtrl.dispose();
    _shakeCtrl.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onSealTap() async {
    if (_sealCtrl.isAnimating) return;
    if (_sealCtrl.isCompleted) _sealCtrl.reset();
    await _sealCtrl.forward();
  }

  Future<void> _login() async {
    final l10n = AppLocalizations.of(context)!;
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.snackFillAllFields)),
      );
      return;
    }
    setState(() {
      _isLoading = true;
      _passwordError = null;
    });
    try {
      await ref.read(authNotifierProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
      if (!mounted) return;
      final authAsync = ref.read(authNotifierProvider);
      if (authAsync.hasError) {
        _showInlineLoginError(authErrorMessage(l10n, authAsync.error));
      } else {
        await AnalyticsService.logLogin();
      }
    } catch (e) {
      if (mounted) _showInlineLoginError(authErrorMessage(l10n, e));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _showInlineLoginError(String message) {
    setState(() => _passwordError = message);
    HapticFeedback.mediumImpact();
    _shakeCtrl.forward(from: 0);
  }

  /// Shows an age-gate dialog with Terms checkbox + Date of Birth picker
  /// before social sign-in.
  /// Returns the [DateTime] date of birth if confirmed, or `null` if cancelled.
  Future<DateTime?> _showSocialAgeGate() async {
    final l10n = AppLocalizations.of(context)!;
    bool acceptedTerms = false;
    DateTime? dateOfBirth;
    String? dateError;

    final result = await showDialog<DateTime?>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            Widget buildCheck({
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

            return AlertDialog(
              backgroundColor: context.pal.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                l10n.socialSignInAgeGateTitle,
                style: GoogleFonts.dmSerifDisplay(
                  fontSize: 20,
                  color: context.pal.ink,
                  fontStyle: FontStyle.italic,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.socialSignInAgeGateBody,
                    style: GoogleFonts.dmSans(
                      fontSize: 13,
                      color: context.pal.inkSoft,
                    ),
                  ),
                  const SizedBox(height: 16),
                  buildCheck(
                    value: acceptedTerms,
                    onChanged: (v) =>
                        setDialogState(() => acceptedTerms = v ?? false),
                    child: Text.rich(
                      TextSpan(
                        text: l10n.registerAcceptTermsPrefix,
                        style: GoogleFonts.dmSans(
                          fontSize: 12,
                          color: context.pal.inkSoft,
                          height: 1.4,
                        ),
                        children: [
                          TextSpan(
                            text: l10n.settingsTerms,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: context.pal.accent,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: l10n.registerAcceptTermsAnd),
                          TextSpan(
                            text: l10n.settingsPrivacy,
                            style: GoogleFonts.dmSans(
                              fontSize: 12,
                              color: context.pal.accent,
                              fontWeight: FontWeight.w500,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Date of birth picker
                  Text(
                    l10n.registerDateOfBirthLabel,
                    style: GoogleFonts.dmSans(
                      fontSize: 10,
                      color: context.pal.inkFaint,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () async {
                      final now = DateTime.now();
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: dateOfBirth ?? DateTime(now.year - 18, now.month, now.day),
                        firstDate: DateTime(1900),
                        lastDate: now,
                        helpText: l10n.registerDateOfBirthLabel,
                        builder: (c, child) {
                          return Theme(
                            data: Theme.of(c).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: context.pal.accent,
                                onSurface: context.pal.ink,
                                surface: context.pal.card,
                              ),
                              dialogBackgroundColor: context.pal.card,
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setDialogState(() {
                          dateOfBirth = picked;
                          dateError = null;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: context.pal.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: dateError != null
                              ? Colors.red.withOpacity(0.6)
                              : context.pal.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: context.pal.inkSoft),
                          const SizedBox(width: 10),
                          Text(
                            dateOfBirth != null
                                ? DateFormat.yMMMd(Localizations.localeOf(ctx).toString()).format(dateOfBirth!)
                                : l10n.registerDateOfBirthHint,
                            style: GoogleFonts.dmSans(
                              fontSize: 14,
                              color: dateOfBirth != null ? context.pal.ink : context.pal.inkFaint,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (dateError != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      dateError!,
                      style: GoogleFonts.dmSans(fontSize: 11, color: Colors.red),
                    ),
                  ],
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, null),
                  child: Text(
                    MaterialLocalizations.of(ctx).cancelButtonLabel,
                    style: GoogleFonts.dmSans(color: context.pal.inkSoft),
                  ),
                ),
                ElevatedButton(
                  onPressed: (acceptedTerms && dateOfBirth != null)
                      ? () {
                          final ageErr = validateAge(dateOfBirth!);
                          if (ageErr != null) {
                            setDialogState(() {
                              dateError = l10n.registerAgeUnder(getMinimumAgeForLocale());
                            });
                            return;
                          }
                          Navigator.pop(ctx, dateOfBirth);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.pal.accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.socialSignInContinue,
                    style: GoogleFonts.dmSans(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    return result;
  }

  Future<void> _signInWithApple() async {
    final dateOfBirth = await _showSocialAgeGate();
    if (dateOfBirth == null || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).signInWithApple(dateOfBirth: dateOfBirth);
      if (!mounted) return;
      final authAsync = ref.read(authNotifierProvider);
      if (authAsync.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(authAsync.error.toString()))),
        );
      } else {
        await AnalyticsService.logLogin(method: 'apple');
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      // User cancelled — do nothing.
      if (e.code == AuthorizationErrorCode.canceled) {
        // silently ignore
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.message))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _signInWithGoogle() async {
    final dateOfBirth = await _showSocialAgeGate();
    if (dateOfBirth == null || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).signInWithGoogle(dateOfBirth: dateOfBirth);
      if (!mounted) return;
      final authAsync = ref.read(authNotifierProvider);
      if (authAsync.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(authAsync.error.toString()))),
        );
      } else {
        await AnalyticsService.logLogin(method: 'google');
      }
    } catch (e) {
      // User cancelled — the google_sign_in plugin throws when user cancels.
      if (e.toString().contains('google-sign-in-cancelled')) {
        // silently ignore
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  void _showForgotPassword(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resetEmailController = TextEditingController(
      text: _emailController.text.trim(),
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: context.pal.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        bool isSending = false;
        return StatefulBuilder(
          builder: (stfCtx, setSheetState) {
            final bottomInset = MediaQuery.viewInsetsOf(sheetCtx).bottom;
            return Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(sheetCtx).height * 0.85),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: context.pal.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.forgotPasswordTitle,
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 20,
                    color: context.pal.ink,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.forgotPasswordBody,
                  style: GoogleFonts.dmSans(
                    fontSize: 13,
                    color: context.pal.inkSoft,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: resetEmailController,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: true,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: context.pal.ink,
                  ),
                  decoration: InputDecoration(
                    hintText: l10n.forgotPasswordHint,
                    hintStyle: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: context.pal.inkSoft.withOpacity(0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: context.pal.inkSoft,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: context.pal.bg,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.pal.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.pal.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: context.pal.accent),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final email = resetEmailController.text.trim();
                          if (email.isEmpty || !email.contains('@')) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.forgotPasswordErrorInvalidEmail,
                                  style: GoogleFonts.dmSans(fontSize: 13),
                                ),
                              ),
                            );
                            return;
                          }
                          setSheetState(() => isSending = true);
                          try {
                            await applyFirebaseLocale();
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email);
                            if (sheetCtx.mounted) Navigator.pop(sheetCtx);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.forgotPasswordSent(email),
                                    style: GoogleFonts.dmSans(fontSize: 13),
                                  ),
                                ),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            setSheetState(() => isSending = false);
                            if (!context.mounted) return;
                            final msg = switch (e.code) {
                              'user-not-found' =>
                                l10n.forgotPasswordErrorNoUser,
                              'invalid-email' =>
                                l10n.forgotPasswordErrorInvalidEmail,
                              _ => l10n.forgotPasswordErrorGeneric,
                            };
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  msg,
                                  style: GoogleFonts.dmSans(fontSize: 13),
                                ),
                              ),
                            );
                          } catch (_) {
                            setSheetState(() => isSending = false);
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  l10n.forgotPasswordErrorGeneric,
                                  style: GoogleFonts.dmSans(fontSize: 13),
                                ),
                              ),
                            );
                          }
                        },
                  child: isSending
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: context.pal.white,
                          ),
                        )
                      : Text(
                          l10n.forgotPasswordButton,
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
            );
          },
        );
      },
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
    String? errorText,
  }) {
    final hasError = errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.dmSans(
            fontSize: 10,
            color: hasError ? context.pal.accent : context.pal.inkFaint,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: context.pal.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: hasError ? context.pal.accent : context.pal.border,
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: Row(
            children: [
              Icon(icon, size: 18, color: context.pal.inkFaint.withOpacity(0.6)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure && !_showPassword,
                  keyboardType: keyboard,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: context.pal.ink,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: GoogleFonts.dmSans(color: context.pal.inkFaint),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              if (hasToggle)
                GestureDetector(
                  onTap: () => setState(() => _showPassword = !_showPassword),
                  child: Icon(
                    _showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    size: 18,
                    color: context.pal.inkFaint.withOpacity(0.6),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

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
                // Brilho vermelho radial
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
                // Envelope + nome
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 32),
                      // Envelope
                      SizedBox(
                        width: 160,
                        height: 110,
                        child: Stack(
                          children: [
                            // Corpo do envelope
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
                                    color: context.pal.accent.withOpacity(0.2),
                                    blurRadius: 30,
                                    offset: const Offset(0, 0),
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
                            // Lacre (mesma animação da abertura de carta)
                            Positioned(
                              bottom: 18,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: _onSealTap,
                                  child: SizedBox(
                                    width: 64,
                                    height: 64,
                                    child: Center(
                                      child: OwlSealOpeningAnimation(
                                        size: 56,
                                        animation: _sealCtrl,
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
                        'Whenote',
                        style: GoogleFonts.dmSerifDisplay(
                          fontSize: 26,
                          color: context.pal.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _selectedTab == 0
                            ? l10n.loginHeroLetters
                            : l10n.loginHeroCreateAccount,
                        style: GoogleFonts.dmSans(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.2),
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
          // Tabs
          Container(
            color: context.pal.card,
            child: Row(
              children: [
                _buildTab(l10n.loginTabSignIn, 0),
                _buildTab(l10n.loginTabCreateAccount, 1),
              ],
            ),
          ),
          // Formulário
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
              child: _selectedTab == 0 ? _buildLoginForm() : _buildRegisterForm(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index) {
    final isActive = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isActive ? context.pal.accent : context.pal.border,
                width: isActive ? 2 : 1,
              ),
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
              color: isActive ? context.pal.ink : context.pal.inkFaint,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          controller: _emailController,
          icon: Icons.mail_outline,
          hint: l10n.hintEmail,
          label: l10n.labelEmail,
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: _shakeAnim,
          builder: (context, child) => Transform.translate(
            offset: Offset(_shakeAnim.value, 0),
            child: child,
          ),
          child: _buildField(
            controller: _passwordController,
            icon: Icons.lock_outline,
            hint: l10n.hintPassword,
            label: l10n.labelPassword,
            obscure: true,
            hasToggle: true,
            errorText: _passwordError,
          ),
        ),
        if (_passwordError != null) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                Icon(Icons.error_outline,
                    size: 14, color: context.pal.accent),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    _passwordError!,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: context.pal.accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPassword(context),
              child: Text(
                l10n.loginForgotPasswordInline,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: context.pal.accent,
                  fontWeight: FontWeight.w600,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ] else
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => _showForgotPassword(context),
              child: Text(
                l10n.loginForgotPassword,
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  color: context.pal.accent,
                ),
              ),
            ),
          ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _login,
          child: _isLoading
              ? CircularProgressIndicator(color: context.pal.white)
              : Text(
                  l10n.loginButtonSignIn,
                  style: GoogleFonts.dmSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ),
        if (kSocialSignInEnabled) ...[
          const SizedBox(height: 24),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildSocialButtons(),
        ],
        const SizedBox(height: 24),
        _buildFooter(),
      ],
    );
  }

  Widget _buildRegisterForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.loginRegisterBlurb,
          textAlign: TextAlign.center,
          style: GoogleFonts.dmSans(
            fontSize: 14,
            color: context.pal.inkSoft,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.pal.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: context.pal.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _registerBullet(l10n.loginBullet1),
              const SizedBox(height: 10),
              _registerBullet(l10n.loginBullet2),
              const SizedBox(height: 10),
              _registerBullet(l10n.loginBullet3),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  Navigator.pushNamed(context, '/register');
                },
          child: Text(
            l10n.loginCreateAccount,
            style: GoogleFonts.dmSans(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: () => setState(() => _selectedTab = 0),
          child: Text(
            l10n.loginAlreadyHaveAccount,
            style: GoogleFonts.dmSans(
              fontSize: 13,
              color: context.pal.inkFaint,
            ),
          ),
        ),
        if (kSocialSignInEnabled) ...[
          const SizedBox(height: 16),
          _buildDivider(),
          const SizedBox(height: 24),
          _buildSocialButtons(),
        ],
        const SizedBox(height: 24),
        _buildFooter(),
      ],
    );
  }

  Widget _registerBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle_outline, size: 18, color: context.pal.accent),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(fontSize: 13, color: context.pal.ink),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(child: Divider(color: context.pal.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            l10n.loginOrContinueWith,
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: context.pal.inkFaint,
            ),
          ),
        ),
        Expanded(child: Divider(color: context.pal.border)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Column(
      children: [
        // Apple — only on iOS
        if (Platform.isIOS)
          GestureDetector(
            onTap: _isLoading ? null : _signInWithApple,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: context.pal.card,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: context.pal.border, width: 1.5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apple, size: 22, color: context.pal.ink),
                  const SizedBox(width: 8),
                  Text(
                    'Continuar com Apple',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: context.pal.ink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (Platform.isIOS) const SizedBox(height: 12),
        // Google — all platforms
        GestureDetector(
          onTap: _isLoading ? null : _signInWithGoogle,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.pal.border, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'G',
                  style: GoogleFonts.dmSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4285F4),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Continuar com Google',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: context.pal.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      l10n.loginLegalFooter,
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        color: context.pal.inkFaint,
        height: 1.5,
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

    // Aba triangular escura
    final abPath = Path();
    abPath.moveTo(0, 0);
    abPath.lineTo(size.width / 2, size.height * 0.48);
    abPath.lineTo(size.width, 0);
    abPath.close();
    canvas.drawPath(abPath, paint);

    // Linhas diagonais do envelope
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      const Offset(0, 0),
      Offset(size.width / 2, size.height * 0.48),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(size.width / 2, size.height * 0.48),
      linePaint,
    );
    canvas.drawLine(
      Offset(0, size.height),
      Offset(size.width / 2, size.height * 0.55),
      linePaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height),
      Offset(size.width / 2, size.height * 0.55),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
