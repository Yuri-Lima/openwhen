import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/widgets/owl_logo.dart';

class _C {
  static const bg         = Color(0xFFF7F4F0);
  static const white      = Color(0xFFFFFFFF);
  static const ink        = Color(0xFF1A1714);
  static const inkSoft    = Color(0xFF6B6560);
  static const inkFaint   = Color(0xFFC4BFB9);
  static const accent     = Color(0xFFC0392B);
  static const accentWarm = Color(0xFFF0EAE4);
  static const border     = Color(0xFFEDE8E3);
}

class CapsuleOpeningScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  const CapsuleOpeningScreen({super.key, required this.data, required this.docId});

  @override
  State<CapsuleOpeningScreen> createState() => _CapsuleOpeningScreenState();
}

class _CapsuleOpeningScreenState extends State<CapsuleOpeningScreen>
    with TickerProviderStateMixin {

  int _phase = 0;
  bool _publishing = false;

  late final AnimationController _glowCtrl;
  late final AnimationController _shakeCtrl;
  late final AnimationController _openCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _contentCtrl;

  late final Animation<double> _glowAnim;
  late final Animation<double> _shakeAnim;
  late final Animation<double> _envelopeFade;
  late final Animation<double> _paperRise;
  late final Animation<double> _contentFade;

  final List<_Particle> _particles = [];
  final _rnd = math.Random();

  final themeColors = {
    'memories':      Color(0xFF6B6560),
    'goals':         Color(0xFFC0392B),
    'feelings':      Color(0xFFC9A84C),
    'relationships': Color(0xFF5B8DB8),
    'growth':        Color(0xFF4A8C6F),
  };

  Color get _themeColor => themeColors[widget.data['theme']] ?? _C.accent;

  @override
  void initState() {
    super.initState();

    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _openCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _glowAnim = Tween(begin: 0.08, end: 0.22).animate(_glowCtrl);
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
    _envelopeFade = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _openCtrl, curve: const Interval(0.5, 1.0)));
    _paperRise = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _openCtrl, curve: Curves.easeOut));
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn);

    _particleCtrl.addListener(() { if (mounted) setState(() => _tickParticles()); });

    _startAnimation();
  }

  void _spawnParticles() {
    for (int i = 0; i < 60; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 1.5 + _rnd.nextDouble() * 4.0;
      _particles.add(_Particle(
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2.0),
        size: 3 + _rnd.nextDouble() * 6,
        color: _themeColor.withOpacity(0.7 + _rnd.nextDouble() * 0.3),
        life: 0.8 + _rnd.nextDouble() * 0.5,
      ));
    }
  }

  void _tickParticles() {
    for (final p in _particles) p.tick();
    _particles.removeWhere((p) => p.life <= 0);
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    await _shakeCtrl.forward();
    _spawnParticles();
    await FirebaseFirestore.instance.collection('capsules').doc(widget.docId).update({
      'status': 'opened',
      'openedAt': FieldValue.serverTimestamp(),
    });
    await _openCtrl.forward();
    if (mounted) setState(() => _phase = 1);
    _contentCtrl.forward();
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    await FirebaseFirestore.instance.collection('capsules').doc(widget.docId).update({
      'isPublic': true,
      'publishedAt': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      setState(() => _publishing = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Cápsula publicada no feed!', style: GoogleFonts.dmSans()),
        backgroundColor: _C.accent,
      ));
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _shakeCtrl.dispose();
    _openCtrl.dispose();
    _particleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: _C.ink,
      body: Stack(
        children: [
          // Glow de fundo
          AnimatedBuilder(
            animation: _glowAnim,
            builder: (_, __) => Container(
              width: size.width, height: size.height,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    _themeColor.withOpacity(_glowAnim.value),
                    _themeColor.withOpacity(_glowAnim.value * 0.15),
                    Colors.transparent,
                  ],
                  radius: 0.7,
                ),
              ),
            ),
          ),

          // Partículas
          CustomPaint(
            size: size,
            painter: _ParticlePainter(_particles, center: size.center(Offset.zero)),
          ),

          // Botão voltar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ),

          // FASE 0 — Envelope
          if (_phase == 0)
            AnimatedBuilder(
              animation: Listenable.merge([_shakeAnim, _envelopeFade]),
              builder: (_, __) => Opacity(
                opacity: _envelopeFade.value,
                child: Transform.translate(
                  offset: Offset(_shakeAnim.value, 0),
                  child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      AnimatedBuilder(
                        animation: _glowAnim,
                        builder: (_, __) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: _themeColor.withOpacity(0.4), blurRadius: 40),
                              BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 20),
                            ],
                          ),
                          child: const OwlLogo(size: 200),
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        widget.data['title'] ?? '',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: Colors.white, fontStyle: FontStyle.italic),
                      ),
                      const SizedBox(height: 16),
                      _PulsingHint(color: _themeColor),
                    ]),
                  ),
                ),
              ),
            ),

          // FASE 1 — Conteúdo
          if (_phase == 1)
            FadeTransition(
              opacity: _contentFade,
              child: _buildContent(),
            ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final message = widget.data['message'] ?? '';
    final title = widget.data['title'] ?? '';
    final publishAfterReview = widget.data['publishAfterReview'] ?? false;
    final createdAt = widget.data['createdAt'] != null
        ? (widget.data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    return SafeArea(
      child: Column(children: [
        // Header
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(children: [
            GestureDetector(
              onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: Container(
                width: 38, height: 38,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.close, color: Colors.white, size: 18),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
              Text('Criada em ${createdAt.day}/${createdAt.month}/${createdAt.year}', style: GoogleFonts.dmSans(color: Colors.white38, fontSize: 12)),
            ])),
            const OwlLogo(size: 36),
          ]),
        ),

        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Papel da cápsula — igual à carta
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8D5),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 8))],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  // Barra colorida pelo tema
                  Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: _themeColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                    ),
                  ),
                  Stack(children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width - 40, 500),
                      painter: _PaperLinesPainter(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(48, 32, 24, 32),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('UMA CÁPSULA DE',
                          style: TextStyle(fontSize: 9, letterSpacing: 4, color: _themeColor.withOpacity(0.8))),
                        const SizedBox(height: 8),
                        Text(widget.data['senderName'] ?? '',
                          style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: const Color(0xFF160D04))),
                        const SizedBox(height: 4),
                        Text('para o futuro',
                          style: GoogleFonts.dmSans(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFF7A5C3A))),
                        const SizedBox(height: 20),
                        Container(width: 32, height: 1, color: _themeColor.withOpacity(0.4)),
                        const SizedBox(height: 12),
                        Text(title,
                          style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFF160D04), fontStyle: FontStyle.italic)),
                        const SizedBox(height: 20),
                        Text(message,
                          style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF241608), height: 2.0)),
                        const SizedBox(height: 32),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('— ${widget.data['senderName'] ?? ''}',
                              style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF4A2E14))),
                            const SizedBox(height: 4),
                            Text('Escrita ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                              style: TextStyle(fontSize: 9, letterSpacing: 2, color: _themeColor.withOpacity(0.5))),
                            const SizedBox(height: 16),
                            const OwlWatermarkDark(),
                          ]),
                        ),
                      ]),
                    ),
                  ]),
                ]),
              ),

              const SizedBox(height: 24),

              // Botões
              if (publishAfterReview) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _publishing ? null : _publish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _C.accent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: _publishing
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text('✦  Publicar no feed', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFEDE8E3)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Guardar só para mim', style: GoogleFonts.dmSans(fontSize: 16, color: const Color(0xFF6B6560))),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}

// Marca d'água da coruja no papel (cor escura)
class OwlWatermarkDark extends StatelessWidget {
  const OwlWatermarkDark({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22, height: 26,
      child: CustomPaint(painter: _OwlDarkPainter()),
    );
  }
}

class _OwlDarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final c = const Color(0xFF4A2E14);
    canvas.drawOval(Rect.fromLTWH(w*0.1,h*0.28,w*0.8,h*0.62), Paint()..color = c.withOpacity(0.06));
    final le = Path()..moveTo(w*0.25,h*0.28)..lineTo(w*0.20,h*0.10)..lineTo(w*0.35,h*0.22)..close();
    canvas.drawPath(le, Paint()..color = c.withOpacity(0.08));
    final re = Path()..moveTo(w*0.75,h*0.28)..lineTo(w*0.80,h*0.10)..lineTo(w*0.65,h*0.22)..close();
    canvas.drawPath(re, Paint()..color = c.withOpacity(0.08));
    for (final cx in [0.33, 0.67]) {
      final center = Offset(w*cx, h*0.36);
      final r = w*0.155;
      canvas.drawCircle(center, r, Paint()..color = c.withOpacity(0.22));
      canvas.drawCircle(center, r, Paint()..color = c.withOpacity(0.15)..style = PaintingStyle.stroke..strokeWidth = 1.0);
      canvas.drawCircle(center, r*0.45, Paint()..color = c.withOpacity(0.10));
    }
  }
  @override
  bool shouldRepaint(_) => false;
}

class _PaperLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.04)..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height),
      Paint()..color = const Color(0xFFC0392B).withOpacity(0.12)..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(_) => false;
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  _Particle({required this.velocity, required this.size, required this.color, this.life = 1.0, this.position = Offset.zero});
  void tick() {
    position = position + velocity;
    velocity = Offset(velocity.dx * 0.97, velocity.dy + 0.04);
    life -= 0.012;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset center;
  _ParticlePainter(this.particles, {required this.center});
  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final pos = center + p.position;
      final opacity = (p.life * p.life).clamp(0.0, 1.0);
      canvas.drawCircle(pos, p.size * p.life.clamp(0.0, 1.0), Paint()..color = p.color.withOpacity(opacity));
    }
  }
  @override
  bool shouldRepaint(_) => true;
}

class _PulsingHint extends StatefulWidget {
  final Color color;
  const _PulsingHint({required this.color});
  @override State<_PulsingHint> createState() => _PulsingHintState();
}
class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  late final _opacity = Tween(begin: 0.15, end: 0.6).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: Text('TOQUE PARA ABRIR',
      style: TextStyle(fontSize: 10, letterSpacing: 3.5, color: widget.color.withOpacity(0.5))),
  );
}
