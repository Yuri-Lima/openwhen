import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/utils/music_url.dart';
import '../../../../shared/widgets/music_link_tile.dart';
import '../../../../shared/widgets/owl_logo.dart' show OwlSealOpeningAnimation;
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

_CapsuleThemeVisual _visualForTheme(String? themeId) {
  return _capsuleThemeVisuals[themeId] ?? _capsuleThemeVisuals['memories']!;
}

String _getOpenText(String? themeId, AppLocalizations l10n) {
  switch (themeId) {
    case 'memories':
      return l10n.capsuleOpeningThemeMemories;
    case 'goals':
      return l10n.capsuleOpeningThemeGoals;
    case 'feelings':
      return l10n.capsuleOpeningThemeFeelings;
    case 'relationships':
      return l10n.capsuleOpeningThemeRelationships;
    case 'growth':
      return l10n.capsuleOpeningThemeGrowth;
    default:
      return l10n.capsuleOpeningThemeMemories;
  }
}

class _Particle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  int type;

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
    velocity = Offset(velocity.dx * 0.97, velocity.dy + 0.04);
    life -= 0.010;
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
  late AnimationController _paperCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _particleCtrl;
  late AnimationController _sealCtrl;

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

  late _CapsuleThemeVisual _theme;

  @override
  void initState() {
    super.initState();
    _theme = _visualForTheme(widget.data['theme'] as String?);

    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _scaleCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _paperCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _contentCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _particleCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 60))..repeat();
    _particleCtrl.addListener(() {
      if (mounted) setState(() => _tickParticles());
    });
    _sealCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 5500));

    _glowAnim = Tween(begin: 0.08, end: 0.22).animate(_glowCtrl);
    _scaleAnim = Tween(begin: 1.0, end: 1.06).animate(CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut));
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -12.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -12.0, end: 12.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: 0.0), weight: 20),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));
    _paperRise = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _paperCtrl, curve: Curves.easeOut));
    _envelopeFade = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _paperCtrl, curve: const Interval(0.5, 1.0, curve: Curves.easeIn)),
    );
    _contentFade = CurvedAnimation(parent: _contentCtrl, curve: Curves.easeIn);
  }

  List<int> _particleTypesForTheme(String? themeId) {
    switch (themeId) {
      case 'memories':
        return [0, 3, 0];
      case 'goals':
        return [2, 2, 0];
      case 'feelings':
        return [1, 3, 0];
      case 'relationships':
        return [0, 2, 4];
      case 'growth':
        return [3, 0, 4];
      default:
        return [0, 1, 2];
    }
  }

  void _spawnParticles() {
    final colors = _theme.particleColors;
    final themeId = widget.data['theme'] as String? ?? 'memories';
    final particleTypes = _particleTypesForTheme(themeId);

    for (int i = 0; i < 70; i++) {
      final angle = _rnd.nextDouble() * math.pi * 2;
      final speed = 1.5 + _rnd.nextDouble() * 4.5;
      _particles.add(_Particle(
        velocity: Offset(math.cos(angle) * speed, math.sin(angle) * speed - 2.5),
        size: 3 + _rnd.nextDouble() * 7,
        color: colors[_rnd.nextInt(colors.length)],
        type: particleTypes[_rnd.nextInt(particleTypes.length)],
        life: 0.8 + _rnd.nextDouble() * 0.6,
      ));
    }
  }

  void _tickParticles() {
    for (final p in _particles) p.tick();
    _particles.removeWhere((p) => p.life <= 0);
  }

  List<Map<String, String>> _qaPairs() {
    final raw = widget.data['questions'];
    if (raw is! List) return [];
    final out = <Map<String, String>>[];
    for (final item in raw) {
      if (item is Map) {
        out.add({
          'question': item['question']?.toString() ?? '',
          'answer': item['answer']?.toString() ?? '',
        });
      }
    }
    return out;
  }

  Future<void> _onTap() async {
    if (_tapped) return;
    setState(() => _tapped = true);
    _scaleCtrl.stop();

    await _sealCtrl.forward();

    await _shakeCtrl.forward();
    _spawnParticles();

    await FirebaseFirestore.instance.collection(FirestoreCollections.capsules).doc(widget.docId).update({
      'status': 'opened',
      'openedAt': Timestamp.now(),
    });

    await Future.delayed(const Duration(milliseconds: 200));

    setState(() => _showPaper = true);
    _paperCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 800));

    setState(() => _showContent = true);
    _contentCtrl.forward();
  }

  void _goToDetail() {
    final updatedData = Map<String, dynamic>.from(widget.data);
    updatedData['status'] = 'opened';
    Navigator.pushReplacement(
      context,
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => CapsuleDetailScreen(data: updatedData, docId: widget.docId),
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
    _sealCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final glowColor = _theme.glowColors[0];
    final l10n = AppLocalizations.of(context)!;
    final openText = _getOpenText(widget.data['theme'] as String?, l10n);

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Stack(
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
                  radius: 0.7,
                ),
              ),
            ),
          ),
          CustomPaint(
            size: size,
            painter: _ParticlePainter(_particles, center: size.center(Offset.zero)),
          ),
          if (_showPaper)
            AnimatedBuilder(
              animation: Listenable.merge([_paperRise, _paperCtrl]),
              builder: (_, __) {
                final paperH = math.min(size.height - 80.0, 540.0);
                final paperW = math.min(size.width - 32.0, 420.0);
                return Transform.translate(
                  offset: Offset(0, paperH * 0.4 * _paperRise.value),
                  child: Opacity(
                    opacity: _paperCtrl.value.clamp(0.0, 1.0),
                    child: Container(
                      width: paperW,
                      height: paperH,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF2E8D5),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 48, offset: const Offset(0, 20)),
                          BoxShadow(color: glowColor.withOpacity(0.15), blurRadius: 32),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Stack(
                          children: [
                            Positioned.fill(top: 48, child: CustomPaint(painter: _PaperPainter())),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              height: 5,
                              child: Container(color: glowColor),
                            ),
                            if (_showContent)
                              FadeTransition(
                                opacity: _contentFade,
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.fromLTRB(48, 40, 28, 28),
                                  child: _buildCapsuleContent(glowColor, l10n),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
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
                        Container(
                          width: 280,
                          height: 182,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1714),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.1)),
                            boxShadow: [
                              BoxShadow(
                                color: glowColor.withOpacity(0.28),
                                blurRadius: 44,
                                offset: const Offset(0, 14),
                              ),
                              BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 22),
                            ],
                          ),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: CustomPaint(size: const Size(280, 182), painter: _EnvelopePainter()),
                              ),
                              Center(
                                child: AnimatedBuilder(
                                  animation: _glowAnim,
                                  builder: (_, __) => Container(
                                    width: 68,
                                    height: 68,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: glowColor.withOpacity(0.42),
                                          blurRadius: 28 + _glowAnim.value * 28,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: !_tapped ? _onTap : null,
                                      child: Container(
                                        width: 62,
                                        height: 62,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: glowColor.withOpacity(0.12),
                                        ),
                                        child: OwlSealOpeningAnimation(
                                          size: 52,
                                          animation: _sealCtrl,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          widget.data['title'] ?? '',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.dmSerifDisplay(
                            fontSize: 20,
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                          decoration: BoxDecoration(
                            color: glowColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: glowColor.withOpacity(0.3)),
                          ),
                          child: Text(
                            openText,
                            style: GoogleFonts.dmSans(fontSize: 11, color: glowColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(height: 32),
                        if (!_tapped) _PulsingHint(color: glowColor, text: l10n.capsuleOpeningTapToOpen),
                      ],
                    ),
                  ),
                ),
              ),
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
    );
  }

  Widget _buildCapsuleContent(Color accentColor, AppLocalizations l10n) {
    final locale = Localizations.localeOf(context).toString();
    final d = widget.data;
    final createdAt = d['createdAt'] != null ? (d['createdAt'] as Timestamp).toDate() : DateTime.now();
    final qa = _qaPairs();
    final publishAfterReview = d['publishAfterReview'] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.capsuleOpeningHeader,
          style: TextStyle(fontSize: 9, letterSpacing: 4, color: accentColor.withOpacity(0.8)),
        ),
        const SizedBox(height: 8),
        Text(
          d['title'] ?? '',
          style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFF160D04)),
        ),
        const SizedBox(height: 16),
        Container(width: 24, height: 1, color: accentColor.withOpacity(0.5)),
        const SizedBox(height: 16),
        ...List.generate(qa.length, (i) {
          final pair = qa[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pair['question'] ?? '',
                  style: GoogleFonts.dmSans(
                    fontSize: 11,
                    color: const Color(0xFF6B6560),
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  pair['answer'] ?? '',
                  style: GoogleFonts.dmSerifDisplay(
                    fontSize: 15,
                    color: const Color(0xFF241608),
                    fontStyle: FontStyle.italic,
                    height: 1.55,
                  ),
                ),
              ],
            ),
          );
        }),
        if (d['message'] != null && (d['message'] as String).trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            d['message'] as String,
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF241608),
              height: 2.0,
            ),
          ),
        ],
        if (isValidHttpsMusicUrl(d['musicUrl'] as String?)) ...[
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => launchExternalMusicUrl(context, d['musicUrl'] as String),
              icon: Icon(Icons.music_note_rounded, color: accentColor, size: 22),
              label: Text(
                l10n.musicLinkTitle,
                style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF4A2E14)),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: accentColor.withOpacity(0.55)),
                backgroundColor: accentColor.withOpacity(0.06),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
        ],
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            '— ${d['senderName'] ?? ''}',
            style: GoogleFonts.dmSerifDisplay(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: const Color(0xFF4A2E14),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            formatShortDate(createdAt, locale),
            style: TextStyle(fontSize: 8, letterSpacing: 2, color: accentColor.withOpacity(0.5)),
          ),
        ),
        const SizedBox(height: 32),
        if (publishAfterReview) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection(FirestoreCollections.capsules).doc(widget.docId).update({
                  'isPublic': true,
                  'publishedAt': Timestamp.now(),
                });
                if (mounted) _goToDetail();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
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
            onPressed: _goToDetail,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFEDE8E3)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(
              l10n.capsuleOpeningKeepPrivate,
              style: GoogleFonts.dmSans(fontSize: 14, color: const Color(0xFF6B6560)),
            ),
          ),
        ),
      ],
    );
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
      final s = p.size * math.min(p.life, 1.0);

      switch (p.type) {
        case 1:
          _drawHeart(canvas, pos, s, paint);
          break;
        case 2:
          _drawStar(canvas, pos, s, paint);
          break;
        case 3:
          _drawPetal(canvas, pos, s, paint);
          break;
        case 4:
          _drawButterfly(canvas, pos, s, paint);
          break;
        default:
          canvas.drawCircle(pos, s, paint);
      }
    }
  }

  void _drawHeart(Canvas canvas, Offset pos, double s, Paint paint) {
    final path = Path();
    path.moveTo(pos.dx, pos.dy + s * 0.3);
    path.cubicTo(pos.dx - s, pos.dy - s * 0.2, pos.dx - s * 1.8, pos.dy + s * 0.8, pos.dx, pos.dy + s * 1.6);
    path.cubicTo(pos.dx + s * 1.8, pos.dy + s * 0.8, pos.dx + s, pos.dy - s * 0.2, pos.dx, pos.dy + s * 0.3);
    canvas.drawPath(path, paint);
  }

  void _drawStar(Canvas canvas, Offset pos, double s, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final a1 = (i * 2 * math.pi / 5) - math.pi / 2;
      final a2 = a1 + math.pi / 5;
      final o = Offset(pos.dx + math.cos(a1) * s, pos.dy + math.sin(a1) * s);
      final inner = Offset(pos.dx + math.cos(a2) * s * 0.4, pos.dy + math.sin(a2) * s * 0.4);
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
      path.lineTo(inner.dx, inner.dy);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  void _drawPetal(Canvas canvas, Offset pos, double s, Paint paint) {
    final path = Path();
    path.moveTo(pos.dx, pos.dy - s);
    path.cubicTo(pos.dx + s * 0.6, pos.dy - s * 0.4, pos.dx + s * 0.6, pos.dy + s * 0.4, pos.dx, pos.dy + s);
    path.cubicTo(pos.dx - s * 0.6, pos.dy + s * 0.4, pos.dx - s * 0.6, pos.dy - s * 0.4, pos.dx, pos.dy - s);
    canvas.drawPath(path, paint);
  }

  void _drawButterfly(Canvas canvas, Offset pos, double s, Paint paint) {
    final left = Path()
      ..moveTo(pos.dx, pos.dy)
      ..cubicTo(pos.dx - s, pos.dy - s * 0.8, pos.dx - s * 1.2, pos.dy + s * 0.2, pos.dx, pos.dy + s * 0.3);
    final right = Path()
      ..moveTo(pos.dx, pos.dy)
      ..cubicTo(pos.dx + s, pos.dy - s * 0.8, pos.dx + s * 1.2, pos.dy + s * 0.2, pos.dx, pos.dy + s * 0.3);
    canvas.drawPath(left, paint);
    canvas.drawPath(right, paint);
  }

  @override
  bool shouldRepaint(_) => true;
}

class _EnvelopePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final line = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;

    final texture = Paint()
      ..color = Colors.black.withOpacity(0.07)
      ..strokeWidth = 0.35;
    for (double y = 4; y < h * 0.5; y += 4.2) {
      canvas.drawLine(Offset(6, y), Offset(w - 6, y), texture);
    }

    canvas.drawPath(
      Path()..moveTo(0, h)..lineTo(w / 2, h * 0.52)..lineTo(w, h)..close(),
      Paint()..color = const Color(0xFF2E2820),
    );
    canvas.drawPath(
      Path()..moveTo(0, 0)..lineTo(w / 2, h * 0.52)..lineTo(0, h)..close(),
      Paint()..color = const Color(0xFF2A241C),
    );
    canvas.drawPath(
      Path()..moveTo(w, 0)..lineTo(w / 2, h * 0.52)..lineTo(w, h)..close(),
      Paint()..color = const Color(0xFF262018),
    );
    canvas.drawPath(
      Path()..moveTo(0, 0)..lineTo(w / 2, h * 0.48)..lineTo(w, 0)..close(),
      Paint()..color = const Color(0xFF322A22),
    );

    canvas.drawLine(Offset.zero, Offset(w / 2, h * 0.52), line);
    canvas.drawLine(Offset(w, 0), Offset(w / 2, h * 0.52), line);
    canvas.drawLine(Offset(0, h), Offset(w / 2, h * 0.52), line);
    canvas.drawLine(Offset(w, h), Offset(w / 2, h * 0.52), line);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.black.withOpacity(0.04)
      ..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    canvas.drawLine(
      const Offset(36, 0),
      Offset(36, size.height),
      Paint()
        ..color = const Color(0xFFC0392B).withOpacity(0.12)
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PulsingHint extends StatefulWidget {
  final Color color;
  final String text;

  const _PulsingHint({required this.color, required this.text});

  @override
  State<_PulsingHint> createState() => _PulsingHintState();
}

class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  late final _opacity = Tween(begin: 0.15, end: 0.6).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => FadeTransition(
        opacity: _opacity,
        child: Text(
          widget.text,
          style: TextStyle(fontSize: 10, letterSpacing: 3.5, color: widget.color.withOpacity(0.5)),
        ),
      );
}
