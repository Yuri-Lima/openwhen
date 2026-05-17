import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../utils/sender_location.dart';
import '../../l10n/app_localizations.dart';

/// Dark card: tap copies Google Maps URL (letter/capsule detail).
class LocationShareTileDark extends StatelessWidget {
  final double lat;
  final double lng;

  const LocationShareTileDark({
    super.key,
    required this.lat,
    required this.lng,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () {
        copyLocationToClipboard(lat, lng);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.locationCopiedSnack)),
        );
        HapticFeedback.lightImpact();
      },
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
                color: context.pal.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: context.pal.accent.withOpacity(0.3)),
              ),
              child: Icon(Icons.location_on_outlined, size: 22, color: context.pal.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.locationShareTileTitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    l10n.locationShareTileSubtitle,
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.copy_rounded, color: Colors.white.withOpacity(0.35), size: 20),
          ],
        ),
      ),
    );
  }
}
