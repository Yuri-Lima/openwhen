import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class EmotionalState {
  final String key;
  final String label;
  final String emoji;
  final Color color;
  final Color bgColor;
  const EmotionalState({required this.key, required this.label, required this.emoji, required this.color, required this.bgColor});
}

const List<EmotionalState> emotionalStates = [
  EmotionalState(key: 'love', label: 'Amor', emoji: '\u{1F495}', color: Color(0xFFE91E8C), bgColor: Color(0xFFFCE4F3)),
  EmotionalState(key: 'achievement', label: 'Conquista', emoji: '\u{1F3C6}', color: Color(0xFFF59E0B), bgColor: Color(0xFFFEF3C7)),
  EmotionalState(key: 'advice', label: 'Conselho', emoji: '\u{1F33F}', color: Color(0xFF10B981), bgColor: Color(0xFFD1FAE5)),
  EmotionalState(key: 'nostalgia', label: 'Saudade', emoji: '\u{1F342}', color: Color(0xFFD97706), bgColor: Color(0xFFFEF3C7)),
  EmotionalState(key: 'farewell', label: 'Despedida', emoji: '\u{1F98B}', color: Color(0xFF8B5CF6), bgColor: Color(0xFFEDE9FE)),
];

String emotionalStateLabel(AppLocalizations l10n, String key) {
  switch (key) {
    case 'love': return l10n.writeLetterEmotionLove;
    case 'achievement': return l10n.writeLetterEmotionAchievement;
    case 'advice': return l10n.writeLetterEmotionAdvice;
    case 'nostalgia': return l10n.writeLetterEmotionNostalgia;
    case 'farewell': return l10n.writeLetterEmotionFarewell;
    default: return key;
  }
}
