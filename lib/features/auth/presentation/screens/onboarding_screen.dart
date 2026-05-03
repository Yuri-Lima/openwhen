import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish;

  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: context.pal.headerGradient.first,
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
                    context.pal.accent.withValues(alpha:0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Main content — single page
            Positioned.fill(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 24, 32, 200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: constraints.maxHeight),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Emoji circle
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 160,
                                    height: 160,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(colors: [
                                        context.pal.accent.withValues(alpha:0.15),
                                        context.pal.accent.withValues(alpha:0.05),
                                        Colors.transparent,
                                      ]),
                                    ),
                                  ),
                                  Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(alpha:0.05),
                                      border: Border.all(
                                          color:
                                              Colors.white.withValues(alpha:0.08)),
                                    ),
                                    child: const Center(
                                        child: Text('💌',
                                            style: TextStyle(fontSize: 44))),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              // Tag
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: context.pal.accent.withValues(alpha:0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color:
                                          context.pal.accent.withValues(alpha:0.3)),
                                ),
                                child: Text(l10n.onboardingTag1,
                                    style: GoogleFonts.dmSans(
                                        fontSize: 10,
                                        color: context.pal.accent,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 2)),
                              ),
                              const SizedBox(height: 20),
                              // Title
                              Text(l10n.onboardingTitle1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 30,
                                      color: context.pal.white,
                                      fontStyle: FontStyle.italic,
                                      height: 1.3)),
                              const SizedBox(height: 16),
                              // Subtitle
                              Text(l10n.onboardingSubtitle1,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSans(
                                      fontSize: 15,
                                      color: Colors.white.withValues(alpha:0.4),
                                      fontWeight: FontWeight.w300,
                                      height: 1.7)),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Bottom buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: widget.onFinish,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: context.pal.accent,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        context.pal.accent.withValues(alpha:0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8))
                              ],
                            ),
                            child: Text(
                              l10n.onboardingCreateFirst,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: widget.onFinish,
                        child: Text(l10n.onboardingAlreadyHaveAccount,
                            style: GoogleFonts.dmSans(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha:0.3))),
                      ),
                    ],
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
