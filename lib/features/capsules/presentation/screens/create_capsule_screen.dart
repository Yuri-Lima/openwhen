import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../shared/widgets/owl_watermark.dart';
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

class CapsuleTheme {
  final String id, emoji, label, subtitle;
  final Color color;
  const CapsuleTheme({required this.id, required this.emoji, required this.label, required this.subtitle, required this.color});
}

const List<CapsuleTheme> kCapsuleThemes = [
  CapsuleTheme(id: 'memories',      emoji: '🧠', label: 'Memórias',        subtitle: 'Guarde o que não quer esquecer',   color: Color(0xFF6B6560)),
  CapsuleTheme(id: 'goals',         emoji: '🎯', label: 'Metas',           subtitle: 'Uma promessa para o futuro',       color: Color(0xFFC0392B)),
  CapsuleTheme(id: 'feelings',      emoji: '💛', label: 'Sentimentos',     subtitle: 'O que está dentro de você agora',  color: Color(0xFFC9A84C)),
  CapsuleTheme(id: 'relationships', emoji: '👥', label: 'Relacionamentos', subtitle: 'As pessoas que importam',          color: Color(0xFF5B8DB8)),
  CapsuleTheme(id: 'growth',        emoji: '🌱', label: 'Crescimento',     subtitle: 'Quem você está se tornando',       color: Color(0xFF4A8C6F)),
];

const kPresetEvents = ['Meu aniversário', 'Nosso aniversário', 'Minha formatura', 'Nascimento do bebê', 'Nossa mudança', 'Fim da viagem', 'Nova fase profissional', 'Natal', 'Ano Novo'];

class CreateCapsuleScreen extends ConsumerStatefulWidget {
  const CreateCapsuleScreen({super.key});
  @override
  ConsumerState<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends ConsumerState<CreateCapsuleScreen> with TickerProviderStateMixin {
  int _step = 0;
  bool _saving = false;
  CapsuleTheme? _selectedTheme;
  DateTime? _openDate;
  String _openEventType = 'date';
  String? _selectedPresetEvent;
  final _customEventCtrl = TextEditingController();
  final _titleCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _isPublic = false;
  late final AnimationController _stepAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _stepAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _fadeAnim = CurvedAnimation(parent: _stepAnim, curve: Curves.easeOut);
    _stepAnim.forward();
  }

  @override
  void dispose() {
    _stepAnim.dispose();
    _customEventCtrl.dispose();
    _titleCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _goStep(int step) {
    _stepAnim.reverse().then((_) {
      setState(() => _step = step);
      _stepAnim.forward();
    });
  }

  bool get _canAdvance {
    switch (_step) {
      case 0: return _selectedTheme != null;
      case 1: return _titleCtrl.text.trim().isNotEmpty && _messageCtrl.text.trim().length >= 10;
      case 2: return _openDate != null || _selectedPresetEvent != null || _customEventCtrl.text.trim().isNotEmpty;
      default: return false;
    }
  }

  Future<void> _saveCapsule() async {
    if (!_canAdvance) return;
    setState(() => _saving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final senderName = userDoc.data()?['displayName'] ?? userDoc.data()?['name'] ?? '';
      final docId = const Uuid().v4();

      String? eventLabel;
      if (_openEventType == 'event' || _openEventType == 'both') {
        eventLabel = _selectedPresetEvent ?? _customEventCtrl.text.trim();
      }

      await FirebaseFirestore.instance.collection('capsules').doc(docId).set({
        'id': docId,
        'senderUid': uid,
        'senderName': senderName,
        'receiverUid': uid,
        'receiverName': senderName,
        'title': _titleCtrl.text.trim(),
        'message': _messageCtrl.text.trim(),
        'theme': _selectedTheme!.id,
        'photos': [],
        'openDate': _openDate != null ? Timestamp.fromDate(_openDate!) : null,
        'openEvent': eventLabel,
        'openEventType': _openEventType,
        'status': 'locked',
        'isPublic': false,
        'publishAfterReview': _isPublic,
        'createdAt': FieldValue.serverTimestamp(),
        'openedAt': null,
        'publishedAt': null,
        'likeCount': 0,
        'commentCount': 0,
      });

      if (mounted) {
        setState(() => _saving = false);
        _showSuccess();
      }
    } catch (e) {
      setState(() => _saving = false);
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: _C.accent));
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: _C.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const OwlLogo(size: 80),
            const SizedBox(height: 20),
            Text('Cápsula selada!', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: _C.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text('Suas palavras estão guardadas.\nSó você poderá abrir na hora certa.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 14, color: _C.inkSoft, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _C.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Text('Ver meu Cofre', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const stepLabels = ['Tema', 'Mensagem', 'Quando abrir'];
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(children: [
        // Header
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [_C.ink, Color(0xFF2C2420)]),
          ),
          child: SafeArea(bottom: false, child: Column(children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(children: [
                GestureDetector(
                  onTap: () => _step > 0 ? _goStep(_step - 1) : Navigator.of(context).pop(),
                  child: Container(width: 38, height: 38, decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16)),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Text('Nova Cápsula do Tempo', style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
                    const SizedBox(width: 6),
                    const OwlWatermark(width: 18, height: 22),
                  ]),
                  Text('Passo ${_step + 1} de 3 — ${stepLabels[_step]}', style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 12)),
                ])),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(children: List.generate(3, (i) => Expanded(child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: i < _step ? _C.accent : i == _step ? _C.accent.withOpacity(0.6) : Colors.white.withOpacity(0.15),
                ),
              )))),
            ),
          ])),
        ),

        Expanded(child: FadeTransition(opacity: _fadeAnim, child: _buildCurrentStep())),

        // Botão avançar
        Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
          decoration: BoxDecoration(color: _C.white, border: Border(top: BorderSide(color: _C.border))),
          child: SizedBox(
            width: double.infinity, height: 52,
            child: AnimatedOpacity(
              opacity: _canAdvance ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: _canAdvance ? () => _step == 2 ? _saveCapsule() : _goStep(_step + 1) : null,
                style: ElevatedButton.styleFrom(backgroundColor: _C.accent, foregroundColor: Colors.white, disabledBackgroundColor: _C.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                child: _saving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_step == 2 ? 'Selar Cápsula 🦉' : 'Continuar', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _buildCurrentStep() {
    switch (_step) {
      case 0: return _buildStepTheme();
      case 1: return _buildStepMessage();
      case 2: return _buildStepWhen();
      default: return const SizedBox();
    }
  }

  // PASSO 1 — Tema
  Widget _buildStepTheme() {
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Text('Qual é a essência\ndessa cápsula?', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: _C.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text('Escolha um tema para sua cápsula.', style: GoogleFonts.dmSans(fontSize: 14, color: _C.inkSoft)),
      const SizedBox(height: 24),
      ...kCapsuleThemes.map((t) {
        final isSelected = _selectedTheme?.id == t.id;
        return GestureDetector(
          onTap: () => setState(() => _selectedTheme = t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? t.color.withOpacity(0.08) : _C.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? t.color : _C.border, width: isSelected ? 2 : 1),
            ),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: t.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(t.emoji, style: const TextStyle(fontSize: 22)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.label, style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: _C.ink)),
                Text(t.subtitle, style: GoogleFonts.dmSans(fontSize: 13, color: _C.inkSoft)),
              ])),
              if (isSelected) Icon(Icons.check_circle_rounded, color: t.color, size: 22),
            ]),
          ),
        );
      }),
    ]);
  }

  // PASSO 2 — Mensagem livre
  Widget _buildStepMessage() {
    final t = _selectedTheme!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Row(children: [
        Text(t.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(t.label, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: t.color)),
      ]),
      const SizedBox(height: 8),
      Text('Escreva para o\nseu eu do futuro', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: _C.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text('Escreva livremente. Sem regras. Só você e o futuro.', style: GoogleFonts.dmSans(fontSize: 13, color: _C.inkSoft)),
      const SizedBox(height: 24),

      // Título
      Container(
        decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: _titleCtrl,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
          decoration: InputDecoration(
            labelText: 'Título',
            hintText: 'Ex: Para o meu eu de daqui a 1 ano...',
            labelStyle: GoogleFonts.dmSans(color: _C.inkSoft),
            hintStyle: GoogleFonts.dmSans(color: _C.inkFaint),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      const SizedBox(height: 14),

      // Mensagem livre
      Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF2E8D5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.color.withOpacity(0.3), width: 1.5),
        ),
        child: TextField(
          controller: _messageCtrl,
          onChanged: (_) => setState(() {}),
          maxLines: 12,
          minLines: 8,
          style: GoogleFonts.dmSerifDisplay(fontSize: 15, color: const Color(0xFF241608), fontStyle: FontStyle.italic, height: 1.8),
          decoration: InputDecoration(
            hintText: 'Querido eu do futuro...\n\nEscreva o que está sentindo, o que sonha, o que quer lembrar...',
            hintStyle: GoogleFonts.dmSerifDisplay(color: _C.inkFaint, fontStyle: FontStyle.italic, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),

      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: Text('${_messageCtrl.text.trim().length} caracteres${_messageCtrl.text.trim().length < 10 ? " (mínimo 10)" : ""}',
          style: GoogleFonts.dmSans(fontSize: 11, color: _messageCtrl.text.trim().length < 10 ? _C.accent : _C.inkFaint)),
      ),
    ]);
  }

  // PASSO 3 — Quando abrir
  Widget _buildStepWhen() {
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Text('Quando você\npoderá abrir?', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: _C.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text('Escolha uma data ou evento especial.', style: GoogleFonts.dmSans(fontSize: 14, color: _C.inkSoft)),
      const SizedBox(height: 24),

      Row(children: [
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'date'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _openEventType == 'date' ? _C.accent : _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'date' ? _C.accent : _C.border)),
            child: Column(children: [
              const Text('📅', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 2),
              Text('Data', style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'date' ? Colors.white : _C.inkSoft, fontWeight: FontWeight.w500)),
            ]),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'event'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _openEventType == 'event' ? _C.accent : _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'event' ? _C.accent : _C.border)),
            child: Column(children: [
              const Text('🎉', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 2),
              Text('Evento', style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'event' ? Colors.white : _C.inkSoft, fontWeight: FontWeight.w500)),
            ]),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'both'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _openEventType == 'both' ? _C.accent : _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'both' ? _C.accent : _C.border)),
            child: Column(children: [
              const Text('📅🎉', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 2),
              Text('Ambos', style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'both' ? Colors.white : _C.inkSoft, fontWeight: FontWeight.w500)),
            ]),
          ),
        )),
      ]),
      const SizedBox(height: 12),

      if (_openEventType == 'date' || _openEventType == 'both') ...[
        GestureDetector(
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 365)),
              firstDate: DateTime.now().add(const Duration(days: 1)),
              lastDate: DateTime.now().add(const Duration(days: 365 * 50)),
              builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.light(primary: _C.accent)), child: child!),
            );
            if (d != null) setState(() => _openDate = d);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openDate != null ? _C.accent : _C.border)),
            child: Row(children: [
              Icon(Icons.calendar_today_outlined, color: _openDate != null ? _C.accent : _C.inkFaint, size: 20),
              const SizedBox(width: 10),
              Text(_openDate != null ? '${_openDate!.day.toString().padLeft(2,'0')}/${_openDate!.month.toString().padLeft(2,'0')}/${_openDate!.year}' : 'Escolher data',
                style: GoogleFonts.dmSans(fontSize: 14, color: _openDate != null ? _C.ink : _C.inkFaint)),
              const Spacer(),
              const Icon(Icons.chevron_right_rounded, color: _C.inkFaint, size: 20),
            ]),
          ),
        ),
        const SizedBox(height: 12),
      ],

      if (_openEventType == 'event' || _openEventType == 'both') ...[
        Wrap(
          spacing: 8, runSpacing: 8,
          children: kPresetEvents.map((e) {
            final isActive = _selectedPresetEvent == e;
            return GestureDetector(
              onTap: () => setState(() => _selectedPresetEvent = isActive ? null : e),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: isActive ? _C.accent : _C.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: isActive ? _C.accent : _C.border)),
                child: Text(e, style: GoogleFonts.dmSans(fontSize: 13, color: isActive ? Colors.white : _C.inkSoft)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _customEventCtrl,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
            decoration: InputDecoration(
              hintText: 'Ou descreva o evento...',
              hintStyle: GoogleFonts.dmSans(color: _C.inkFaint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.border)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Publicar no feed ao abrir', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: _C.ink)),
            Text('Você decide depois de rever tudo', style: GoogleFonts.dmSans(fontSize: 12, color: _C.inkSoft)),
          ])),
          Switch(value: _isPublic, onChanged: (v) => setState(() => _isPublic = v), activeColor: _C.accent),
        ]),
      ),
    ]);
  }
}
