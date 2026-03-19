// ============================================================
//  OpenWhen — Letter Opening Animation
// ============================================================

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import 'letter_detail_screen.dart';

class OWColors {
  static const black     = Color(0xFF080808);
  static const dark      = Color(0xFF131313);
  static const envelope  = Color(0xFF181818);
  static const foldLine  = Color(0xFF262626);
  static const red       = Color(0xFFC0392B);
  static const redGlow   = Color(0xFFE74C3C);
  static const redDim    = Color(0xFF7B241C);
  static const cream     = Color(0xFFF2E8D5);
  static const creamDark = Color(0xFF7A5C3A);
  static const inkDark   = Color(0xFF160D04);
  static const inkMid    = Color(0xFF241608);
  static const inkLight  = Color(0xFF4A2E14);
}

class LetterOpeningScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String docId;

  const LetterOpeningScreen({super.key, required this.data, required this.docId});

  @override
  State<LetterOpeningScreen> createState() => _LetterOpeningScreenState();
}

class _LetterOpeningScreenState extends State<LetterOpeningScreen>
    with TickerProviderStateMixin {

  late AnimationController _shakeCtrl;
  late AnimationController _flapCtrl;
  late AnimationController _envFadeCtrl;
  late AnimationController _paperCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _ctaCtrl;
  late AnimationController _washCtrl;
  late AnimationController _sealGlowCtrl;
  late AnimationController _particleCtrl;

  late Animation<double> _shakeAnim;
  late Animation<double> _flapAngle;
  late Animation<double> _envOpacity;
  late Animation<double> _paperScale;
  late Animation<double> _paperHeight;
  late Animation<double> _paperPerspective;
  late Animation<double> _contentOpacity;
  late Animation<double> _ctaOpacity;
  late Animation<double> _washOpacity;
  late Animation<double> _sealGlow;

  bool _started   = false;
  bool _showPaper = false;
  bool _showCta   = false;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    _buildControllers();
    _buildAnimations();
  }

  void _buildControllers() {
    _shakeCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 750));
    _flapCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 4400));
    _envFadeCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _paperCtrl    = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));
    _contentCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _ctaCtrl      = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _washCtrl     = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _sealGlowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _particleCtrl.addListener(() => setState(() => _tickParticles()));
  }

  void _buildAnimations() {
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0,  end: -8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 6.0),  weight: 20),
      TweenSequenceItem(tween: Tween(begin: 6.0,  end: -5.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -5.0, end: 3.0),  weight: 20),
      TweenSequenceItem(tween: Tween(begin: 3.0,  end: 0.0),  weight: 20),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    _flapAngle = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -22.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 32),
      TweenSequenceItem(tween: Tween(begin: -22.0, end: -100.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 29),
      TweenSequenceItem(tween: Tween(begin: -100.0, end: -182.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 39),
    ]).animate(_flapCtrl);

    _envOpacity      = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _envFadeCtrl, curve: Curves.easeIn));
    _paperScale      = Tween(begin: 0.08, end: 1.0).animate(CurvedAnimation(parent: _paperCtrl, curve: Curves.easeOut));
    _paperHeight     = Tween(begin: 0.1, end: 1.0).animate(CurvedAnimation(parent: _paperCtrl, curve: Curves.easeOut));
    _paperPerspective= Tween(begin: 30.0, end: 0.0).animate(CurvedAnimation(parent: _paperCtrl, curve: Curves.easeOut));
    _contentOpacity  = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn);
    _ctaOpacity      = CurvedAnimation(parent: _ctaCtrl, curve: Curves.easeIn);
    _washOpacity     = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 70),
    ]).animate(_washCtrl);
    _sealGlow = Tween(begin: 4.0, end: 16.0).animate(CurvedAnimation(parent: _sealGlowCtrl, curve: Curves.easeInOut));
  }

  void _spawnBurst(Offset pos, int count, {double speed = 1.0}) {
    final rnd = math.Random();
    final colors = [OWColors.red, OWColors.redGlow, OWColors.cream, Colors.white, OWColors.redDim];
    for (int i = 0; i < count; i++) {
      final angle = rnd.nextDouble() * math.pi * 2;
      final s = (1.0 + rnd.nextDouble() * 3.5) * speed;
      _particles.add(_Particle(
        position: pos,
        velocity: Offset(math.cos(angle) * s, math.sin(angle) * s - speed),
        size: 1.5 + rnd.nextDouble() * 3,
        color: colors[rnd.nextInt(colors.length)],
      ));
    }
  }

  void _tickParticles() {
    for (final p in _particles) p.tick();
    _particles.removeWhere((p) => p.life <= 0);
  }

  Future<void> _startSequence() async {
    if (_started) return;
    setState(() => _started = true);

    await _shakeCtrl.forward();
    _spawnBurst(const Offset(0, -40), 8, speed: 0.8);
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 900));

    _flapCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1400));
    await Future.delayed(const Duration(milliseconds: 600));
    await Future.delayed(const Duration(milliseconds: 1300));
    await Future.delayed(const Duration(milliseconds: 500));
    await Future.delayed(const Duration(milliseconds: 1700));

    _spawnBurst(Offset.zero, 55, speed: 1.1);
    Future.delayed(const Duration(milliseconds: 200), () {
      _spawnBurst(Offset.zero, 25, speed: 0.9);
    });
    _washCtrl.forward();
    _sealGlowCtrl.stop();

    await Future.delayed(const Duration(milliseconds: 400));
    _envFadeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 800));

    // Salva no Firestore
    await FirebaseFirestore.instance
        .collection(FirestoreCollections.letters)
        .doc(widget.docId)
        .update({'status': 'opened', 'openedAt': Timestamp.now()});

    setState(() => _showPaper = true);
    _paperCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2600));

    _contentCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1200));

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
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    _flapCtrl.dispose();
    _envFadeCtrl.dispose();
    _paperCtrl.dispose();
    _contentCtrl.dispose();
    _ctaCtrl.dispose();
    _washCtrl.dispose();
    _sealGlowCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: OWColors.black,
      body: GestureDetector(
        onTap: _startSequence,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(bottom: 0, child: _RedGlow(size: size)),
            CustomPaint(
              size: size,
              painter: _ParticlePainter(_particles, center: size.center(Offset.zero)),
            ),
            AnimatedBuilder(
              animation: _washOpacity,
              builder: (_, __) => Opacity(
                opacity: _washOpacity.value,
                child: Container(
                  width: size.width, height: size.height,
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      colors: [Color(0x1DC0392B), Colors.transparent],
                      radius: 1.2,
                    ),
                  ),
                ),
              ),
            ),
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
            if (_showPaper) _buildPaperScene(size),
            AnimatedBuilder(
              animation: _envOpacity,
              builder: (_, child) => Opacity(opacity: _envOpacity.value, child: child),
              child: AnimatedBuilder(
                animation: _shakeAnim,
                builder: (_, child) => Transform.translate(offset: Offset(_shakeAnim.value, 0), child: child),
                child: _buildEnvelope(),
              ),
            ),
            if (!_started) Positioned(bottom: 48, child: _PulsingHint()),
            if (_showCta)
              Positioned(
                bottom: 40,
                child: AnimatedBuilder(
                  animation: _ctaOpacity,
                  builder: (_, child) => Opacity(opacity: _ctaOpacity.value, child: child),
                  child: _buildCta(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnvelope() {
    return SizedBox(
      width: 300, height: 200,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -18, left: 30, right: 30,
            child: Container(
              height: 20,
              decoration: BoxDecoration(
                gradient: RadialGradient(colors: [OWColors.red.withOpacity(0.25), Colors.transparent]),
              ),
            ),
          ),
          Positioned.fill(child: CustomPaint(painter: _EnvelopeBodyPainter())),
          AnimatedBuilder(
            animation: _flapAngle,
            builder: (_, __) {
              final angle = _flapAngle.value * math.pi / 180;
              return Transform(
                alignment: Alignment.topCenter,
                transform: Matrix4.identity()..setEntry(3, 2, 0.0012)..rotateX(angle),
                child: SizedBox(
                  width: 302, height: 120,
                  child: CustomPaint(painter: _FlapPainter()),
                ),
              );
            },
          ),
          Positioned(
            top: 38, left: 0, right: 0,
            child: AnimatedBuilder(
              animation: _sealGlow,
              builder: (_, __) => Center(
                child: Container(
                  width: 42, height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      center: Alignment(-0.3, -0.4),
                      colors: [Color(0xFFD04030), OWColors.redDim],
                    ),
                    boxShadow: [
                      BoxShadow(color: OWColors.red.withOpacity(0.55), blurRadius: _sealGlow.value, spreadRadius: 1),
                      BoxShadow(color: OWColors.red.withOpacity(0.2), blurRadius: _sealGlow.value * 2.5),
                    ],
                  ),
                  child: Center(
                    child: Text('OW', style: GoogleFonts.dmSerifDisplay(fontSize: 14, color: Colors.white, fontStyle: FontStyle.italic)),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: -14, right: -14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: OWColors.red,
                boxShadow: [BoxShadow(color: OWColors.red.withOpacity(0.5), blurRadius: 10)],
              ),
              child: const Text('ABERTA AGORA  ✦',
                style: TextStyle(fontSize: 9, letterSpacing: 1.5, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaperScene(Size size) {
    final maxW = math.min(size.width - 48, 480.0);
    final maxH = math.min(size.height - 80, 560.0);

    return AnimatedBuilder(
      animation: Listenable.merge([_paperScale, _paperPerspective, _contentOpacity]),
      builder: (_, __) {
        final w = maxW * _paperScale.value;
        final h = maxH * _paperHeight.value;
        final perspAngle = _paperPerspective.value * math.pi / 180;

        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()..setEntry(3, 2, 0.001)..rotateX(perspAngle),
          child: Container(
            width: w, height: h,
            decoration: BoxDecoration(
              color: OWColors.cream,
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.3 + 0.4 * _paperScale.value), blurRadius: 40 * _paperScale.value, offset: Offset(0, 8 * _paperScale.value)),
                BoxShadow(color: OWColors.red.withOpacity(0.05 * _paperScale.value), blurRadius: 20 * _paperScale.value),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Stack(
                children: [
                  Positioned.fill(top: 40, child: CustomPaint(painter: _PaperLinesPainter())),
                  Positioned.fill(child: CustomPaint(painter: _FoldCreasesPainter())),
                  Positioned(
                    top: 0, left: 0, right: 0, height: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [OWColors.redDim, OWColors.red, OWColors.redGlow, OWColors.red, OWColors.redDim],
                        ),
                      ),
                    ),
                  ),
                  Opacity(opacity: _contentOpacity.value, child: _buildLetterContent()),
                  if (_contentOpacity.value > 0.5)
                    Positioned(
                      top: 12, right: 12,
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          width: 32, height: 32,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black.withOpacity(0.08)),
                          child: const Icon(Icons.close, size: 16, color: OWColors.creamDark),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLetterContent() {
    final data = widget.data;
    final sender = data['senderName'] ?? '';
    final receiver = data['receiverName'] ?? '';
    final body = data['message'] ?? '';
    final title = data['title'] ?? '';
    final createdAt = data['createdAt'] != null ? (data['createdAt'] as Timestamp).toDate() : DateTime.now();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('UMA CARTA DE',
            style: TextStyle(fontSize: 9, letterSpacing: 4, color: OWColors.red.withOpacity(0.8))),
          const SizedBox(height: 10),
          Text(sender, style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: OWColors.inkDark, height: 1.2)),
          const SizedBox(height: 4),
          Text('para $receiver',
            style: GoogleFonts.dmSans(fontSize: 13, fontStyle: FontStyle.italic, color: OWColors.creamDark)),
          const SizedBox(height: 16),
          Container(width: 28, height: 1, color: OWColors.red.withOpacity(0.45)),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: OWColors.inkDark, fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          Text(body,
            style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: OWColors.inkMid, height: 1.9)),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerRight,
            child: Text('— $sender',
              style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: OWColors.inkLight)),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Escrita ${createdAt.day}/${createdAt.month}/${createdAt.year}  ·  Aberta hoje',
              style: TextStyle(fontSize: 9, letterSpacing: 2, color: OWColors.redDim.withOpacity(0.7))),
          ),
        ],
      ),
    );
  }

  Widget _buildCta() {
    return Column(
      children: [
        const Text('O QUE DESEJA FAZER?',
          style: TextStyle(fontSize: 10, letterSpacing: 3, color: Color(0xFF333333))),
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
            _OWButton(
              label: 'Guardar só para mim',
              primary: false,
              onTap: _goToDetail,
            ),
          ],
        ),
      ],
    );
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;

  _Particle({required this.position, required this.velocity, required this.size, required this.color, this.life = 1.0});

  void tick() {
    position = position + velocity;
    velocity = velocity + const Offset(0, 0.06);
    life -= 0.014;
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final Offset center;
  const _ParticlePainter(this.particles, {required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      canvas.drawCircle(center + p.position, p.size * p.life, Paint()..color = p.color.withOpacity(p.life * p.life));
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _EnvelopeBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(3)), Paint()..color = OWColors.dark);

    final texPaint = Paint()..color = OWColors.red.withOpacity(0.022)..strokeWidth = 1;
    for (double i = -h; i < w + h; i += 22) {
      canvas.drawLine(Offset(i, 0), Offset(i + h, h), texPaint);
    }

    final foldPaint  = Paint()..color = const Color(0xFF1D1D1D);
    final foldPaint2 = Paint()..color = const Color(0xFF181818);
    final foldLine   = Paint()..color = OWColors.foldLine..strokeWidth = 1;

    canvas.drawPath(Path()..moveTo(0, h)..lineTo(w/2, h*0.5)..lineTo(w, h)..close(), foldPaint);
    canvas.drawPath(Path()..moveTo(0, 0)..lineTo(w*0.5, h*0.5)..lineTo(0, h)..close(), foldPaint);
    canvas.drawPath(Path()..moveTo(w, 0)..lineTo(w*0.5, h*0.5)..lineTo(w, h)..close(), foldPaint2);

    canvas.drawLine(Offset(0, 0), Offset(w*0.5, h*0.5), foldLine);
    canvas.drawLine(Offset(w, 0), Offset(w*0.5, h*0.5), foldLine);
    canvas.drawLine(Offset(0, h), Offset(w*0.5, h*0.5), foldLine);
    canvas.drawLine(Offset(w, h), Offset(w*0.5, h*0.5), foldLine);

    canvas.drawRRect(RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(3)),
      Paint()..color = const Color(0xFF252525)..style = PaintingStyle.stroke..strokeWidth = 1);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FlapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final path = Path()..moveTo(w*0.5, 0)..lineTo(0, h*0.52)..lineTo(w, h*0.52)..close();
    canvas.drawPath(path, Paint()..shader = const LinearGradient(
      begin: Alignment.topCenter, end: Alignment.bottomCenter,
      colors: [Color(0xFF232323), Color(0xFF181818)],
    ).createShader(Offset.zero & size));
    canvas.drawLine(Offset(0, h*0.52), Offset(w, h*0.52),
      Paint()..color = const Color(0xFF2D2D2D)..strokeWidth = 1);
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
  }

  @override
  bool shouldRepaint(_) => false;
}

class _FoldCreasesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.06)..strokeWidth = 0.8;
    canvas.drawLine(Offset(0, size.height*0.5), Offset(size.width, size.height*0.5), paint);
    canvas.drawLine(Offset(size.width*0.5, 0), Offset(size.width*0.5, size.height), paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _RedGlow extends StatelessWidget {
  final Size size;
  const _RedGlow({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.9, height: 200,
      decoration: const BoxDecoration(
        gradient: RadialGradient(colors: [Color(0x1EC0392B), Colors.transparent], radius: 0.8),
      ),
    );
  }
}

class _PulsingHint extends StatefulWidget {
  @override
  State<_PulsingHint> createState() => _PulsingHintState();
}

class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 2500))..repeat(reverse: true);
  late final Animation<double> _opacity = Tween(begin: 0.25, end: 0.7).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: const Text('TOQUE PARA ABRIR',
        style: TextStyle(fontSize: 10, letterSpacing: 3.5, color: Color(0xFF2E2E2E))),
    );
  }
}

class _OWButton extends StatefulWidget {
  final String label;
  final bool primary;
  final VoidCallback onTap;
  const _OWButton({required this.label, required this.primary, required this.onTap});

  @override
  State<_OWButton> createState() => _OWButtonState();
}

class _OWButtonState extends State<_OWButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown:   (_) => setState(() => _pressed = true),
      onTapUp:     (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: ()  => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: widget.primary ? OWColors.red : Colors.transparent,
            border: widget.primary ? null : Border.all(color: const Color(0xFF282828)),
            boxShadow: widget.primary ? [BoxShadow(color: OWColors.red.withOpacity(0.45), blurRadius: _pressed ? 10 : 20)] : null,
          ),
          child: Text(widget.label,
            style: TextStyle(
              fontSize: 12,
              letterSpacing: widget.primary ? 2.5 : 1.0,
              color: widget.primary ? Colors.white : const Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }
}
