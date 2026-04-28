import 'package:shared_preferences/shared_preferences.dart';

const String kLetterEmotionalPrimerSeenKey = 'letter_emotional_primer_seen';

/// Returns whether the emotional primer screen has already been shown.
/// Fail-open: returns `false` if SharedPreferences is unavailable,
/// so the primer is shown rather than silently skipped.
Future<bool> isLetterEmotionalPrimerSeen() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(kLetterEmotionalPrimerSeenKey) ?? false;
  } catch (_) {
    return false;
  }
}

/// Marks the emotional primer as seen. Silently swallows errors
/// so a storage failure never blocks the letter-opening flow.
Future<void> markLetterEmotionalPrimerSeen() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(kLetterEmotionalPrimerSeenKey, true);
  } catch (_) {}
}
