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
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  List<_OnboardingData> _pages(AppLocalizations l10n) => [
    _OnboardingData(
      emoji: '💌',
      tag: l10n.onboardingTag1,
      title: l10n.onboardingTitle1,
      subtitle: l10n.onboardingSubtitle1,
      accent: true,
    ),
    _OnboardingData(
      emoji: '🔒',
      tag: l10n.onboardingTag2,
      title: l10n.onboardingTitle2,
      subtitle: l10n.onboardingSubtitle2,
      accent: false,
    ),
    _OnboardingData(
      emoji: '✨',
      tag: l10n.onboardingTag3,
      title: l10n.onboardingTitle3,
      subtitle: l10n.onboardingSubtitle3,
      accent: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _next(int pageCount) {
    if (_currentPage < pageCount - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = _pages(l10n);
    return Scaffold(
      backgroundColor: context.pal.headerGradient.first,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.2,
                  colors: [
                    context.pal.accent.withOpacity(pages[_currentPage].accent ? 0.12 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount: pages.length,
                itemBuilder: (_, i) => _buildPage(pages[i]),
              ),
            ),
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == i ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == i ? context.pal.accent : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () => _next(pages.length),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: context.pal.accent,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [BoxShadow(color: context.pal.accent.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                            ),
                            child: Text(
                              _currentPage == pages.length - 1 ? l10n.onboardingCreateFirst : l10n.actionContinue,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: widget.onFinish,
                        child: Text(l10n.onboardingAlreadyHaveAccount,
                          style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.3))),
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

  Widget _buildPage(_OnboardingData page) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 24, 32, 200),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 160, height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(colors: [
                              context.pal.accent.withOpacity(0.15),
                              context.pal.accent.withOpacity(0.05),
                              Colors.transparent,
                            ]),
                          ),
                        ),
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.05),
                            border: Border.all(color: Colors.white.withOpacity(0.08)),
                          ),
                          child: Center(child: Text(page.emoji, style: const TextStyle(fontSize: 44))),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: context.pal.accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: context.pal.accent.withOpacity(0.3)),
                      ),
                      child: Text(page.tag, style: GoogleFonts.dmSans(fontSize: 10, color: context.pal.accent, fontWeight: FontWeight.w500, letterSpacing: 2)),
                    ),
                    const SizedBox(height: 20),
                    Text(page.title, textAlign: TextAlign.center,
                      style: GoogleFonts.dmSerifDisplay(fontSize: 30, color: context.pal.white, fontStyle: FontStyle.italic, height: 1.3)),
                    const SizedBox(height: 16),
                    Text(page.subtitle, textAlign: TextAlign.center,
                      style: GoogleFonts.dmSans(fontSize: 15, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w300, height: 1.7)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _OnboardingData {
  final String emoji;
  final String tag;
  final String title;
  final String subtitle;
  final bool accent;

  const _OnboardingData({
    required this.emoji,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.accent,
  });
}
