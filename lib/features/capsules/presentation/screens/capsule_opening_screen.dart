import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/music_url.dart';
import '../../../../shared/widgets/music_link_tile.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
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
                        if (isValidHttpsMusicUrl(widget.data['musicUrl'] as String?)) ...[
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () => launchExternalMusicUrl(context, widget.data['musicUrl'] as String),
                              icon: Icon(Icons.music_note_rounded, color: glowColor, size: 22),
                              label: Text(
                                l10n.musicLinkTitle,
                                style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: glowColor.withOpacity(0.5)),
                                backgroundColor: glowColor.withOpacity(0.08),
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                            ),
                          ),
                        ],
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
  final String text;

  const _PulsingHint({required this.color, required this.text});

  @override
  State<_PulsingHint> createState() => _PulsingHintState();
}
class _PulsingHintState extends State<_PulsingHint> with SingleTickerProviderStateMixin {
  late final _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))..repeat(reverse: true);
  late final _opacity = Tween(begin: 0.15, end: 0.6).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
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
