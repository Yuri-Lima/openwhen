import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/constants/firestore_collections.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/owl_watermark.dart';
import '../../../../shared/widgets/owl_logo.dart';
import '../../../../shared/widgets/owl_feedback_affordance.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';

class CapsuleTheme {
  final String id, emoji;
  final Color color;
  const CapsuleTheme({required this.id, required this.emoji, required this.color});
}

const List<CapsuleTheme> kCapsuleThemes = [
  CapsuleTheme(id: 'memories',      emoji: '🧠', color: Color(0xFF6B6560)),
  CapsuleTheme(id: 'goals',         emoji: '🎯', color: Color(0xFFC0392B)),
  CapsuleTheme(id: 'feelings',      emoji: '💛', color: Color(0xFFC9A84C)),
  CapsuleTheme(id: 'relationships', emoji: '👥', color: Color(0xFF5B8DB8)),
  CapsuleTheme(id: 'growth',        emoji: '🌱', color: Color(0xFF4A8C6F)),
];

String capsuleThemeLabel(AppLocalizations l10n, String id) {
  switch (id) {
    case 'memories':      return l10n.createCapsuleThemeMemoriesLabel;
    case 'goals':         return l10n.createCapsuleThemeGoalsLabel;
    case 'feelings':      return l10n.createCapsuleThemeFeelingsLabel;
    case 'relationships': return l10n.createCapsuleThemeRelationshipsLabel;
    case 'growth':        return l10n.createCapsuleThemeGrowthLabel;
    default:              return id;
  }
}

String capsuleThemeSubtitle(AppLocalizations l10n, String id) {
  switch (id) {
    case 'memories':      return l10n.createCapsuleThemeMemoriesSubtitle;
    case 'goals':         return l10n.createCapsuleThemeGoalsSubtitle;
    case 'feelings':      return l10n.createCapsuleThemeFeelingsSubtitle;
    case 'relationships': return l10n.createCapsuleThemeRelationshipsSubtitle;
    case 'growth':        return l10n.createCapsuleThemeGrowthSubtitle;
    default:              return id;
  }
}

List<String> getPresetEvents(AppLocalizations l10n) => [
  l10n.createCapsulePresetBirthday,
  l10n.createCapsulePresetAnniversary,
  l10n.createCapsulePresetGraduation,
  l10n.createCapsulePresetBaby,
  l10n.createCapsulePresetMoving,
  l10n.createCapsulePresetTrip,
  l10n.createCapsulePresetCareer,
  l10n.createCapsulePresetChristmas,
  l10n.createCapsulePresetNewYear,
];

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
      await FirebaseFirestore.instance.collection(FirestoreCollections.capsules).doc(docId).set({
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
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.errorGeneric(e.toString())), backgroundColor: context.pal.accent));
    }
  }

  void _showSuccess() {
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        backgroundColor: p.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const OwlFeedbackAffordance(
              child: OwlLogo(size: 80),
            ),
            const SizedBox(height: 20),
            Text(l10n.createCapsuleSuccessTitle, style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: p.ink, fontStyle: FontStyle.italic)),
            const SizedBox(height: 8),
            Text(l10n.createCapsuleSuccessBody,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 14, color: p.inkSoft, height: 1.5)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: p.accent,
                  foregroundColor: p.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  elevation: 0,
                ),
                child: Text(l10n.createCapsuleSuccessViewVault, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;
    final stepLabels = [l10n.createCapsuleStepTheme, l10n.createCapsuleStepMessage, l10n.createCapsuleStepWhen];
    return Scaffold(
      backgroundColor: p.bg,
      body: Column(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: p.headerGradient),
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
                    Text(l10n.createCapsuleTitle, style: GoogleFonts.dmSerifDisplay(color: Colors.white, fontSize: 18, fontStyle: FontStyle.italic)),
                    const SizedBox(width: 6),
                    const OwlFeedbackAffordance(
                      forDarkHeader: true,
                      child: OwlWatermark(width: 18, height: 22, opacity: 2.2),
                    ),
                  ]),
                  Text(l10n.createCapsuleStepProgress(_step + 1, stepLabels[_step]), style: GoogleFonts.dmSans(color: Colors.white54, fontSize: 12)),
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
                  color: i < _step ? p.accent : i == _step ? p.accent.withOpacity(0.6) : Colors.white.withOpacity(0.15),
                ),
              )))),
            ),
          ])),
        ),

        Expanded(child: FadeTransition(opacity: _fadeAnim, child: _buildCurrentStep())),

        Container(
          padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
          decoration: BoxDecoration(color: p.card, border: Border(top: BorderSide(color: p.border))),
          child: SizedBox(
            width: double.infinity, height: 52,
            child: ElevatedButton(
              onPressed: _canAdvance ? () => _step == 2 ? _saveCapsule() : _goStep(_step + 1) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _canAdvance ? p.accent : p.inkFaint,
                foregroundColor: _canAdvance ? p.white : p.inkSoft,
                disabledBackgroundColor: p.inkFaint,
                disabledForegroundColor: p.inkSoft,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: _saving
                  ? SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: p.white, strokeWidth: 2))
                  : Text(_step == 2 ? l10n.createCapsuleSeal : l10n.actionContinue, style: GoogleFonts.dmSans(fontWeight: FontWeight.w600, fontSize: 16)),
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
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Text(l10n.createCapsuleThemeQuestion, style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: p.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text(l10n.createCapsuleThemeHint, style: GoogleFonts.dmSans(fontSize: 14, color: p.inkSoft)),
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
              color: isSelected ? t.color.withOpacity(0.08) : p.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isSelected ? t.color : p.border, width: isSelected ? 2 : 1),
            ),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: t.color.withOpacity(0.12), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(t.emoji, style: const TextStyle(fontSize: 22)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(capsuleThemeLabel(l10n, t.id), style: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600, color: p.ink)),
                Text(capsuleThemeSubtitle(l10n, t.id), style: GoogleFonts.dmSans(fontSize: 13, color: p.inkSoft)),
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
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;
    final t = _selectedTheme!;
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Row(children: [
        Text(t.emoji, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(capsuleThemeLabel(l10n, t.id), style: GoogleFonts.dmSans(fontSize: 13, fontWeight: FontWeight.w600, color: t.color)),
      ]),
      const SizedBox(height: 8),
      Text(l10n.createCapsuleWriteHeading, style: GoogleFonts.dmSerifDisplay(fontSize: 24, color: p.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text(l10n.createCapsuleWriteHint, style: GoogleFonts.dmSans(fontSize: 13, color: p.inkSoft)),
      const SizedBox(height: 24),

      Container(
        decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.border)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: TextField(
          controller: _titleCtrl,
          onChanged: (_) => setState(() {}),
          style: GoogleFonts.dmSans(fontSize: 15, color: p.ink),
          decoration: InputDecoration(
            labelText: l10n.createCapsuleFieldTitle,
            hintText: l10n.createCapsuleFieldTitleHint,
            labelStyle: GoogleFonts.dmSans(color: p.inkSoft),
            hintStyle: GoogleFonts.dmSans(color: p.inkFaint),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      const SizedBox(height: 14),

      Container(
        decoration: BoxDecoration(
          color: p.accentWarm,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: t.color.withOpacity(0.3), width: 1.5),
        ),
        child: TextField(
          controller: _messageCtrl,
          onChanged: (_) => setState(() {}),
          maxLines: 12,
          minLines: 8,
          style: GoogleFonts.dmSerifDisplay(fontSize: 15, color: p.ink, fontStyle: FontStyle.italic, height: 1.8),
          decoration: InputDecoration(
            hintText: l10n.createCapsuleFieldMessageHint,
            hintStyle: GoogleFonts.dmSerifDisplay(color: p.inkFaint, fontStyle: FontStyle.italic, fontSize: 14),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ),

      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerRight,
        child: Text('${l10n.createCapsuleCharCount(_messageCtrl.text.trim().length)}${_messageCtrl.text.trim().length < 10 ? l10n.createCapsuleCharMin : ""}',
          style: GoogleFonts.dmSans(fontSize: 11, color: _messageCtrl.text.trim().length < 10 ? p.accent : p.inkFaint)),
      ),
    ]);
  }

  // PASSO 3 — Quando abrir
  Widget _buildStepWhen() {
    final l10n = AppLocalizations.of(context)!;
    final p = context.pal;
    final locale = Localizations.localeOf(context).toString();
    final presetEvents = getPresetEvents(l10n);
    return ListView(padding: const EdgeInsets.fromLTRB(20, 24, 20, 24), children: [
      Text(l10n.createCapsuleWhenHeading, style: GoogleFonts.dmSerifDisplay(fontSize: 26, color: p.ink, fontStyle: FontStyle.italic, height: 1.2)),
      const SizedBox(height: 6),
      Text(l10n.createCapsuleWhenHint, style: GoogleFonts.dmSans(fontSize: 14, color: p.inkSoft)),
      const SizedBox(height: 24),

      Row(children: [
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'date'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _openEventType == 'date' ? p.accent : p.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'date' ? p.accent : p.border)),
            child: Column(children: [
              const Text('📅', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 2),
              Text(l10n.createCapsuleTypeDate, style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'date' ? Colors.white : p.inkSoft, fontWeight: FontWeight.w500)),
            ]),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'event'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _openEventType == 'event' ? p.accent : p.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'event' ? p.accent : p.border)),
            child: Column(children: [
              const Text('🎉', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 2),
              Text(l10n.createCapsuleTypeEvent, style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'event' ? Colors.white : p.inkSoft, fontWeight: FontWeight.w500)),
            ]),
          ),
        )),
        Expanded(child: GestureDetector(
          onTap: () => setState(() => _openEventType = 'both'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: _openEventType == 'both' ? p.accent : p.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openEventType == 'both' ? p.accent : p.border)),
            child: Column(children: [
              const Text('📅🎉', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 2),
              Text(l10n.createCapsuleTypeBoth, style: GoogleFonts.dmSans(fontSize: 12, color: _openEventType == 'both' ? Colors.white : p.inkSoft, fontWeight: FontWeight.w500)),
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
              builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: ColorScheme.fromSeed(seedColor: p.accent, brightness: p.brightness)), child: child!),
            );
            if (d != null) setState(() => _openDate = d);
          },
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: _openDate != null ? p.accent : p.border)),
            child: Row(children: [
              Icon(Icons.calendar_today_outlined, color: _openDate != null ? p.accent : p.inkFaint, size: 20),
              const SizedBox(width: 10),
              Text(_openDate != null ? formatShortDate(_openDate!, locale) : l10n.createCapsulePickDate,
                style: GoogleFonts.dmSans(fontSize: 14, color: _openDate != null ? p.ink : p.inkFaint)),
              const Spacer(),
              Icon(Icons.chevron_right_rounded, color: p.inkFaint, size: 20),
            ]),
          ),
        ),
        const SizedBox(height: 12),
      ],

      if (_openEventType == 'event' || _openEventType == 'both') ...[
        Wrap(
          spacing: 8, runSpacing: 8,
          children: presetEvents.map((e) {
            final isActive = _selectedPresetEvent == e;
            return GestureDetector(
              onTap: () => setState(() => _selectedPresetEvent = isActive ? null : e),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: isActive ? p.accent : p.card, borderRadius: BorderRadius.circular(20), border: Border.all(color: isActive ? p.accent : p.border)),
                child: Text(e, style: GoogleFonts.dmSans(fontSize: 13, color: isActive ? Colors.white : p.inkSoft)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: p.border)),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TextField(
            controller: _customEventCtrl,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.dmSans(fontSize: 15, color: p.ink),
            decoration: InputDecoration(
              hintText: l10n.createCapsuleCustomEventHint,
              hintStyle: GoogleFonts.dmSans(color: p.inkFaint),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],

      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: p.card, borderRadius: BorderRadius.circular(14), border: Border.all(color: p.border)),
        child: Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(l10n.createCapsulePublishToggle, style: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: p.ink)),
            Text(l10n.createCapsulePublishHint, style: GoogleFonts.dmSans(fontSize: 12, color: p.inkSoft)),
          ])),
          Switch(value: _isPublic, onChanged: (v) => setState(() => _isPublic = v), activeColor: p.accent),
        ]),
      ),
    ]);
  }
}
