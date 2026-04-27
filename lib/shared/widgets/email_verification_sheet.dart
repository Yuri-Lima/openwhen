import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/firebase_locale_helper.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';

/// Shows a modal bottom sheet explaining email verification is required.
///
/// Returns `true` if the user successfully verified during this session,
/// `false` or `null` if dismissed without verifying.
Future<bool?> showEmailVerificationSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const _EmailVerificationSheet(),
  );
}

class _EmailVerificationSheet extends StatefulWidget {
  const _EmailVerificationSheet();

  @override
  State<_EmailVerificationSheet> createState() =>
      _EmailVerificationSheetState();
}

class _EmailVerificationSheetState extends State<_EmailVerificationSheet> {
  static const _cooldownSeconds = 60;

  bool _checking = false;
  bool _resending = false;
  int _cooldown = 0;
  Timer? _cooldownTimer;
  String? _errorMessage;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldown = _cooldownSeconds;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _cooldown--;
        if (_cooldown <= 0) t.cancel();
      });
    });
  }

  Future<void> _resendEmail() async {
    setState(() {
      _resending = true;
      _errorMessage = null;
    });
    try {
      await applyFirebaseLocale();
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      _startCooldown();
    } catch (_) {
      // Firebase rate-limits automatically; fail silently.
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  Future<void> _checkVerified() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _checking = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified == true) {
        await user!.getIdTokenResult(true);
        if (mounted) Navigator.of(context).pop(true);
        return;
      }
      if (mounted) {
        setState(() => _errorMessage = l10n.emailVerificationNotYet);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = l10n.emailVerificationNotYet);
      }
    } finally {
      if (mounted) setState(() => _checking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: p.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: p.inkFaint,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Icon(Icons.mark_email_unread_outlined, size: 48, color: p.accent),
          const SizedBox(height: 16),
          Text(
            l10n.emailVerificationTitle,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 20,
              color: p.ink,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            l10n.emailVerificationSubtitle(email),
            style: GoogleFonts.dmSans(
              fontSize: 14,
              color: p.inkSoft,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _checking ? null : _checkVerified,
              child: _checking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l10n.emailVerificationAlreadyDone,
                      style: GoogleFonts.dmSans(fontWeight: FontWeight.w600),
                    ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed:
                  (_cooldown > 0 || _resending) ? null : _resendEmail,
              child: _resending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      _cooldown > 0
                          ? l10n.emailVerificationResendCooldown(
                              _cooldown.toString())
                          : l10n.emailVerificationResend,
                      style: GoogleFonts.dmSans(),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              l10n.emailVerificationLater,
              style: GoogleFonts.dmSans(color: p.inkFaint),
            ),
          ),
        ],
      ),
    );
  }
}
