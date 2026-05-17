import 'package:flutter/widgets.dart' show Locale;

/// Camada lexical (lista fechada). Usada antes da moderação por IA onde aplicável.
/// Ver `planning/MODERATION.md` — comentários; cartas reutilizam a mesma base.
final Map<String, List<String>> kBannedLexicalWordsByLang = {
  'pt': [
    'idiota', 'imbecil', 'burro', 'estupido', 'estúpido',
    'lixo', 'merda', 'puta', 'viado', 'fdp',
    'canalha', 'vagabundo', 'prostituta', 'desgraça',
    'maldito', 'inferno', 'otario', 'otário',
    'odeio', 'morra', 'morte',
  ],
  'en': [
    'idiot', 'moron', 'stupid', 'dumb', 'trash',
    'shit', 'fuck', 'bitch', 'asshole', 'bastard',
    'slut', 'whore', 'damn', 'crap', 'hate',
    'die', 'kill',
  ],
  'es': [
    'idiota', 'imbécil', 'estúpido', 'tonto', 'basura',
    'mierda', 'puta', 'cabrón', 'pendejo', 'maricón',
    'maldito', 'infierno', 'odio', 'muere', 'muerte',
    'desgraciado', 'prostituta',
  ],
};

/// Devolve true se [text] contém alguma palavra lexical bloqueada (PT + idioma atual).
bool textContainsBannedLexicalWord(String text, Locale locale) {
  final textLower = text.toLowerCase();
  final lang = locale.languageCode;
  final allWords = <String>{
    ...(kBannedLexicalWordsByLang['pt'] ?? []),
    ...(kBannedLexicalWordsByLang[lang] ?? []),
  };
  for (final word in allWords) {
    if (textLower.contains(word)) return true;
  }
  return false;
}
