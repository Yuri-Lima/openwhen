import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import 'capsule_detail_screen.dart';

class _CapsuleThemeVisual {
  final List<Color> particleColors;
  final List<Color> glowColors;

  const _CapsuleThemeVisual({
    required this.particleColors,
    required this.glowColors,
  });
}

const Map<String, _CapsuleThemeVisual> _capsuleThemeVisuals = {
  'memories': _CapsuleThemeVisual(
    particleColors: [Color(0xFF6B6560), Color(0xFFA8A29E), Color(0xFFD6D3D1), Colors.white, Color(0xFF57534E)],
    glowColors: [Color(0xFF6B6560), Color(0xFF78716C)],
  ),
  'goals': _CapsuleThemeVisual(
    particleColors: [Color(0xFFC0392B), Color(0xFFE11D48), Color(0xFFF97316), Colors.white, Color(0xFF991B1B)],
    glowColors: [Color(0xFFC0392B), Color(0xFFE11D48)],
  ),
  'feelings': _CapsuleThemeVisual(
    particleColors: [Color(0xFFC9A84C), Color(0xFFFBBF24), Color(0xFFFDE68A), Colors.white, Color(0xFFB45309)],
    glowColors: [Color(0xFFC9A84C), Color(0xFFF59E0B)],
  ),
  'relationships': _CapsuleThemeVisual(
    particleColors: [Color(0xFF5B8DB8), Color(0xFF60A5FA), Color(0xFF93C5FD), Colors.white, Color(0xFF1D4ED8)],
    glowColors: [Color(0xFF5B8DB8), Color(0xFF3B82F6)],
  ),
  'growth': _CapsuleThemeVisual(
    particleColors: [Color(0xFF4A8C6F), Color(0xFF34D399), Color(0xFF6EE7B7), Colors.white, Color(0xFF047857)],
    glowColors: [Color(0xFF4A8C6F), Color(0xFF10B981)],
  ),
};

String _getOpenText(String? themeId, AppLocalizations l10n) {
  switch (themeId) {
    case 'memories':      return l10n.capsuleOpeningThemeMemories;
    case 'goals':         return l10n.capsuleOpeningThemeGoals;
    case 'feelings':      return l10n.capsuleOpeningThemeFeelings;
    case 'relationships': return l10n.capsuleOpeningThemeRelationships;
    case 'growth':        return l10n.capsuleOpeningThemeGrowth;
    default:              return l10n.capsuleOpeningThemeMemories;
  }
}

_CapsuleThemeVisual _visualForTheme(String? themeId) {
  return _capsuleThemeVisuals[themeId] ?? _capsuleThemeVisuals['memories']!;
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;

  _Particle({
    required this.velocity,
    required this.size,
    required this.color,
    this.life = 1.0,
    this.position = Offset.zero,
  });

  void tick() {
    position = position + velocity;
    velocity = Offset(velocity.dx * 0.97, velocity.dy + 0.04);
    life -= 0.01;
  }
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
  late AnimationController _glowCtrl;
  late AnimationController _scaleCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _revealCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _particleCtrl;

  late Animation<double> _glowAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _shakeAnim;
  late Animation<double> _capsuleFade;
  late Animation<double> _contentFade;

  bool _tapped = false;
  bool _showReveal = false;
  bool _showContent = false;
  final List<_Particle> _particles = [];
  final _rnd = math.Random();

  late _CapsuleThemeVisual _visual;

  List<Map<String, String>> get _qaPairs {
    final raw = widget.data['questions'];
    if (raw is! List) return [];
    final out = <Map<String, String>>[];
    for (final item in raw) {
      if (item is Map) {
        final q = item['question']?.toString() ?? '';
        final a = item['answer']?.toString() ?? '';
        out.add({'question': q, 'answer': a});
      }
    }
    return out;
  }

  bool get _publishAfterReview => widget.data['publishAfterReview'] == true;

  @override
  void initState() {
    super.initState();
    final themeId = widget.data['theme'] as String?;
    _visual = _visualForTheme(themeId);

    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _revealCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _particleCtrl.addListener(() {
      if (mounted) setState(() => _tickParticles());
    });

    _glowAnim = Tween(begin: 0.08, end: 0.22).animate(_glowCtrl);
    _scaleAnim = Tween(begin: 1.0, end: 1.06).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -10.0, end: 10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -7.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -7.0, end: 7.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 7.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
    _capsuleFade = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _revealCtrl, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)));
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn);
  }

  void _spawnParticles() {
    final colors = _visual.particleColors;
    for (int i = 0; i < 60; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 1.5 + _rnd.nextDouble() * 4.0;
      _particles.add(_Particle(
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2.2),
        size: 3 + _rnd.nextDouble() * 6,
        color: colors[_rnd.nextInt(colors.length)],
        life: 0.8 + _rnd.nextDouble() * 0.5,
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

    await _shakeCtrl.forward();
    _spawnParticles();

    await FirebaseFirestore.instance
        .collection(FirestoreCollections.capsules)
        .doc(widget.docId)
        .update({'status': 'opened', 'openedAt': Timestamp.now()});

    await Future.delayed(const Duration(milliseconds: 180));

    setState(() => _showReveal = true);
    _revealCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() => _showContent = true);
    _contentCtrl.forward();
  }

  void _goToDetail({bool publish = false}) {
    final updated = Map<String, dynamic>.from(widget.data);
    updated['status'] = 'opened';
    updated['openedAt'] = Timestamp.now();
    if (publish) {
      updated['isPublic'] = true;
      updated['publishedAt'] = Timestamp.now();
    }
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => CapsuleDetailScreen(data: updated, docId: widget.docId),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  Future<void> _publishAndGo() async {
    await FirebaseFirestore.instance.collection(FirestoreCollections.capsules).doc(widget.docId).update({
      'isPublic': true,
      'publishedAt': Timestamp.now(),
    });
    if (mounted) _goToDetail(publish: true);
  }

  @override
  void dispose() {
    _glowCtrl.dispose();
    _scaleCtrl.dispose();
    _shakeCtrl.dispose();
    _revealCtrl.dispose();
    _contentCtrl.dispose();
    _particleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final glowColor = _visual.glowColors[0];
    final title = widget.data['title'] as String? ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: GestureDetector(
        onTap: !_tapped ? _onTap : null,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _glowAnim,
              builder: (_, __) => Container(
                width: size.width,
                height: size.height,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      glowColor.withOpacity(_glowAnim.value),
                      glowColor.withOpacity(_glowAnim.value * 0.2),
                      Colors.transparent,
                    ],
                    radius: 0.75,
                  ),
                ),
              ),
            ),

            CustomPaint(
              size: size,
              painter: _ParticlePainter(_particles, center: size.center(Offset.zero)),
            ),

            if (_showReveal && _showContent)
              Positioned.fill(
                child: FadeTransition(
                  opacity: _contentFade,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 56, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.capsuleOpeningHeader,
                          style: TextStyle(
                            fontSize: 9,
                            letterSpacing: 4,
                            color: glowColor.withOpacity(0.85),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 22,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ...List.generate(_qaPairs.length, (i) {
                          final qa = _qaPairs[i];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 400 + i * 120),
                            curve: Curves.easeOutCubic,
                            builder: (context, t, child) {
                              return Opacity(
                                opacity: t,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1 - t)),
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(bottom: 14),
                              padding: const EdgeInsets.all(18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF141210),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.08)),
                                boxShadow: [
                                  BoxShadow(
                                    color: glowColor.withOpacity(0.12),
                                    blurRadius: 24,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    qa['question'] ?? '',
                                    style: GoogleFonts.dmSans(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.45),
                                      fontWeight: FontWeight.w500,
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    qa['answer'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 16,
                                      color: const Color(0xFFF5F0E8),
                                      fontStyle: FontStyle.italic,
                                      height: 1.55,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 24),
                        if (_publishAfterReview) ...[
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _publishAndGo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: context.pal.accent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              child: Text(
                                l10n.capsuleOpeningPublishFeed,
                                style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: () => _goToDetail(publish: false),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white.withOpacity(0.2)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              l10n.capsuleOpeningKeepPrivate,
                              style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withOpacity(0.75)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            AnimatedBuilder(
              animation: Listenable.merge([_shakeAnim, _scaleAnim, _revealCtrl, _glowCtrl]),
              builder: (_, __) {
                if (_showReveal && _capsuleFade.value <= 0.01) {
                  return const SizedBox.shrink();
                }
                final fade = _showReveal ? _capsuleFade.value : 1.0;
                return Opacity(
                  opacity: fade,
                  child: Transform.translate(
                    offset: Offset(_tapped ? _shakeAnim.value : 0, 0),
                    child: Transform.scale(
                      scale: _tapped ? 1.0 : _scaleAnim.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _SealedCapsuleVisual(glowColor: glowColor, glowPulse: _glowAnim.value),
                          const SizedBox(height: 28),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.dmSerifDisplay(
                              fontSize: 20,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color: glowColor.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: glowColor.withOpacity(0.35)),
                            ),
                            child: Text(
                              _getOpenText(widget.data['theme'] as String?, l10n),
                              style: GoogleFonts.dmSans(fontSize: 11, color: glowColor, fontWeight: FontWeight.w500),
                            ),
                          ),
                          const SizedBox(height: 28),
                          if (!_tapped) _PulsingHint(color: glowColor, text: l10n.capsuleOpeningTapToOpen),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              left: 24,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
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

class _SealedCapsuleVisual extends StatelessWidget {
  final Color glowColor;
  final double glowPulse;

  const _SealedCapsuleVisual({required this.glowColor, required this.glowPulse});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: glowColor.withOpacity(0.35 + glowPulse * 0.4),
                  blurRadius: 40 + glowPulse * 20,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(200, 220),
            painter: _CapsuleJarPainter(accent: glowColor),
          ),
        ],
      ),
    );
  }
}

class _CapsuleJarPainter extends CustomPainter {
  final Color accent;

  _CapsuleJarPainter({required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final body = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, h * 0.55), width: w * 0.52, height: h * 0.42),
      const Radius.circular(18),
    );
    final neck = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(cx, h * 0.22), width: w * 0.28, height: h * 0.14),
      const Radius.circular(8),
    );

    final glass = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF2A2622).withOpacity(0.95),
          const Color(0xFF1A1714),
          const Color(0xFF0D0C0B),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h));

    canvas.drawRRect(neck, glass);
    canvas.drawRRect(body, glass);

    final rim = Paint()
      ..color = accent.withOpacity(0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    final neckOuter = RRect.fromRectAndRadius(
      neck.outerRect.inflate(2),
      const Radius.circular(10),
    );
    canvas.drawRRect(neckOuter, rim);

    final seal = Paint()..color = accent;
    canvas.drawCircle(Offset(cx, h * 0.22), 10, seal);
    canvas.drawCircle(Offset(cx, h * 0.22), 5, Paint()..color = Colors.white.withOpacity(0.35));

    final sand = Paint()..color = accent.withOpacity(0.35);
    final path = Path()
      ..moveTo(cx - w * 0.18, h * 0.62)
      ..quadraticBezierTo(cx, h * 0.72, cx + w * 0.18, h * 0.62)
      ..lineTo(cx + w * 0.22, h * 0.78)
      ..lineTo(cx - w * 0.22, h * 0.78)
      ..close();
    canvas.drawPath(path, sand);

    final highlight = Paint()..color = Colors.white.withOpacity(0.06);
    canvas.drawCircle(Offset(cx - w * 0.12, h * 0.48), 16, highlight);
  }

  @override
  bool shouldRepaint(covariant _CapsuleJarPainter oldDelegate) => oldDelegate.accent != accent;
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
      final s = p.size * math.min(p.life, 1.0);
      canvas.drawCircle(pos, s, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

class _PulsingHint extends StatefulWidget {
  final Color color;
  final String text;

  const _PulsingHint({required this.color, required this.text});

  @override
  State<_PulsingHint> createState() => _PulsingHintState();
}

class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  late final Animation<double> _opacity = Tween(begin: 0.15, end: 0.55).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Text(
        widget.text,
        style: TextStyle(fontSize: 10, letterSpacing: 3.5, color: widget.color.withOpacity(0.55)),
      ),
    );
  }
}
