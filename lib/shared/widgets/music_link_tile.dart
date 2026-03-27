import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../utils/music_url.dart';

/// Opens [url] in the system browser or native app (Spotify, etc.).
Future<void> launchExternalMusicUrl(BuildContext context, String urlString) async {
  final l10n = AppLocalizations.of(context)!;
  final trimmed = urlString.trim();
  if (!isValidHttpsMusicUrl(trimmed)) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(l10n.musicLinkOpenError)),
    );
    return;
  }
  final uri = Uri.parse(trimmed);
  try {
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.musicLinkOpenError)));
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.musicLinkOpenError)));
    }
  }
}

/// Dark-themed row (letter/capsule detail & opening).
class MusicLinkTileDark extends StatelessWidget {
  final String url;

  const MusicLinkTileDark({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = context.pal.accent;
    return GestureDetector(
      onTap: () => launchExternalMusicUrl(context, url),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1714),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accentColor.withOpacity(0.35)),
              ),
              child: Icon(Icons.music_note_rounded, size: 22, color: accentColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.musicLinkTitle,
                    style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    l10n.musicLinkSubtitle,
                    style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.4)),
                  ),
                ],
              ),
            ),
            Icon(Icons.open_in_new_rounded, color: Colors.white.withOpacity(0.35), size: 20),
          ],
        ),
      ),
    );
  }
}
