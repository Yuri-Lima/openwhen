/// Validates a user-pasted music link: HTTPS only, no embedded scripts — opens externally.
bool isValidHttpsMusicUrl(String? raw) {
  if (raw == null) return false;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return false;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
  if (uri.scheme != 'https') return false;
  return true;
}
