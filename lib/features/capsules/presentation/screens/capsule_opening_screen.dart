import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  // 0=animacao 1=revelando 2=completo
  int _phase = 0;
  int _revealedCount = 0;
  bool _publishing = false;

  late final AnimationController _sealAnim;
  late final AnimationController _shakeAnim;
  late final AnimationController _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _opacityAnim;
  late final Animation<double> _shakeAnimValue;

  List<Map<String, String>> get _questions {
    final q = widget.data['questions'] as List? ?? [];
    return q.map((e) => Map<String, String>.from(e as Map)).toList();
  }

  final themeData = {
    'memories':      ('🧠', 'Memorias',       Color(0xFF6B6560)),
    'goals':         ('🎯', 'Metas',           Color(0xFFC0392B)),
    'feelings':      ('💛', 'Sentimentos',     Color(0xFFC9A84C)),
    'relationships': ('👥', 'Relacionamentos', Color(0xFF5B8DB8)),
    'growth':        ('🌱', 'Crescimento',     Color(0xFF4A8C6F)),
  };

  @override
  void initState() {
    super.initState();

    _sealAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _shakeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));

    _scaleAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _sealAnim, curve: Curves.easeInBack),
    );
    _opacityAnim = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _sealAnim, curve: const Interval(0.7, 1.0)),
    );
    _shakeAnimValue = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _shakeAnim, curve: Curves.elasticIn),
    );

    _startAnimation();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 600));
    await _shakeAnim.forward();
    await _shakeAnim.reverse();
    await _shakeAnim.forward();
    await _shakeAnim.reverse();
    await Future.delayed(const Duration(milliseconds: 200));
    await _sealAnim.forward();
    await _markAsOpened();
    if (mounted) setState(() => _phase = 1);
    await Future.delayed(const Duration(milliseconds: 400));
    _revealNext();
  }

  Future<void> _markAsOpened() async {
    await FirebaseFirestore.instance.collection('capsules').doc(widget.docId).update({
      'status': 'opened',
      'openedAt': FieldValue.serverTimestamp(),
    });
  }

  void _revealNext() async {
    if (_revealedCount < _questions.length) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (mounted) setState(() => _revealedCount++);
      await Future.delayed(const Duration(milliseconds: 500));
      _revealNext();
    } else {
      await Future.delayed(const Duration(milliseconds: 400));
      if (mounted) setState(() => _phase = 2);
    }
  }

  Future<void> _publish() async {
    setState(() => _publishing = true);
    await FirebaseFirestore.instance.collection('capsules').doc(widget.docId).update({
      'isPublic': true,
      'publishedAt': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      setState(() => _publishing = false);
      _showPublishedSnack();
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _showPublishedSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Capsula publicada no feed!', style: GoogleFonts.dmSans()),
        backgroundColor: _C.accent,
      ),
    );
  }

  @override
  void dispose() {
    _sealAnim.dispose();
    _shakeAnim.dispose();
    _fadeAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.ink,
      body: SafeArea(
        child: _phase == 0 ? _buildSealPhase() : _buildRevealPhase(),
      ),
    );
  }

  // FASE 0 — ANIMACAO DO LACRE
  Widget _buildSealPhase() {
    final theme = widget.data['theme'] ?? 'memories';
    final td = themeData[theme] ?? ('⏳', 'Capsula', _C.accent);

    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        AnimatedBuilder(
          animation: Listenable.merge([_shakeAnim, _sealAnim]),
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_shakeAnimValue.value, 0),
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: Opacity(
                  opacity: _opacityAnim.value,
                  child: Container(
                    width: 120, height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (td.$3 as Color).withOpacity(0.15),
                      border: Border.all(color: (td.$3 as Color).withOpacity(0.3), width: 2),
                    ),
                    child: Center(
                      child: Text(td.$1 as String, style: const TextStyle(fontSize: 52)),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 32),
        AnimatedBuilder(
          animation: _sealAnim,
          builder: (context, _) => Opacity(
            opacity: _opacityAnim.value,
            child: Text(
              'Abrindo sua capsula...',
              style: GoogleFonts.dmSerifDisplay(color: Colors.white.withOpacity(0.7), fontSize: 20, fontStyle: FontStyle.italic),
            ),
          ),
        ),
      ]),
    );
  }

  // FASE 1 + 2 — REVELACAO + COMPLETO
  Widget _buildRevealPhase() {
    final theme = widget.data['theme'] ?? 'memories';
    final td = themeData[theme] ?? ('⏳', 'Capsula', _C.accent);
    final title = widget.data['title'] ?? '';
    final publishAfterReview = widget.data['publishAfterReview'] ?? false;
    final createdAt = widget.data['createdAt'] != null
        ? (widget.data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    return Column(children: [
      // Header
      Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
          Text(td.$1 as String, style: const TextStyle(fontSize: 28)),
        ]),
      ),

      // Conteudo
      Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            // Badge tema
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: (td.$3 as Color).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: (td.$3 as Color).withOpacity(0.3)),
                ),
                child: Text('${td.$1} ${td.$2}', style: GoogleFonts.dmSans(color: td.$3 as Color, fontWeight: FontWeight.w600, fontSize: 14)),
              ),
            ),
            const SizedBox(height: 28),

            // Perguntas e respostas
            ...List.generate(_revealedCount, (i) {
              final q = _questions[i];
              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: Transform.translate(offset: Offset(0, 20 * (1 - value)), child: child),
                ),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(q['question'] ?? '', style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Text(q['answer'] ?? '', style: GoogleFonts.dmSans(color: Colors.white, fontSize: 15, height: 1.6)),
                  ]),
                ),
              );
            }),

            // Fase completa — botoes
            if (_phase == 2) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(children: [
                  const Text('✨', style: TextStyle(fontSize: 32)),
                  const SizedBox(height: 12),
                  Text('Voce abriu sua capsula!', style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 20, fontStyle: FontStyle.italic)),
                  const SizedBox(height: 6),
                  Text('Essas palavras foram escritas por voce\npara o seu eu de hoje.', textAlign: TextAlign.center, style: GoogleFonts.dmSans(color: Colors.white38, fontSize: 13, height: 1.5)),
                ]),
              ),
              const SizedBox(height: 24),
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
                        : Text('Publicar no feed', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withOpacity(0.15)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Guardar privado', style: GoogleFonts.dmSans(color: Colors.white60, fontSize: 16)),
                ),
              ),
            ],
          ],
        ),
      ),
    ]);
  }
}
