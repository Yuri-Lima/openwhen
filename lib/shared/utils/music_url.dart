/// Known hosts for optional music / podcast links (letters & capsules; export).
const _musicLinkHostSuffixes = <String>[
  'spotify.com',
  'music.youtube.com',
  'youtube.com',
  'youtu.be',
  'music.apple.com',
  'itunes.apple.com',
  'podcasts.apple.com',
  'deezer.com',
  'deezer.page.link',
  'bandcamp.com',
  'soundcloud.com',
  'tidal.com',
  'napster.com',
];

bool _hostMatchesMusicAllowlist(String host) {
  final h = host.toLowerCase();
  for (final s in _musicLinkHostSuffixes) {
    if (h == s || h.endsWith('.$s')) return true;
  }
  return false;
}

/// Validates a user-pasted music link: HTTPS, host allowlist — opens externally.
bool isValidHttpsMusicUrl(String? raw) {
  if (raw == null) return false;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return false;
  final uri = Uri.tryParse(trimmed);
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) return false;
  if (uri.scheme != 'https') return false;
  return _hostMatchesMusicAllowlist(uri.host);
}
