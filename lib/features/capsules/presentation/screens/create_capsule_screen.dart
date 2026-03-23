import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

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
  final List<String> questions;
  const CapsuleTheme({required this.id, required this.emoji, required this.label, required this.subtitle, required this.color, required this.questions});
}

const List<CapsuleTheme> kCapsuleThemes = [
  CapsuleTheme(id: 'memories', emoji: '🧠', label: 'Memorias', subtitle: 'Guarde o que nao quer esquecer', color: Color(0xFF6B6560), questions: ['Como voce se sente hoje, de verdade?', 'Qual momento recente voce mais quer guardar?', 'O que voce mais tem medo de esquecer?', 'Descreva seu dia de hoje em uma frase.', 'O que voce esta ouvindo ou fazendo agora?']),
  CapsuleTheme(id: 'goals', emoji: '🎯', label: 'Metas', subtitle: 'Uma promessa para o futuro', color: Color(0xFFC0392B), questions: ['Qual e o seu maior objetivo neste momento?', 'O que voce quer ter conquistado quando abrir isso?', 'Que conselho voce daria ao seu eu do futuro?', 'O que te impede de chegar la?', 'Qual habito voce quer ter criado?']),
  CapsuleTheme(id: 'feelings', emoji: '💛', label: 'Sentimentos', subtitle: 'O que esta dentro de voce agora', color: Color(0xFFC9A84C), questions: ['O que te faz feliz hoje, mesmo que pequeno?', 'O que te pesa e voce nao fala pra ninguem?', 'Quem voce ama e raramente diz isso diretamente?', 'Qual emocao domina sua semana?', 'O que voce precisava ouvir hoje?']),
  CapsuleTheme(id: 'relationships', emoji: '👥', label: 'Relacionamentos', subtitle: 'As pessoas que importam', color: Color(0xFF5B8DB8), questions: ['Quem e a pessoa mais importante na sua vida agora?', 'O que voce quer dizer a alguem mas nao consegue?', 'Qual amizade voce quer ter cultivado no futuro?', 'O que voce aprendeu com alguem recentemente?', 'Quem voce quer agradecer quando abrir isso?']),
  CapsuleTheme(id: 'growth', emoji: '🌱', label: 'Crescimento', subtitle: 'Quem voce esta se tornando', color: Color(0xFF4A8C6F), questions: ['O que voce aprendeu recentemente que mudou voce?', 'Em que voce mais mudou no ultimo ano?', 'O que voce quer mudar em voce mesmo?', 'Qual versao de voce mesmo te orgulha hoje?', 'O que voce deixaria para tras se pudesse?']),
];

const kPresetEvents = ['Meu aniversario', 'Nosso aniversario', 'Minha formatura', 'Nascimento do bebe', 'Nossa mudanca', 'Fim da viagem', 'Nova fase profissional', 'Natal', 'Ano Novo'];

class CreateCapsuleScreen extends ConsumerStatefulWidget {
  const CreateCapsuleScreen({super.key});
  @override
  ConsumerState<CreateCapsuleScreen> createState() => _CreateCapsuleScreenState();
}

class _CreateCapsuleScreenState extends ConsumerState<CreateCapsuleScreen> with TickerProviderStateMixin {
  int _step = 0;
  bool _saving = false;
  CapsuleTheme? _selectedTheme;
  final Map<int, TextEditingController> _answerControllers = {};
  final Set<int> _selectedQuestions = {};
  DateTime? _openDate;
  String _openEventType = 'date';
  String? _selectedPresetEvent;
  final TextEditingController _customEventCtrl = TextEditingController();
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _receiverCtrl = TextEditingController();
  bool _isPublic = false;
  String? _receiverUid;
  String? _receiverName;
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
    _receiverCtrl.dispose();
    for (final c in _answerControllers.values) c.dispose();
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
      case 1: return _selectedQuestions.length >= 2 && _selectedQuestions.every((i) => (_answerControllers[i]?.text.trim().length ?? 0) >= 10);
      case 2: return _titleCtrl.text.trim().isNotEmpty && (_openDate != null || _selectedPresetEvent != null || _customEventCtrl.text.trim().isNotEmpty);
      default: return false;
    }
  }

  Future<void> _saveCapsule() async {
    if (!_canAdvance) return;
    setState(() => _saving = true);
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final docId = const Uuid().v4();
      final List<Map<String, String>> qa = [];
      for (final idx in _selectedQuestions.toList()..sort()) {
        qa.add({'question': _selectedTheme!.questions[idx], 'answer': _answerControllers[idx]?.text.trim() ?? ''});
      }
      String? eventLabel;
      if (_openEventType == 'event' || _openEventType == 'both') {
        eventLabel = _selectedPresetEvent ?? _customEventCtrl.text.trim();
      }
      await FirebaseFirestore.instance.collection('capsules').doc(docId).set({
        'id': docId,
        'senderUid': uid,
        'receiverUid': _receiverUid ?? uid,
        'receiverName': _receiverName ?? '',
        'title': _titleCtrl.text.trim(),
        'theme': _selectedTheme!.id,
        'questions': qa,
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: _C.accent));
      }
    }
  }

  void _showSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SuccessDialog(onDone: () {
        Navigator.of(context).pop();
        Navigator.of(context).popUntil((route) => route.isFirst);
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    const stepLabels = ['Tema', 'Perguntas', 'Detalhes'];
    return Scaffold(
      backgroundColor: _C.bg,
      body: Column(children: [
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
                  Text('Nova Capsula do Tempo', style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
                  Text('Passo ${_step + 1} de 3 - ${stepLabels[_step]}', style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 12)),
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
        Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
          decoration: BoxDecoration(color: _C.white, border: Border(top: BorderSide(color: _C.border))),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: AnimatedOpacity(
              opacity: _canAdvance ? 1.0 : 0.45,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: _canAdvance ? () => _step == 2 ? _saveCapsule() : _goStep(_step + 1) : null,
                style: ElevatedButton.styleFrom(backgroundColor: _C.accent, foregroundColor: Colors.white, disabledBackgroundColor: _C.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                child: _saving
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_step == 2 ? 'Selar Capsula' : 'Continuar', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
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
      case 1: return _buildStepQuestions();
      case 2: return _buildStepDetails();
      default: return const SizedBox();
    }
  }

  Widget _buildStepTheme() {
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Text('Qual e a essencia\ndessa capsula?', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: _C.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text('Escolha um tema. As perguntas serao geradas para voce.', style: GoogleFonts.dmSans(fontSize: 14, color: _C.inkSoft)),
      const SizedBox(height: 24),
      ...kCapsuleThemes.map((t) {
        final isSelected = _selectedTheme?.id == t.id;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedTheme = t;
            _selectedQuestions.clear();
            for (final c in _answerControllers.values) c.dispose();
            _answerControllers.clear();
          }),
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

  Widget _buildStepQuestions() {
    final t = _selectedTheme!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Row(children: [
        Text(t.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(t.label, style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: t.color)),
      ]),
      const SizedBox(height: 8),
      Text('Escolha pelo menos 2\nperguntas para responder', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: _C.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text('Suas respostas ficam seladas ate a data de abertura.', style: GoogleFonts.dmSans(fontSize: 13, color: _C.inkSoft)),
      const SizedBox(height: 24),
      ...List.generate(t.questions.length, (i) {
        final isSelected = _selectedQuestions.contains(i);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isSelected ? t.color.withOpacity(0.06) : _C.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? t.color : _C.border, width: isSelected ? 1.5 : 1),
          ),
          child: Column(children: [
            InkWell(
              onTap: () => setState(() {
                if (isSelected) {
                  _selectedQuestions.remove(i);
                  _answerControllers[i]?.dispose();
                  _answerControllers.remove(i);
                } else if (_selectedQuestions.length < 5) {
                  _selectedQuestions.add(i);
                  _answerControllers[i] = TextEditingController();
                }
              }),
              borderRadius: BorderRadius.circular(16),
              child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24, height: 24,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: isSelected ? t.color : Colors.transparent, border: Border.all(color: isSelected ? t.color : _C.inkFaint, width: 1.5)),
                  child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 14) : null,
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(t.questions[i], style: GoogleFonts.dmSans(fontSize: 14, color: isSelected ? _C.ink : _C.inkSoft, fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal))),
              ])),
            ),
            if (isSelected && _answerControllers[i] != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _answerControllers[i],
                  onChanged: (_) => setState(() {}),
                  maxLines: 4,
                  minLines: 3,
                  style: GoogleFonts.dmSans(fontSize: 14, color: _C.ink),
                  decoration: InputDecoration(
                    hintText: 'Escreva sua resposta...',
                    hintStyle: GoogleFonts.dmSans(color: _C.inkFaint),
                    filled: true,
                    fillColor: _C.white,
                    contentPadding: const EdgeInsets.all(12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _C.border)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: _C.border)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: t.color, width: 1.5)),
                  ),
                ),
              ),
          ]),
        );
      }),
    ]);
  }

  Widget _buildStepDetails() {
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Text('Ultimos detalhes\nda sua capsula', style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: _C.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 24),
      Text('Titulo', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: _C.inkSoft)),
      const SizedBox(height: 8),
      TextField(
        controller: _titleCtrl,
        onChanged: (_) => setState(() {}),
        style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
        decoration: InputDecoration(
          hintText: 'Ex: Para o meu eu de 30 anos...',
          hintStyle: GoogleFonts.dmSans(color: _C.inkFaint),
          filled: true, fillColor: _C.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _C.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _C.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.accent, width: 1.5)),
        ),
      ),
      const SizedBox(height: 20),
      Text('Quando abrir?', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: _C.inkSoft)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'date'),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: _openEventType == 'date' ? _C.accent : _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'date' ? _C.accent : _C.border)),
            child: Column(children: [const Text('📅', style: TextStyle(fontSize: 18)), const SizedBox(height: 2), Text('Data', style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'date' ? Colors.white : _C.inkSoft, fontWeight: FontWeight.w500))]),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'event'),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), margin: const EdgeInsets.only(right: 8), padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: _openEventType == 'event' ? _C.accent : _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'event' ? _C.accent : _C.border)),
            child: Column(children: [const Text('🎉', style: TextStyle(fontSize: 18)), const SizedBox(height: 2), Text('Evento', style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'event' ? Colors.white : _C.inkSoft, fontWeight: FontWeight.w500))]),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'both'),
          child: AnimatedContainer(duration: const Duration(milliseconds: 200), padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: _openEventType == 'both' ? _C.accent : _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'both' ? _C.accent : _C.border)),
            child: Column(children: [const Text('📅🎉', style: TextStyle(fontSize: 18)), const SizedBox(height: 2), Text('Ambos', style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'both' ? Colors.white : _C.inkSoft, fontWeight: FontWeight.w500))]),
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
              Text(_openDate != null ? '${_openDate!.day.toString().padLeft(2, '0')}/${_openDate!.month.toString().padLeft(2, '0')}/${_openDate!.year}' : 'Escolher data', style: GoogleFonts.dmSans(fontSize: 14, color: _openDate != null ? _C.ink : _C.inkFaint)),
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
        TextField(
          controller: _customEventCtrl,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
          decoration: InputDecoration(
            hintText: 'Ou descreva o evento...',
            hintStyle: GoogleFonts.dmSans(color: _C.inkFaint),
            filled: true, fillColor: _C.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _C.border)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _C.border)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.accent, width: 1.5)),
          ),
        ),
        const SizedBox(height: 20),
      ],
      Text('Destinatario (opcional)', style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: _C.inkSoft)),
      const SizedBox(height: 8),
      _ReceiverSearch(controller: _receiverCtrl, onFound: (uid, name) => setState(() { _receiverUid = uid; _receiverName = name; })),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: _C.border)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Publicar no feed ao abrir', style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: _C.ink)),
              Text('Voce decide depois de rever tudo', style: GoogleFonts.dmSans(fontSize: 12, color: _C.inkSoft)),
            ])),
            Switch(value: _isPublic, onChanged: (v) => setState(() => _isPublic = v), activeColor: _C.accent),
          ]),
          if (_isPublic) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _C.accentWarm, borderRadius: BorderRadius.circular(10)),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, color: _C.accent, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text('A publicacao so acontece depois que voce revisar ao abrir a capsula.', style: GoogleFonts.dmSans(fontSize: 12, color: _C.accent))),
              ]),
            ),
          ],
        ]),
      ),
    ]);
  }
}

class _ReceiverSearch extends StatefulWidget {
  final TextEditingController controller;
  final Function(String uid, String name) onFound;
  const _ReceiverSearch({required this.controller, required this.onFound});
  @override
  State<_ReceiverSearch> createState() => _ReceiverSearchState();
}

class _ReceiverSearchState extends State<_ReceiverSearch> {
  List<Map<String, dynamic>> _results = [];
  bool _loading = false;
  String? _selectedName;

  Future<void> _search(String query) async {
    if (query.length < 2) { setState(() => _results = []); return; }
    setState(() => _loading = true);
    final snap = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query.toLowerCase())
        .where('username', isLessThan: '${query.toLowerCase()}z')
        .limit(5)
        .get();
    setState(() {
      _results = snap.docs.map((d) => {'uid': d.id, ...d.data()}).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedName != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: _C.accentWarm, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.accent)),
        child: Row(children: [
          const Icon(Icons.person_rounded, color: _C.accent, size: 18),
          const SizedBox(width: 10),
          Text(_selectedName!, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: _C.ink)),
          const Spacer(),
          GestureDetector(
            onTap: () => setState(() { _selectedName = null; widget.controller.clear(); }),
            child: const Icon(Icons.close, color: _C.accent, size: 18),
          ),
        ]),
      );
    }
    return Column(children: [
      TextField(
        controller: widget.controller,
        onChanged: _search,
        style: GoogleFonts.dmSans(fontSize: 15, color: _C.ink),
        decoration: InputDecoration(
          hintText: 'Buscar por @username',
          hintStyle: GoogleFonts.dmSans(color: _C.inkFaint),
          prefixIcon: const Icon(Icons.search, color: _C.inkFaint, size: 20),
          suffixIcon: _loading ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: _C.accent))) : null,
          filled: true, fillColor: _C.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _C.border)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: _C.border)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: _C.accent, width: 1.5)),
        ),
      ),
      if (_results.isNotEmpty)
        Container(
          margin: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(color: _C.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: _C.border)),
          child: Column(children: _results.map((u) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            leading: CircleAvatar(backgroundColor: _C.accentWarm, radius: 18, child: Text((u['displayName'] as String? ?? 'U').substring(0, 1).toUpperCase(), style: GoogleFonts.dmSans(color: _C.accent, fontWeight: FontWeight.bold))),
            title: Text(u['displayName'] ?? '', style: GoogleFonts.dmSans(fontSize: 14, color: _C.ink)),
            subtitle: Text('@${u['username'] ?? ''}', style: GoogleFonts.dmSans(fontSize: 12, color: _C.inkSoft)),
            onTap: () {
              setState(() { _selectedName = u['displayName']; _results = []; });
              widget.onFound(u['uid'], u['displayName'] ?? '');
            },
          )).toList()),
        ),
    ]);
  }
}

class _SuccessDialog extends StatelessWidget {
  final VoidCallback onDone;
  const _SuccessDialog({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _C.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 72, height: 72, decoration: const BoxDecoration(color: _C.accentWarm, shape: BoxShape.circle), child: const Center(child: Text('⏳', style: TextStyle(fontSize: 34)))),
        const SizedBox(height: 20),
        Text('Capsula selada!', style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: _C.ink, fontStyle: FontStyle.italic)),
        const SizedBox(height: 8),
        Text('Suas memorias estao guardadas. Voce podera revisar e decidir o que compartilhar quando abrir.', textAlign: TextAlign.center, style: GoogleFonts.dmSans(fontSize: 14, color: _C.inkSoft, height: 1.5)),
        const SizedBox(height: 24),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: onDone,
          style: ElevatedButton.styleFrom(backgroundColor: _C.accent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(vertical: 14), elevation: 0),
          child: Text('Ver meu Cofre', style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 15)),
        )),
      ])),
    );
  }
}
