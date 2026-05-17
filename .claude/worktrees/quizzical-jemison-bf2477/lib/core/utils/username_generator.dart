/// Generates username suggestions from a display name.
///
/// All suggestions are lowercase, contain only `[a-z0-9._]`, and are at least
/// 3 characters long.
library;

import 'dart:math';

/// Diacritics → ASCII mapping used by [_normalize].
const _diacriticMap = {
  'à': 'a', 'á': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', 'å': 'a',
  'è': 'e', 'é': 'e', 'ê': 'e', 'ë': 'e',
  'ì': 'i', 'í': 'i', 'î': 'i', 'ï': 'i',
  'ò': 'o', 'ó': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o',
  'ù': 'u', 'ú': 'u', 'û': 'u', 'ü': 'u',
  'ñ': 'n', 'ç': 'c', 'ý': 'y', 'ÿ': 'y',
};

/// Strips accents and lowercases [input].
String _normalize(String input) {
  final buf = StringBuffer();
  for (final ch in input.toLowerCase().split('')) {
    buf.write(_diacriticMap[ch] ?? ch);
  }
  return buf.toString();
}

/// Keeps only `[a-z0-9]` from [s].
String _alphanumOnly(String s) => s.replaceAll(RegExp(r'[^a-z0-9]'), '');

/// Splits a normalised name into word parts (non-empty).
List<String> _words(String name) =>
    _normalize(name).split(RegExp(r'[^a-z0-9]+')).where((w) => w.isNotEmpty).toList();

/// Generates up to [max] unique username suggestions from [displayName].
///
/// The returned list is deterministic for a given [displayName] except for
/// the random-suffix variant.
List<String> generateUsernameSuggestions(String displayName, {int max = 4}) {
  final parts = _words(displayName);
  if (parts.isEmpty) return [];

  final seen = <String>{};
  final suggestions = <String>[];

  void add(String candidate) {
    // Sanitise: only a-z 0-9 . _
    final clean = candidate
        .replaceAll(RegExp(r'[^a-z0-9._]'), '')
        .replaceAll(RegExp(r'\.{2,}'), '.')   // no consecutive dots
        .replaceAll(RegExp(r'^[._]+'), '')     // no leading . or _
        .replaceAll(RegExp(r'[._]+$'), '');    // no trailing . or _
    if (clean.length >= 3 && seen.add(clean)) {
      suggestions.add(clean);
    }
  }

  final first = parts.first;
  final joined = parts.map(_alphanumOnly).join();

  // 1) All words joined: "yurilima"
  add(joined);

  // 2) Words joined with dot: "yuri.lima"
  if (parts.length >= 2) {
    add(parts.map(_alphanumOnly).join('.'));
  }

  // 3) Words joined with underscore: "yuri_lima"
  if (parts.length >= 2) {
    add(parts.map(_alphanumOnly).join('_'));
  }

  // 4) First name + two-digit random suffix: "yuri42"
  final suffix = (Random().nextInt(90) + 10).toString(); // 10-99
  add('${_alphanumOnly(first)}$suffix');

  // 5) If single-word name, try name + underscore variant
  if (parts.length == 1 && first.length >= 3) {
    add('${_alphanumOnly(first)}_ow');
  }

  return suggestions.take(max).toList();
}

/// Validates a username string.
///
/// Returns `null` if valid, or an error key (`'empty'`, `'short'`, `'long'`,
/// `'invalid'`) that the caller maps to a localised message.
String? validateUsername(String raw) {
  final username = raw.trim().toLowerCase().replaceAll('@', '');
  if (username.isEmpty) return 'empty';
  if (username.length < 3) return 'short';
  if (username.length > 20) return 'long';
  if (!RegExp(r'^[a-z0-9._]+$').hasMatch(username)) return 'invalid';
  if (username.startsWith('.') || username.startsWith('_')) return 'invalid';
  if (username.endsWith('.') || username.endsWith('_')) return 'invalid';
  if (username.contains('..')) return 'invalid';
  return null;
}

/// Sanitises raw input into a clean username (lowercase, no @, no spaces).
String sanitizeUsername(String raw) =>
    raw.trim().toLowerCase().replaceAll('@', '').replaceAll(' ', '');
