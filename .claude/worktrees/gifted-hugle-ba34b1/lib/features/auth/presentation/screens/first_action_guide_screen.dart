import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../core/navigation/deferred_screens.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

/// One-time screen shown after a new user's first login.
/// Offers two choices: send a letter or create a time capsule.
/// Sets `hasCompletedFirstAction = true` when the user picks an
/// option or taps "Explore first", so the screen never appears again.
class FirstActionGuideScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const FirstActionGuideScreen({super.key, required this.onComplete});

  @override
  State<FirstActionGuideScreen> createState() => _FirstActionGuideScreenState();
}

class _FirstActionGuideScreenState extends State<FirstActionGuideScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  /// Mark first-action as done in Firestore and call the completion callback.
  Future<void> _complete() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      await FirebaseFirestore.instance
          .collection(FirestoreCollections.users)
          .doc(uid)
          .update({'hasCompletedFirstAction': true});
    }
    widget.onComplete();
  }

  /// Navigate to write-letter, then mark complete.
  void _goToWriteLetter() {
    _complete();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeferredWriteLetterPage()),
    );
  }

  /// Navigate to create-capsule, then mark complete.
  void _goToCreateCapsule() {
    _complete();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DeferredCreateCapsulePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;

    return Scaffold(
      backgroundColor: p.headerGradient.first,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            // Accent glow background
            Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    p.accent.withValues(alpha:0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    // Emoji circle
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [
                              p.accent.withValues(alpha:0.15),
                              p.accent.withValues(alpha:0.05),
                              Colors.transparent,
                            ]),
                          ),
                        ),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha:0.05),
                            border: Border.all(
                                color: Colors.white.withValues(alpha:0.08)),
                          ),
                          child: const Center(
                              child:
                                  Text('🦉', style: TextStyle(fontSize: 40))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Title
                    Text(
                      l10n.firstActionTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 26,
                        color: p.white,
                        fontStyle: FontStyle.italic,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.firstActionSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha:0.4),
                        fontWeight: FontWeight.w300,
                        height: 1.6,
                      ),
                    ),
                    const Spacer(flex: 1),
                    // Option cards
                    _buildOptionCard(
                      icon: Icons.mail_outline_rounded,
                      title: l10n.firstActionLetterTitle,
                      subtitle: l10n.firstActionLetterSubtitle,
                      onTap: _goToWriteLetter,
                      palette: p,
                    ),
                    const SizedBox(height: 12),
                    _buildOptionCard(
                      icon: Icons.hourglass_empty_rounded,
                      title: l10n.firstActionCapsuleTitle,
                      subtitle: l10n.firstActionCapsuleSubtitle,
                      onTap: _goToCreateCapsule,
                      palette: p,
                    ),
                    const SizedBox(height: 24),
                    // Skip link
                    GestureDetector(
                      onTap: _complete,
                      child: Text(
                        l10n.firstActionSkip,
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha:0.3),
                        ),
                      ),
                    ),
                    const Spacer(flex: 1),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required dynamic palette,
  }) {
    final p = context.pal;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha:0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withValues(alpha:0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: p.accentWarm,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: p.accent, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.dmSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: p.white)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha:0.4),
                          fontWeight: FontWeight.w300)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha:0.2)),
          ],
        ),
      ),
    );
  }
}
