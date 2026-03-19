import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';

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

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      emoji: '💌',
      tag: 'CARTAS PARA O FUTURO',
      title: 'Palavras que chegam\nna hora certa',
      subtitle: 'Escreva uma carta hoje. Escolha quando ela será aberta. Deixe o tempo fazer sua magia.',
      accent: true,
    ),
    _OnboardingData(
      emoji: '🔒',
      tag: 'SEU COFRE DIGITAL',
      title: 'Bloqueada até o\nmomento perfeito',
      subtitle: 'A carta fica guardada com segurança até a data que você escolher — pode ser amanhã, ou daqui a 10 anos.',
      accent: false,
    ),
    _OnboardingData(
      emoji: '✨',
      tag: 'COMPARTILHE AMOR',
      title: 'Inspire outras pessoas\ncom sua história',
      subtitle: 'Cartas abertas podem ir para o feed público. Espalhe amor, amizade e emoção para o mundo.',
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

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    } else {
      widget.onFinish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ink,
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
                    AppColors.accent.withOpacity(_pages[_currentPage].accent ? 0.12 : 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            PageView.builder(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _buildPage(_pages[i]),
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
                          _pages.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == i ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == i ? AppColors.accent : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: _next,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [BoxShadow(color: AppColors.accent.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8))],
                            ),
                            child: Text(
                              _currentPage == _pages.length - 1 ? 'Criar minha primeira carta' : 'Continuar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: widget.onFinish,
                        child: Text('Já tenho uma conta',
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
        padding: const EdgeInsets.fromLTRB(32, 60, 32, 200),
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
                      AppColors.accent.withOpacity(0.15),
                      AppColors.accent.withOpacity(0.05),
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
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: Text(page.tag, style: GoogleFonts.dmSans(fontSize: 10, color: AppColors.accent, fontWeight: FontWeight.w500, letterSpacing: 2)),
            ),
            const SizedBox(height: 20),
            Text(page.title, textAlign: TextAlign.center,
              style: GoogleFonts.dmSerifDisplay(fontSize: 30, color: AppColors.white, fontStyle: FontStyle.italic, height: 1.3)),
            const SizedBox(height: 16),
            Text(page.subtitle, textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 15, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w300, height: 1.7)),
          ],
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
