import '../../../shared/utils/voice_url.dart';

/// Only Firebase Storage URLs under known prefixes (voice / handwritten).
bool isAllowedLetterAssetDownloadUrl(String? raw) {
  if (raw == null) return false;
  final t = raw.trim();
  if (t.isEmpty) return false;
  return isValidVoiceLetterUrl(t) || _isHandwrittenStorageUrl(t);
}

bool _isHandwrittenStorageUrl(String raw) {
  final u = Uri.tryParse(raw);
  if (u == null || u.scheme != 'https') return false;
  if (u.host != 'firebasestorage.googleapis.com') return false;
  return Uri.decodeFull(u.path).contains('/handwritten/');
}

/// Safe segment for zip entry names (Firestore doc ids are fine; strip odd chars).
String sanitizeExportSegment(String id) {
  return id.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
}
