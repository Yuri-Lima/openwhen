import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';

/// Card misterioso para cartas seladas exibidas no perfil.
///
/// Não mostra remetente nem título — apenas badge de status,
/// barras de placeholder e countdown.
class SealedLetterCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const SealedLetterCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();

    final openDateRaw = data['openDate'];
    final openDate = openDateRaw is DateTime
        ? openDateRaw
        : (openDateRaw as dynamic).toDate() as DateTime;

    final now = DateTime.now();
    final canOpen = now.isAfter(openDate);

    return GestureDetector(
      onTap: () {
        final msg = canOpen
            ? l10n.profileSealedReady
            : l10n.profileSealedStill;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(msg,
                  style: GoogleFonts.dmSans(fontSize: 13)),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: context.pal.card,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: canOpen
                ? context.pal.accent.withValues(alpha:0.4)
                : context.pal.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Badge ──
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: canOpen
                    ? context.pal.accent.withValues(alpha:0.12)
                    : context.pal.bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                canOpen ? '✨ ${l10n.vaultStatusReady}' : '🔒 ${l10n.profileSealedLabel}',
                style: GoogleFonts.dmSans(
                  fontSize: 10,
                  color: canOpen ? context.pal.accent : context.pal.inkSoft,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 14),

            // ── Placeholder bars (hidden title) ──
            Container(
              width: 180,
              height: 14,
              decoration: BoxDecoration(
                color: context.pal.border.withValues(alpha:0.5),
                borderRadius: BorderRadius.circular(7),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 10,
              decoration: BoxDecoration(
                color: context.pal.border.withValues(alpha:0.3),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 16),

            // ── Countdown ──
            Text(
              _buildCountdownText(openDate, now, locale, l10n),
              style: GoogleFonts.dmSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: canOpen ? context.pal.accent : context.pal.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// "15 Jun 2026 (42 dias)" ou "Disponível para abrir!"
  String _buildCountdownText(
      DateTime openDate, DateTime now, String locale, AppLocalizations l10n) {
    if (now.isAfter(openDate)) {
      return l10n.profileSealedAvailable;
    }
    final diff = openDate.difference(now);
    final dateStr = DateFormat('d MMM yyyy', locale).format(openDate);
    if (diff.inDays > 0) {
      return '$dateStr (${l10n.vaultCountdownDays(diff.inDays)})';
    }
    if (diff.inHours > 0) {
      return '$dateStr (${l10n.vaultCountdownHours(diff.inHours)})';
    }
    return '$dateStr (${l10n.vaultCountdownMinutes(diff.inMinutes)})';
  }
}
