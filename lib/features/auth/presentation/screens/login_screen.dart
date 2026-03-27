import 'package:flutter/material.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;
  int _selectedTab = 0;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).login(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorGeneric(e.toString()))),
        );
      }
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Widget _buildField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required String label,
    bool obscure = false,
    bool hasToggle = false,
    TextInputType keyboard = TextInputType.text,
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
              Icon(icon, size: 18, color: context.pal.inkFaint.withOpacity(0.6)),
              const SizedBox(width: 10),
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
                            // Lacre
                            Positioned(
                              bottom: 18,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: const OwlLogo(size: 110),
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
        _buildField(
          controller: _passwordController,
          icon: Icons.lock_outline,
          hint: l10n.hintPassword,
          label: l10n.labelPassword,
          obscure: true,
          hasToggle: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
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
        const SizedBox(height: 24),
        _buildDivider(),
        const SizedBox(height: 24),
        _buildSocialButtons(),
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
        const SizedBox(height: 16),
        _buildDivider(),
        const SizedBox(height: 24),
        _buildSocialButtons(),
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
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.pal.border, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('🍎', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text(
                  'Apple',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: context.pal.ink,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: context.pal.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: context.pal.border, width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('G', style: GoogleFonts.dmSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF4285F4),
                )),
                const SizedBox(width: 8),
                Text(
                  'Google',
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
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
