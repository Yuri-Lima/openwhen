import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import 'letter_detail_screen.dart';

class LetterOpeningScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const LetterOpeningScreen({super.key, required this.data, required this.docId});

  @override
  State<LetterOpeningScreen> createState() => _LetterOpeningScreenState();
}

class _LetterOpeningScreenState extends State<LetterOpeningScreen>
    with TickerProviderStateMixin {

  late AnimationController _glowCtrl;
  late AnimationController _scaleCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _paperCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _particleCtrl;

  late Animation<double> _glowAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _paperRise;
  late Animation<double> _envelopeFade;
  late Animation<double> _contentFade;

  bool _tapped = false;
  bool _showPaper = false;
  bool _showContent = false;
  final List<_Particle> _particles = [];
  final _rnd = math.Random();

  @override
  void initState() {
    super.initState();

    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _paperCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _particleCtrl.addListener(() { if (mounted) setState(() => _tickParticles()); });

    _glowAnim = Tween(begin: 0.08, end: 0.22).animate(_glowCtrl);
    _scaleAnim = Tween(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut));
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
    _paperRise = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _paperCtrl, curve: Curves.easeOut));
    _envelopeFade = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _paperCtrl, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)));
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn);

    // Envelope pulsa levemente
    _scaleCtrl.repeat(reverse: true);
  }

  void _spawnParticles() {
    final colors = [AppColors.accent, const Color(0xFFE74C3C), const Color(0xFFFFD700), Colors.white, const Color(0xFFFF69B4), const Color(0xFFFF85A1)];
    for (int i = 0; i < 50; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 1.5 + _rnd.nextDouble() * 4.0;
      _particles.add(_Particle(
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2.5),
        size: 2 + _rnd.nextDouble() * 6,
        color: colors[_rnd.nextInt(colors.length)],
        type: _rnd.nextInt(3),
      ));
    }
  }

  void _tickParticles() {
    for (final p in _particles) p.tick();
    _particles.removeWhere((p) => p.life <= 0);
  }

  Future<void> _onTap() async {
    if (_tapped) return;
    setState(() => _tapped = true);
    _scaleCtrl.stop();

    // Shake
    await _shakeCtrl.forward();

    // Partículas explodem
    _spawnParticles();

    // Salva no Firestore
    FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(widget.docId)
        .update({'status': 'opened', 'openedAt': Timestamp.now()});

    await Future.delayed(const Duration(milliseconds: 200));

    // Papel sobe e envelope some
    setState(() => _showPaper = true);
    _paperCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    // Conteúdo aparece
    setState(() => _showContent = true);
    _contentCtrl.forward();
  }

  void _goToDetail() {
    final updatedData = Map<String, dynamic>.from(widget.data);
    updatedData['status'] = 'opened';
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LetterDetailScreen(data: updatedData, docId: widget.docId),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _scaleCtrl.dispose();
    _shakeCtrl.dispose();
    _paperCtrl.dispose();
    _contentCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: GestureDetector(
        onTap: !_tapped ? _onTap : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glow pulsante
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, __) => Container(
                width: size.width, height: size.height,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withOpacity(_glowAnim.value),
                      AppColors.accent.withOpacity(_glowAnim.value * 0.2),
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

            // Papel saindo do envelope
            if (_showPaper)
              AnimatedBuilder(
                animation: Listenable.merge([_paperRise, _contentFade]),
                builder: (_, __) {
                  final paperH = math.min(size.height - 80.0, 540.0);
                  final paperW = math.min(size.width - 32.0, 420.0);
                  return Transform.translate(
                    offset: Offset(0, paperH * 0.4 * _paperRise.value),
                    child: Container(
                      width: paperW, height: paperH,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2E8D5),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 48, offset: const Offset(0, 20)),
                          BoxShadow(color: AppColors.accent.withOpacity(0.1), blurRadius: 32),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: [
                            // Linhas do papel
                            Positioned.fill(top: 48, child: CustomPaint(painter: _PaperPainter())),
                            // Barra vermelha topo
                            Positioned(top: 0, left: 0, right: 0, height: 5, child: Container(color: AppColors.accent)),
                            // Conteúdo
                            if (_showContent)
                              FadeTransition(
                                opacity: _contentFade,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(48, 40, 28, 28),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('UMA CARTA DE', style: TextStyle(fontSize: 9, letterSpacing: 4, color: AppColors.accent.withOpacity(0.8))),
                                      const SizedBox(height: 8),
                                      Text(widget.data['senderName'] ?? '',
                                        style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFF160D04))),
                                      const SizedBox(height: 4),
                                      Text('para ${widget.data['receiverName'] ?? ''}',
                                        style: GoogleFonts.dmSans(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFF7A5C3A))),
                                      const SizedBox(height: 16),
                                      Container(width: 24, height: 1, color: AppColors.accent.withOpacity(0.5)),
                                      const SizedBox(height: 8),
                                      Text(widget.data['title'] ?? '',
                                        style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: const Color(0xFF160D04), fontStyle: FontStyle.italic)),
                                      const SizedBox(height: 16),
                                      Text(widget.data['message'] ?? '',
                                        style: GoogleFonts.dmSerifDisplay(fontSize: 15, fontStyle: FontStyle.italic, color: const Color(0xFF241608), height: 2.0)),
                                      const SizedBox(height: 24),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text('— ${widget.data['senderName'] ?? ''}',
                                          style: GoogleFonts.dmSerifDisplay(fontSize: 15, fontStyle: FontStyle.italic, color: const Color(0xFF4A2E14))),
                                      ),
                                      const SizedBox(height: 32),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await FirebaseFirestore.instance
                                                .collection(FirestoreCollections.letters)
                                                .doc(widget.docId)
                                                .update({'isPublic': true, 'publishedAt': Timestamp.now()});
                                            if (mounted) _goToDetail();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: AppColors.accent,
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          ),
                                          child: Text('✦  Publicar no feed', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      SizedBox(
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          onPressed: _goToDetail,
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(color: Color(0xFFEDE8E3)),
                                            padding: const EdgeInsets.symmetric(vertical: 14),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                          ),
                                          child: Text('Guardar só para mim', style: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFF6B6560))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

            // Envelope (some quando papel sobe)
            if (!_showPaper || _envelopeFade.value > 0)
              AnimatedBuilder(
                animation: Listenable.merge([_shakeAnim, _scaleAnim, _envelopeFade]),
                builder: (_, __) => Opacity(
                  opacity: _showPaper ? _envelopeFade.value : 1.0,
                  child: Transform.translate(
                    offset: Offset(_tapped ? _shakeAnim.value : 0, 0),
                    child: Transform.scale(
                      scale: _tapped ? 1.0 : _scaleAnim.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Envelope simples e elegante
                          Container(
                            width: 260, height: 175,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1A1714),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white.withOpacity(0.08)),
                              boxShadow: [
                                BoxShadow(color: AppColors.accent.withOpacity(0.25), blurRadius: 40, offset: const Offset(0, 12)),
                                BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20),
                              ],
                            ),
                            child: Stack(
                              children: [
                                // Linhas do envelope
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CustomPaint(
                                    size: const Size(260, 175),
                                    painter: _EnvelopePainter(),
                                  ),
                                ),
                                // Lacre OW centralizado
                                Center(
                                  child: AnimatedBuilder(
                                    animation: _glowAnim,
                                    builder: (_, __) => Container(
                                      width: 56, height: 56,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.accent,
                                        boxShadow: [
                                          BoxShadow(color: AppColors.accent.withOpacity(0.7), blurRadius: _glowAnim.value * 50, spreadRadius: 2),
                                        ],
                                      ),
                                      child: Container(
                                        margin: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFA93226)),
                                        child: Center(
                                          child: Text('OW', style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: Colors.white, fontStyle: FontStyle.italic)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            widget.data['title'] ?? '',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: Colors.white, fontStyle: FontStyle.italic, height: 1.3),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'De ${widget.data['senderName'] ?? ''}',
                            style: GoogleFonts.dmSans(fontSize: 13, color: Colors.white.withOpacity(0.3)),
                          ),
                          const SizedBox(height: 40),
                          if (!_tapped) _PulsingHint(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            // Botão voltar
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.5)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  int type; // 0=circle, 1=heart, 2=star

  _Particle({
    required this.velocity,
    required this.size,
    required this.color,
    required this.type,
    this.life = 1.0,
    this.position = Offset.zero,
  });

  void tick() {
    position = position + velocity;
    velocity = Offset(velocity.dx * 0.97, velocity.dy + 0.05);
    life -= 0.011;
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
      final paint = Paint()..color = p.color.withOpacity(opacity);
      final s = p.size * p.life;

      if (p.type == 1) {
        // Coração
        final path = Path();
        path.moveTo(pos.dx, pos.dy + s * 0.3);
        path.cubicTo(pos.dx - s, pos.dy - s * 0.2, pos.dx - s * 1.8, pos.dy + s * 0.8, pos.dx, pos.dy + s * 1.6);
        path.cubicTo(pos.dx + s * 1.8, pos.dy + s * 0.8, pos.dx + s, pos.dy - s * 0.2, pos.dx, pos.dy + s * 0.3);
        canvas.drawPath(path, paint);
      } else if (p.type == 2) {
        // Estrela
        final path = Path();
        for (int i = 0; i < 5; i++) {
          final outerA = (i * 2 * math.pi / 5) - math.pi / 2;
          final innerA = outerA + math.pi / 5;
          final outer = Offset(pos.dx + math.cos(outerA) * s, pos.dy + math.sin(outerA) * s);
          final inner = Offset(pos.dx + math.cos(innerA) * s * 0.4, pos.dy + math.sin(innerA) * s * 0.4);
          if (i == 0) path.moveTo(outer.dx, outer.dy); else path.lineTo(outer.dx, outer.dy);
          path.lineTo(inner.dx, inner.dy);
        }
        path.close();
        canvas.drawPath(path, paint);
      } else {
        canvas.drawCircle(pos, s, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final line = Paint()..color = Colors.white.withOpacity(0.06)..strokeWidth = 1;
    final fold = Paint()..color = Colors.white.withOpacity(0.03)..style = PaintingStyle.fill;

    // V inferior
    canvas.drawPath(Path()..moveTo(0,h)..lineTo(w/2,h*0.52)..lineTo(w,h)..close(), fold);
    // V esquerdo
    canvas.drawPath(Path()..moveTo(0,0)..lineTo(w/2,h*0.52)..lineTo(0,h)..close(), Paint()..color = Colors.white.withOpacity(0.02));
    // V direito
    canvas.drawPath(Path()..moveTo(w,0)..lineTo(w/2,h*0.52)..lineTo(w,h)..close(), Paint()..color = Colors.white.withOpacity(0.015));

    // Linhas de dobra
    canvas.drawLine(Offset(0,0), Offset(w/2,h*0.52), line);
    canvas.drawLine(Offset(w,0), Offset(w/2,h*0.52), line);
    canvas.drawLine(Offset(0,h), Offset(w/2,h*0.52), line);
    canvas.drawLine(Offset(w,h), Offset(w/2,h*0.52), line);

    // V superior (aba fechada)
    canvas.drawPath(
      Path()..moveTo(0,0)..lineTo(w/2, h*0.48)..lineTo(w,0)..close(),
      Paint()..color = const Color(0xFF221E1A),
    );
    canvas.drawLine(Offset(0,0), Offset(w/2,h*0.48), line);
    canvas.drawLine(Offset(w,0), Offset(w/2,h*0.48), line);
  }
  @override bool shouldRepaint(_) => false;
}

class _PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()..color = Colors.black.withOpacity(0.04)..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height),
      Paint()..color = const Color(0xFFC0392B).withOpacity(0.12)..strokeWidth = 1);
  }
  @override bool shouldRepaint(_) => false;
}

class _PulsingHint extends StatefulWidget {
  @override State<_PulsingHint> createState() => _PulsingHintState();
}
class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  late final _opacity = Tween(begin: 0.15, end: 0.55).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: const Text('TOQUE PARA ABRIR', style: TextStyle(fontSize: 10, letterSpacing: 3.5, color: Color(0xFF4E4E4E))),
  );
}
