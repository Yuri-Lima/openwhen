import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/deferred_screens.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/theme/whenote_palette.dart';
import '../../domain/draft_model.dart';
import '../../domain/draft_service.dart';
import '../models/emotional_state.dart';

/// Tela de listagem de rascunhos de cartas com countdown de expiração.
class DraftsScreen extends StatefulWidget {
  const DraftsScreen({super.key});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  final _draftService = DraftService();
  late final String _uid;
  List<LetterDraft>? _drafts;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    _loadDrafts();
  }

  Future<void> _loadDrafts() async {
    setState(() => _loading = true);
    try {
      final drafts = await _draftService.listDrafts(_uid);
      if (mounted) setState(() { _drafts = drafts; _loading = false; });
    } catch (e) {
      debugPrint('[DraftsScreen] _loadDrafts error: $e');
      if (mounted) setState(() { _drafts = []; _loading = false; });
    }
  }

  Future<void> _deleteDraft(LetterDraft draft) async {
    if (draft.id == null) return;
    await _draftService.deleteDraft(draft.id!, draft.senderUid);
    await _loadDrafts();
  }

  void _openDraft(LetterDraft draft) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => DeferredWriteLetterPage(draftId: draft.id!),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: p.bg,
      appBar: AppBar(
        backgroundColor: p.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: p.ink),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l10n.draftsTitle,
          style: GoogleFonts.dmSerifDisplay(color: p.ink, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _drafts == null || _drafts!.isEmpty
              ? _buildEmptyState(p, l10n)
              : RefreshIndicator(
                  onRefresh: _loadDrafts,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _drafts!.length,
                    itemBuilder: (ctx, i) => _DraftCard(
                      draft: _drafts![i],
                      onTap: () => _openDraft(_drafts![i]),
                      onDelete: () => _deleteDraft(_drafts![i]),
                    ),
                  ),
                ),
    );
  }

  Widget _buildEmptyState(WhenotePalette p, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.drafts_outlined, size: 56, color: p.inkFaint),
            const SizedBox(height: 16),
            Text(
              l10n.draftsEmpty,
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(fontSize: 15, color: p.inkSoft),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Draft Card
// ---------------------------------------------------------------------------

class _DraftCard extends StatelessWidget {
  final LetterDraft draft;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DraftCard({
    required this.draft,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final l10n = AppLocalizations.of(context)!;
    final days = draft.daysRemaining;

    // Cor do countdown baseada na urgência
    final Color countdownColor;
    if (days <= 3) {
      countdownColor = const Color(0xFFDC2626); // vermelho
    } else if (days <= 7) {
      countdownColor = const Color(0xFFF59E0B); // amarelo
    } else {
      countdownColor = p.inkFaint;
    }

    // Encontra o emoji da emoção
    String? emoji;
    Color? emotionColor;
    if (draft.emotionKey != null) {
      for (final e in emotionalStates) {
        if (e.key == draft.emotionKey) {
          emoji = e.emoji;
          emotionColor = e.color;
          break;
        }
      }
    }

    final title = draft.title.trim().isEmpty
        ? l10n.draftsUntitled
        : draft.title.trim();
    final preview = draft.message.trim().isEmpty
        ? l10n.draftsNoContent
        : (draft.message.trim().length > 80
            ? '${draft.message.trim().substring(0, 80)}...'
            : draft.message.trim());

    return Dismissible(
      key: ValueKey(draft.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFDC2626),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
      ),
      confirmDismiss: (_) async {
        return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(l10n.draftsDeleteTitle),
            content: Text(l10n.draftsDeleteMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: Text(l10n.actionCancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: Text(l10n.actionDelete,
                    style: const TextStyle(color: Color(0xFFDC2626))),
              ),
            ],
          ),
        );
      },
      onDismissed: (_) => onDelete(),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: p.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: p.cardBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Linha superior: título + emoji
              Row(
                children: [
                  if (emoji != null) ...[
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: (emotionColor ?? p.accent).withValues(alpha:0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(emoji, style: const TextStyle(fontSize: 16)),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 16,
                        color: p.ink,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (draft.isHandwritten)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(Icons.draw_outlined, size: 16, color: p.inkFaint),
                    ),
                  if (draft.voiceUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: Icon(Icons.mic_none, size: 16, color: p.inkFaint),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Preview do conteúdo
              Text(
                preview,
                style: GoogleFonts.dmSans(
                  fontSize: 13,
                  color: p.inkSoft,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Countdown + barra de progresso
              _DraftCountdownBar(
                daysRemaining: days,
                totalDays: LetterDraft.expirationDays,
                color: countdownColor,
                label: l10n.draftsExpiresIn(days),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Countdown Bar Widget
// ---------------------------------------------------------------------------

class _DraftCountdownBar extends StatelessWidget {
  final int daysRemaining;
  final int totalDays;
  final Color color;
  final String label;

  const _DraftCountdownBar({
    required this.daysRemaining,
    required this.totalDays,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final p = context.pal;
    final progress = (daysRemaining / totalDays).clamp(0.0, 1.0);

    return Row(
      children: [
        Icon(Icons.timer_outlined, size: 14, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.dmSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
        const Spacer(),
        SizedBox(
          width: 60,
          height: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: p.divider,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
        ),
      ],
    );
  }
}

