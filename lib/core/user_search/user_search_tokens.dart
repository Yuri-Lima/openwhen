import 'dart:math' as math;

/// Tokens for Firestore `array-contains` queries on public name / handle.
///
/// **Legacy users:** documents without `searchTokens` are only matched by
/// **username prefix** until the user saves their profile again (or you run
/// a one-off Admin backfill that sets `searchTokens` from [buildUserSearchTokens]).
/// Keeps document size bounded (max [maxTokens] strings).
const int kUserSearchMaxTokens = 30;
const int kUserSearchMaxTokenLength = 48;

/// Builds lowercase tokens from [displayName], [name], and [username] words
/// plus short prefixes so queries like "mar" can match "Maria".
List<String> buildUserSearchTokens({
  required String username,
  required String displayName,
  required String name,
}) {
  final out = <String>{};
  void addWordTokens(String? raw) {
    if (raw == null || raw.trim().isEmpty) return;
    final normalized = raw
        .toLowerCase()
        .replaceAll('@', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalized.isEmpty) return;
    for (final part in normalized.split(' ')) {
      final w = part.replaceAll(RegExp(r'[^a-z0-9\u00C0-\u024F]'), '');
      if (w.length < 2) continue;
      out.add(w);
      final maxPref = math.min(w.length, 12);
      for (var len = 2; len < maxPref; len++) {
        out.add(w.substring(0, len));
      }
    }
  }

  addWordTokens(username);
  addWordTokens(displayName);
  if (name != displayName) addWordTokens(name);

  final list = out.toList()..sort();
  final capped = <String>[];
  for (final t in list) {
    if (t.length > kUserSearchMaxTokenLength) continue;
    capped.add(t);
    if (capped.length >= kUserSearchMaxTokens) break;
  }
  return capped;
}
