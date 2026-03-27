import 'package:flutter/material.dart';
import '../../../../shared/widgets/owl_logo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../providers/auth_provider.dart';
import 'register_screen.dart';

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
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
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
          SnackBar(content: Text('Erro: $e')),
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
            color: AppColors.inkFaint,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: AppColors.bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
          child: Row(
            children: [
              Icon(icon, size: 18, color: AppColors.inkFaint.withOpacity(0.6)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  enableInteractiveSelection: false,
                  obscureText: obscure && !_showPassword,
                  keyboardType: keyboard,
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: GoogleFonts.dmSans(color: AppColors.inkFaint),
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
                    color: AppColors.inkFaint.withOpacity(0.6),
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
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // Hero escuro
          Container(
            height: 310,
            color: AppColors.ink,
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
                          AppColors.accent.withOpacity(0.12),
                          AppColors.accent.withOpacity(0.03),
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
                                    color: AppColors.accent.withOpacity(0.2),
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
                          color: AppColors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const OwlWatermark(width: 22, height: 26),
                      const SizedBox(height: 6),
                      Text(
                        _selectedTab == 0
                            ? 'CARTAS PARA O FUTURO'
                            : 'CRIE SUA CONTA GRÁTIS',
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
            color: AppColors.white,
            child: Row(
              children: [
                _buildTab('Entrar', 0),
                _buildTab('Criar conta', 1),
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
                color: isActive ? AppColors.accent : AppColors.border,
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
              color: isActive ? AppColors.ink : AppColors.inkFaint,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          controller: _emailController,
          icon: Icons.mail_outline,
          hint: 'seu@email.com',
          label: 'E-mail',
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildField(
          controller: _passwordController,
          icon: Icons.lock_outline,
          hint: 'sua senha',
          label: 'Senha',
          obscure: true,
          hasToggle: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: Text(
              'Esqueceu a senha?',
              style: GoogleFonts.dmSans(
                fontSize: 12,
                color: AppColors.accent,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: _isLoading ? null : _login,
          child: _isLoading
              ? const CircularProgressIndicator(color: AppColors.white)
              : Text(
                  'Entrar',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildField(
          controller: TextEditingController(),
          icon: Icons.person_outline,
          hint: 'seu nome',
          label: 'Nome',
        ),
        const SizedBox(height: 16),
        _buildField(
          controller: _emailController,
          icon: Icons.mail_outline,
          hint: 'seu@email.com',
          label: 'E-mail',
          keyboard: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        _buildField(
          controller: _passwordController,
          icon: Icons.lock_outline,
          hint: 'crie uma senha',
          label: 'Senha',
          obscure: true,
          hasToggle: true,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isLoading ? null : () {
            Navigator.pushNamed(context, '/register');
          },
          child: Text(
            'Criar minha conta',
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

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'ou continue com',
            style: GoogleFonts.dmSans(
              fontSize: 12,
              color: AppColors.inkFaint,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1.5),
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
                    color: AppColors.ink,
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
              color: AppColors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1.5),
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
                    color: AppColors.ink,
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
    return Text(
      'Ao entrar você aceita os Termos de Uso e a Política de Privacidade.',
      textAlign: TextAlign.center,
      style: GoogleFonts.dmSans(
        fontSize: 11,
        color: AppColors.inkFaint,
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
