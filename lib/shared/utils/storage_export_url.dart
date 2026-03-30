/// Allowlist for fetching letter media during export (SSRF-safe).
bool isValidFirebaseStorageExportUrl(String? raw, {required String pathSegment}) {
  if (raw == null) return false;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return false;
  final u = Uri.tryParse(trimmed);
  if (u == null || u.scheme != 'https') return false;
  if (u.host != 'firebasestorage.googleapis.com') return false;
  final decoded = Uri.decodeFull(u.path);
  return decoded.contains('/$pathSegment/');
}

bool isValidHandwrittenExportUrl(String? raw) =>
    isValidFirebaseStorageExportUrl(raw, pathSegment: 'handwritten');
