/// Validates Firebase Storage download URLs for optional letter voice attachments.
bool isValidVoiceLetterUrl(String? raw) {
  if (raw == null) return false;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return false;
  final u = Uri.tryParse(trimmed);
  if (u == null || u.scheme != 'https') return false;
  if (u.host != 'firebasestorage.googleapis.com') return false;
  final decoded = Uri.decodeFull(u.path);
  return decoded.contains('/voiceLetters/');
}
