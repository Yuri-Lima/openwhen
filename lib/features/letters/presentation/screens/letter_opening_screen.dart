import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import 'letter_detail_screen.dart';

class OWColors {
  static const black    = Color(0xFF080808);
  static const dark     = Color(0xFF131313);
  static const red      = Color(0xFFC0392B);
  static const redGlow  = Color(0xFFE74C3C);
  static const redDim   = Color(0xFF7B241C);
  static const cream    = Color(0xFFF2E8D5);
  static const creamDark= Color(0xFF7A5C3A);
  static const inkDark  = Color(0xFF160D04);
  static const inkMid   = Color(0xFF241608);
  static const inkLight = Color(0xFF4A2E14);
  static const gold     = Color(0xFFFFD700);
  static const pink     = Color(0xFFFF69B4);
  static const rose     = Color(0xFFFF1493);
}

// ── Particle types ──────────────────────────────────────────
enum _PType { spark, heart, petal, star, butterfly }

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  double rotation;
  double rotSpeed;
  _PType type;
  double wobble;
  double wobbleSpeed;

  _Particle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.type,
    this.life = 1.0,
    this.rotation = 0,
    this.rotSpeed = 0,
    this.wobble = 0,
    this.wobbleSpeed = 0,
  });

  void tick() {
    wobble += wobbleSpeed;
    position = Offset(
      position.dx + velocity.dx + math.sin(wobble) * 0.5,
      position.dy + velocity.dy,
    );
    if (type == _PType.heart || type == _PType.butterfly || type == _PType.petal) {
      velocity = Offset(velocity.dx * 0.98, velocity.dy + 0.02); // lighter gravity
    } else {
      velocity = Offset(velocity.dx * 0.97, velocity.dy + 0.05);
    }
    rotation += rotSpeed;
    life -= type == _PType.butterfly ? 0.006 : 0.010;
  }
}

// ════════════════════════════════════════════════════════════
class LetterOpeningScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;
  const LetterOpeningScreen({super.key, required this.data, required this.docId});

  @override
  State<LetterOpeningScreen> createState() => _LetterOpeningScreenState();
}

class _LetterOpeningScreenState extends State<LetterOpeningScreen>
    with TickerProviderStateMixin {

  // Controllers
  late AnimationController _glowCtrl;
  late AnimationController _envelopeCtrl;
  late AnimationController _flapCtrl;
  late AnimationController _burstCtrl;
  late AnimationController _paperCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _ctaCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _lightRayCtrl;

  // Animations
  late Animation<double> _glowPulse;
  late Animation<double> _envScale;
  late Animation<double> _envFade;
  late Animation<double> _flapAngle;
  late Animation<double> _burstScale;
  late Animation<double> _burstOpacity;
  late Animation<double> _lightRay;
  late Animation<double> _paperSlide;
  late Animation<double> _paperFade;
  late Animation<double> _contentFade;
  late Animation<double> _ctaFade;

  bool _started   = false;
  bool _showPaper = false;
  bool _showCta   = false;
  bool _showBurst = false;
  bool _showRays  = false;
  final List<_Particle> _particles = [];
  final _rnd = math.Random();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _initControllers();
    _initAnimations();
  }

  void _initControllers() {
    _glowCtrl      = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))..repeat(reverse: true);
    _envelopeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _flapCtrl      = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _burstCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _lightRayCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _paperCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _contentCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _ctaCtrl       = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _particleCtrl  = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _particleCtrl.addListener(() { if (mounted) setState(() => _tickParticles()); });
  }

  void _initAnimations() {
    _glowPulse    = Tween(begin: 0.08, end: 0.22).animate(_glowCtrl);
    _envScale     = Tween(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _envelopeCtrl, curve: Curves.elasticOut));
    _envFade      = CurvedAnimation(parent: _envelopeCtrl, curve: Curves.easeIn);
    _flapAngle    = Tween(begin: 0.0, end: -math.pi).animate(CurvedAnimation(parent: _flapCtrl, curve: Curves.easeInOut));
    _burstScale   = Tween(begin: 0.0, end: 3.0).animate(CurvedAnimation(parent: _burstCtrl, curve: Curves.easeOut));
    _burstOpacity = Tween(begin: 0.8, end: 0.0).animate(CurvedAnimation(parent: _burstCtrl, curve: Curves.easeIn));
    _lightRay     = CurvedAnimation(parent: _lightRayCtrl, curve: Curves.easeOut);
    _paperSlide   = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _paperCtrl, curve: Curves.easeOut));
    _paperFade    = CurvedAnimation(parent: _paperCtrl, curve: Curves.easeIn);
    _contentFade  = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn);
    _ctaFade      = CurvedAnimation(parent: _ctaCtrl, curve: Curves.easeIn);
  }

  // ── Particle spawners ────────────────────────────────────
  void _spawnBurst(Offset center) {
    // Sparks
    for (int i = 0; i < 40; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 2.0 + _rnd.nextDouble() * 5.0;
      _particles.add(_Particle(
        position: center,
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2),
        size: 2 + _rnd.nextDouble() * 3,
        color: [OWColors.red, OWColors.redGlow, OWColors.gold, Colors.white, OWColors.pink][_rnd.nextInt(5)],
        type: _PType.spark,
        rotSpeed: (_rnd.nextDouble() - 0.5) * 0.3,
      ));
    }
    // Hearts
    for (int i = 0; i < 18; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 1.5 + _rnd.nextDouble() * 3.0;
      _particles.add(_Particle(
        position: center + Offset((_rnd.nextDouble()-0.5)*40, (_rnd.nextDouble()-0.5)*40),
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 3),
        size: 8 + _rnd.nextDouble() * 12,
        color: [OWColors.pink, OWColors.rose, OWColors.red, Colors.white][_rnd.nextInt(4)],
        type: _PType.heart,
        wobbleSpeed: 0.1 + _rnd.nextDouble() * 0.15,
        life: 0.9 + _rnd.nextDouble() * 0.3,
      ));
    }
    // Petals
    for (int i = 0; i < 22; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 1.0 + _rnd.nextDouble() * 2.5;
      _particles.add(_Particle(
        position: center + Offset((_rnd.nextDouble()-0.5)*60, (_rnd.nextDouble()-0.5)*60),
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2),
        size: 6 + _rnd.nextDouble() * 10,
        color: [OWColors.pink, const Color(0xFFFFB6C1), const Color(0xFFFF85A1), Colors.white, OWColors.cream][_rnd.nextInt(5)],
        type: _PType.petal,
        rotation: _rnd.nextDouble() * math.pi * 2,
        rotSpeed: (_rnd.nextDouble() - 0.5) * 0.12,
        wobbleSpeed: 0.08 + _rnd.nextDouble() * 0.1,
        life: 1.0 + _rnd.nextDouble() * 0.4,
      ));
    }
    // Stars
    for (int i = 0; i < 25; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 2.0 + _rnd.nextDouble() * 4.0;
      _particles.add(_Particle(
        position: center + Offset((_rnd.nextDouble()-0.5)*20, (_rnd.nextDouble()-0.5)*20),
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2.5),
        size: 4 + _rnd.nextDouble() * 7,
        color: [OWColors.gold, Colors.white, OWColors.cream, const Color(0xFFFFF8DC)][_rnd.nextInt(4)],
        type: _PType.star,
        rotation: _rnd.nextDouble() * math.pi,
        rotSpeed: (_rnd.nextDouble() - 0.5) * 0.2,
      ));
    }
    // Butterflies
    for (int i = 0; i < 8; i++) {
      final angle = -math.pi/2 + (_rnd.nextDouble()-0.5) * math.pi;
      final speed = 1.0 + _rnd.nextDouble() * 2.0;
      _particles.add(_Particle(
        position: center + Offset((_rnd.nextDouble()-0.5)*80, (_rnd.nextDouble()-0.5)*40),
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 1.5),
        size: 14 + _rnd.nextDouble() * 10,
        color: [const Color(0xFFFF9ECD), const Color(0xFFFFD1DC), OWColors.pink, const Color(0xFFE8A0BF)][_rnd.nextInt(4)],
        type: _PType.butterfly,
        rotation: _rnd.nextDouble() * math.pi * 2,
        rotSpeed: (_rnd.nextDouble() - 0.5) * 0.08,
        wobbleSpeed: 0.12 + _rnd.nextDouble() * 0.1,
        life: 1.2 + _rnd.nextDouble() * 0.5,
      ));
    }
  }

  void _tickParticles() {
    for (final p in _particles) p.tick();
    _particles.removeWhere((p) => p.life <= 0);
  }

  // ── Sequence ─────────────────────────────────────────────
  Future<void> _startSequence() async {
    if (_started) return;
    setState(() => _started = true);

    // Envelope aparece
    _envelopeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));

    // Aba abre rapidamente
    _flapCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    // BURST + raios de luz
    setState(() { _showBurst = true; _showRays = true; });
    _burstCtrl.forward();
    _lightRayCtrl.forward();

    final size = MediaQuery.of(context).size;
    _spawnBurst(size.center(Offset.zero) - const Offset(0, 60));

    await Future.delayed(const Duration(milliseconds: 300));

    // Salva no Firestore
    FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(widget.docId)
        .update({'status': 'opened', 'openedAt': Timestamp.now()});

    // Papel sobe
    setState(() => _showPaper = true);
    _paperCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 900));

    // Conteúdo aparece
    _contentCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // CTA
    setState(() => _showCta = true);
    _ctaCtrl.forward();
  }

  void _goToDetail() {
    final updatedData = Map<String, dynamic>.from(widget.data);
    updatedData['status'] = 'opened';
    updatedData['openedAt'] = Timestamp.now();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => LetterDetailScreen(data: updatedData, docId: widget.docId),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _glowCtrl.dispose(); _envelopeCtrl.dispose(); _flapCtrl.dispose();
    _burstCtrl.dispose(); _lightRayCtrl.dispose(); _paperCtrl.dispose();
    _contentCtrl.dispose(); _ctaCtrl.dispose(); _particleCtrl.dispose();
    super.dispose();
  }

  // ════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final center = size.center(Offset.zero);

    return Scaffold(
      backgroundColor: OWColors.black,
      body: GestureDetector(
        onTap: _startSequence,
        child: Stack(
          alignment: Alignment.center,
          children: [

            // Glow de fundo pulsante
            AnimatedBuilder(
              animation: _glowPulse,
              builder: (_, __) => Center(
                child: Container(
                  width: size.width * 1.2, height: size.width * 1.2,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(colors: [
                      OWColors.red.withOpacity(_glowPulse.value),
                      OWColors.red.withOpacity(_glowPulse.value * 0.3),
                      Colors.transparent,
                    ]),
                  ),
                ),
              ),
            ),

            // Raios de luz irradiando
            if (_showRays)
              AnimatedBuilder(
                animation: _lightRay,
                builder: (_, __) => CustomPaint(
                  size: size,
                  painter: _LightRayPainter(_lightRay.value, center),
                ),
              ),

            // Burst circular
            if (_showBurst)
              AnimatedBuilder(
                animation: Listenable.merge([_burstScale, _burstOpacity]),
                builder: (_, __) => Center(
                  child: Opacity(
                    opacity: _burstOpacity.value,
                    child: Container(
                      width: 100 * _burstScale.value,
                      height: 100 * _burstScale.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(colors: [
                          OWColors.redGlow.withOpacity(0.9),
                          OWColors.red.withOpacity(0.4),
                          Colors.transparent,
                        ]),
                      ),
                    ),
                  ),
                ),
              ),

            // Partículas
            CustomPaint(
              size: size,
              painter: _ParticlePainter(_particles, center: center),
            ),

            // Papel emergindo
            if (_showPaper)
              AnimatedBuilder(
                animation: Listenable.merge([_paperSlide, _paperFade]),
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, size.height * 0.3 * _paperSlide.value),
                  child: FadeTransition(
                    opacity: _paperFade,
                    child: _buildPaper(size),
                  ),
                ),
              ),

            // Envelope
            if (!_showPaper || _paperSlide.value > 0.3)
              AnimatedBuilder(
                animation: Listenable.merge([_envScale, _envFade, _flapAngle]),
                builder: (_, __) => FadeTransition(
                  opacity: _envFade,
                  child: ScaleTransition(
                    scale: _envScale,
                    child: _buildEnvelope(),
                  ),
                ),
              ),

            // Hint
            if (!_started)
              Positioned(
                bottom: 60,
                child: _PulsingHint(),
              ),

            // Logo
            Positioned(
              top: MediaQuery.of(context).padding.top + 28,
              child: Text('O P E N W H E N',
                style: TextStyle(
                  fontSize: 11, letterSpacing: 7,
                  color: _started ? OWColors.red : const Color(0xFF2E1310),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),

            // CTA
            if (_showCta)
              Positioned(
                bottom: 40,
                child: FadeTransition(
                  opacity: _ctaFade,
                  child: _buildCta(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ── Envelope ─────────────────────────────────────────────
  Widget _buildEnvelope() {
    return SizedBox(
      width: 280, height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Sombra
          Positioned(
            bottom: -20, left: 20, right: 20,
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [OWColors.red.withOpacity(0.35), Colors.transparent]),
              ),
            ),
          ),
          // Corpo
          Positioned.fill(child: CustomPaint(painter: _EnvelopePainter())),
          // Aba abrindo (corrigida — abre para cima)
          Positioned(
            top: 0, left: 0, right: 0,
            child: AnimatedBuilder(
              animation: _flapAngle,
              builder: (_, __) => Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.001)
                  ..rotateX(_flapAngle.value),
                child: ClipPath(
                  clipper: _FlapClipper(),
                  child: Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF2A2A2A), Color(0xFF181818)],
                      ),
                    ),
                    child: CustomPaint(painter: _FlapLinePainter()),
                  ),
                ),
              ),
            ),
          ),
          // Lacre OW
          Positioned(
            top: 55, left: 0, right: 0,
            child: AnimatedBuilder(
              animation: _glowPulse,
              builder: (_, __) => Center(
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      colors: [Color(0xFFD04030), OWColors.redDim],
                    ),
                    boxShadow: [
                      BoxShadow(color: OWColors.red.withOpacity(0.6), blurRadius: _glowPulse.value * 80, spreadRadius: 2),
                      BoxShadow(color: OWColors.red.withOpacity(0.25), blurRadius: _glowPulse.value * 160),
                    ],
                  ),
                  child: Center(
                    child: Text('OW', style: GoogleFonts.dmSerifDisplay(fontSize: 15, color: Colors.white, fontStyle: FontStyle.italic)),
                  ),
                ),
              ),
            ),
          ),
          // Badge
          Positioned(
            top: -12, right: -12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: OWColors.red,
              child: const Text('ABERTA AGORA  ✦',
                style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  // ── Papel ────────────────────────────────────────────────
  Widget _buildPaper(Size size) {
    final maxW = math.min(size.width - 40.0, 440.0);
    final maxH = math.min(size.height - 120.0, 520.0);

    return Container(
      width: maxW, height: maxH,
      decoration: BoxDecoration(
        color: OWColors.cream,
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 48, offset: const Offset(0, 16)),
          BoxShadow(color: OWColors.red.withOpacity(0.08), blurRadius: 32),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Stack(
          children: [
            Positioned.fill(top: 48, child: CustomPaint(painter: _PaperPainter())),
            // Barra vermelha topo
            Positioned(
              top: 0, left: 0, right: 0, height: 5,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [OWColors.redDim, OWColors.red, OWColors.redGlow, OWColors.red, OWColors.redDim]),
                ),
              ),
            ),
            // Conteúdo
            FadeTransition(
              opacity: _contentFade,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(48, 44, 28, 28),
                child: _buildLetterContent(),
              ),
            ),
            // Fechar
            if (_contentFade.value > 0.5)
              Positioned(
                top: 12, right: 12,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.07)),
                    child: const Icon(Icons.close, size: 14, color: OWColors.creamDark),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterContent() {
    final d = widget.data;
    final createdAt = d['createdAt'] != null ? (d['createdAt'] as Timestamp).toDate() : DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('UMA CARTA DE', style: TextStyle(fontSize: 9, letterSpacing: 4, color: OWColors.red.withOpacity(0.8))),
        const SizedBox(height: 8),
        Text(d['senderName'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: OWColors.inkDark, height: 1.2)),
        const SizedBox(height: 4),
        Text('para ${d['receiverName'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 12, fontStyle: FontStyle.italic, color: OWColors.creamDark)),
        const SizedBox(height: 14),
        Container(width: 24, height: 1, color: OWColors.red.withOpacity(0.5)),
        const SizedBox(height: 8),
        Text(d['title'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 17, color: OWColors.inkDark, fontStyle: FontStyle.italic)),
        const SizedBox(height: 16),
        Text(d['message'] ?? '', style: GoogleFonts.dmSerifDisplay(fontSize: 15, fontStyle: FontStyle.italic, color: OWColors.inkMid, height: 2.0)),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('— ${d['senderName'] ?? ''}', style: GoogleFonts.dmSerifDisplay(fontSize: 15, fontStyle: FontStyle.italic, color: OWColors.inkLight)),
              const SizedBox(height: 4),
              Text('Escrita ${createdAt.day}/${createdAt.month}/${createdAt.year}  ·  Aberta hoje',
                style: TextStyle(fontSize: 8, letterSpacing: 2, color: OWColors.redDim.withOpacity(0.6))),
            ],
          ),
        ),
      ],
    );
  }

  // ── CTA ──────────────────────────────────────────────────
  Widget _buildCta() {
    return Column(
      children: [
        const Text('O QUE DESEJA FAZER?', style: TextStyle(fontSize: 10, letterSpacing: 3, color: Color(0xFF333333))),
        const SizedBox(height: 14),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _OWButton(
              label: '✦  PUBLICAR NO FEED',
              primary: true,
              onTap: () async {
                await FirebaseFirestore.instance
                    .collection(FirestoreCollections.letters)
                    .doc(widget.docId)
                    .update({'isPublic': true, 'publishedAt': Timestamp.now()});
                if (mounted) _goToDetail();
              },
            ),
            const SizedBox(width: 12),
            _OWButton(label: 'Guardar só para mim', primary: false, onTap: _goToDetail),
          ],
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════
//  PAINTERS
// ════════════════════════════════════════════════════════════

class _LightRayPainter extends CustomPainter {
  final double progress;
  final Offset center;
  _LightRayPainter(this.progress, this.center);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 1.5;
    final numRays = 16;
    for (int i = 0; i < numRays; i++) {
      final angle = (i / numRays) * math.pi * 2;
      final maxLen = size.longestSide * 1.2;
      final startR = 60.0;
      final endR = startR + maxLen * progress;
      final opacity = (1.0 - progress) * 0.35;
      paint.color = OWColors.red.withOpacity(opacity);
      canvas.drawLine(
        center + Offset(math.cos(angle) * startR, math.sin(angle) * startR),
        center + Offset(math.cos(angle) * endR, math.sin(angle) * endR),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_LightRayPainter old) => old.progress != progress;
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

      canvas.save();
      canvas.translate(pos.dx, pos.dy);
      canvas.rotate(p.rotation);

      switch (p.type) {
        case _PType.spark:
          canvas.drawCircle(Offset.zero, p.size * p.life, paint);
          break;
        case _PType.heart:
          _drawHeart(canvas, p.size * math.min(p.life, 1.0), paint);
          break;
        case _PType.petal:
          _drawPetal(canvas, p.size * math.min(p.life, 1.0), paint);
          break;
        case _PType.star:
          _drawStar(canvas, p.size * math.min(p.life, 1.0), paint);
          break;
        case _PType.butterfly:
          _drawButterfly(canvas, p.size * math.min(p.life, 1.0), paint);
          break;
      }

      canvas.restore();
    }
  }

  void _drawHeart(Canvas canvas, double size, Paint paint) {
    final path = Path();
    final s = size * 0.5;
    path.moveTo(0, s * 0.3);
    path.cubicTo(-s, -s * 0.2, -s * 1.8, s * 0.8, 0, s * 1.6);
    path.cubicTo(s * 1.8, s * 0.8, s, -s * 0.2, 0, s * 0.3);
    canvas.drawPath(path, paint);
  }

  void _drawPetal(Canvas canvas, double size, Paint paint) {
    final path = Path();
    path.moveTo(0, -size);
    path.cubicTo(size * 0.6, -size * 0.4, size * 0.6, size * 0.4, 0, size);
    path.cubicTo(-size * 0.6, size * 0.4, -size * 0.6, -size * 0.4, 0, -size);
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, double size, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 2 * math.pi / 5) - math.pi / 2;
      final innerAngle = outerAngle + math.pi / 5;
      final outer = Offset(math.cos(outerAngle) * size, math.sin(outerAngle) * size);
      final inner = Offset(math.cos(innerAngle) * size * 0.4, math.sin(innerAngle) * size * 0.4);
      if (i == 0) path.moveTo(outer.dx, outer.dy); else path.lineTo(outer.dx, outer.dy);
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawButterfly(Canvas canvas, double size, Paint paint) {
    final wing = Paint()..color = paint.color..style = PaintingStyle.fill;
    // Asa esquerda
    final leftWing = Path();
    leftWing.moveTo(0, 0);
    leftWing.cubicTo(-size, -size * 0.8, -size * 1.2, size * 0.2, 0, size * 0.3);
    canvas.drawPath(leftWing, wing);
    // Asa direita
    final rightWing = Path();
    rightWing.moveTo(0, 0);
    rightWing.cubicTo(size, -size * 0.8, size * 1.2, size * 0.2, 0, size * 0.3);
    canvas.drawPath(rightWing, wing);
    // Corpo
    canvas.drawOval(Rect.fromCenter(center: Offset(0, size * 0.15), width: size * 0.15, height: size * 0.5),
      Paint()..color = paint.color.withOpacity(0.8));
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(4)), Paint()..color = const Color(0xFF181818));
    // Textura diagonal
    final tex = Paint()..color = OWColors.red.withOpacity(0.025)..strokeWidth = 1;
    for (double i = -h; i < w + h; i += 20) {
      canvas.drawLine(Offset(i, 0), Offset(i + h, h), tex);
    }
    final fold = Paint()..color = const Color(0xFF222222);
    final line = Paint()..color = const Color(0xFF2A2A2A)..strokeWidth = 0.8;
    // V-folds
    canvas.drawPath(Path()..moveTo(0,h)..lineTo(w/2,h*0.52)..lineTo(w,h)..close(), fold);
    canvas.drawPath(Path()..moveTo(0,0)..lineTo(w/2,h*0.52)..lineTo(0,h)..close(), Paint()..color = const Color(0xFF1D1D1D));
    canvas.drawPath(Path()..moveTo(w,0)..lineTo(w/2,h*0.52)..lineTo(w,h)..close(), Paint()..color = const Color(0xFF1A1A1A));
    canvas.drawLine(Offset(0,0), Offset(w/2,h*0.52), line);
    canvas.drawLine(Offset(w,0), Offset(w/2,h*0.52), line);
    canvas.drawLine(Offset(0,h), Offset(w/2,h*0.52), line);
    canvas.drawLine(Offset(w,h), Offset(w/2,h*0.52), line);
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(4)),
      Paint()..color = const Color(0xFF282828)..style = PaintingStyle.stroke..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(_) => false;
}

class _FlapClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
  }
  @override
  bool shouldReclip(_) => false;
}

class _FlapLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, size.height), Offset(size.width/2, 0),
      Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 1);
    canvas.drawLine(Offset(size.width, size.height), Offset(size.width/2, 0),
      Paint()..color = Colors.white.withOpacity(0.04)..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(_) => false;
}

class _PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.035)..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Margem vermelha
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height),
      Paint()..color = OWColors.red.withOpacity(0.12)..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(_) => false;
}

// ════════════════════════════════════════════════════════════
//  HELPERS
// ════════════════════════════════════════════════════════════
class _PulsingHint extends StatefulWidget {
  @override
  State<_PulsingHint> createState() => _PulsingHintState();
}
class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);
  late final _opacity = Tween(begin: 0.2, end: 0.65).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => FadeTransition(
    opacity: _opacity,
    child: const Text('TOQUE PARA ABRIR', style: TextStyle(fontSize: 10, letterSpacing: 3.5, color: Color(0xFF2E2E2E))),
  );
}

class _OWButton extends StatefulWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _OWButton({required this.label, required this.primary, required this.onTap});
  @override State<_OWButton> createState() => _OWButtonState();
}
class _OWButtonState extends State<_OWButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTapDown:   (_) => setState(() => _pressed = true),
    onTapUp:     (_) { setState(() => _pressed = false); widget.onTap(); },
    onTapCancel: ()  => setState(() => _pressed = false),
    child: AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 100),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: widget.primary ? OWColors.red : Colors.transparent,
          border: widget.primary ? null : Border.all(color: const Color(0xFF282828)),
          boxShadow: widget.primary ? [BoxShadow(color: OWColors.red.withOpacity(0.5), blurRadius: _pressed ? 8 : 20)] : null,
        ),
        child: Text(widget.label, style: TextStyle(
          fontSize: 11, letterSpacing: widget.primary ? 2.5 : 1.0,
          color: widget.primary ? Colors.white : const Color(0xFF444444),
        )),
      ),
    ),
  );
}
