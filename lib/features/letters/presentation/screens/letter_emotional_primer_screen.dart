import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/utils/letter_primer_prefs.dart';

/// One-time emotional warning shown before the letter-opening animation.
/// Pushes `true` when the user taps "Open now", `false`/`null` on "View later"
/// or the system back gesture. Both paths mark the primer as seen so it never
/// appears again.
class LetterEmotionalPrimerScreen extends StatefulWidget {
  const LetterEmotionalPrimerScreen({super.key});

  @override
  State<LetterEmotionalPrimerScreen> createState() =>
      _LetterEmotionalPrimerScreenState();
}

class _LetterEmotionalPrimerScreenState
    extends State<LetterEmotionalPrimerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleOpenNow() async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);
    await markLetterEmotionalPrimerSeen();
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _handleViewLater() async {
    await markLetterEmotionalPrimerSeen();
    if (!mounted) return;
    Navigator.pop(context, false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // Subtle radial glow (static — no pulsing animation)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 1.1,
                    colors: [
                      p.accent.withValues(alpha:0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Icon circle
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                p.accent.withValues(alpha:0.12),
                                p.accent.withValues(alpha:0.04),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: p.accentWarm,
                            border: Border.all(
                                color: p.accent.withValues(alpha:0.25), width: 1.5),
                          ),
                          child: Icon(
                            Icons.mail_outline_rounded,
                            color: p.accent,
                            size: 36,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Title
                    Text(
                      l10n.letterEmotionalPrimerTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 24,
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Body
                    Text(
                      l10n.letterEmotionalPrimerBody,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha:0.45),
                        fontWeight: FontWeight.w300,
                        height: 1.6,
                      ),
                    ),

                    const Spacer(flex: 2),

                    // Primary button — Open now
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _handleOpenNow,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.accent,
                          disabledBackgroundColor: p.accent.withValues(alpha:0.4),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: _isProcessing
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white.withValues(alpha:0.8),
                                ),
                              )
                            : Text(
                                l10n.letterEmotionalPrimerOpenNow,
                                style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                  letterSpacing: 0.3,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Secondary button — View later
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _handleViewLater,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                              color: Colors.white.withValues(alpha:0.15)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          l10n.letterEmotionalPrimerViewLater,
                          style: GoogleFonts.dmSans(
                            fontSize: 15,
                            color: Colors.white.withValues(alpha:0.55),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Back button (top-left — matches LetterOpeningScreen pattern)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              child: GestureDetector(
                onTap: _handleViewLater,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha:0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 18,
                    color: Colors.white.withValues(alpha:0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
