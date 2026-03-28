import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/utils/date_formatter.dart';
import '../../../../shared/utils/music_url.dart';
import '../../../../shared/utils/voice_url.dart';
import '../../../../shared/widgets/music_link_tile.dart';
import '../../../../shared/widgets/voice_letter_tile.dart';
import '../../../../shared/widgets/location_share_tile.dart';
import '../../../../shared/utils/sender_location.dart';
import 'qr_code_screen.dart';

class LetterDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;
  final String docId;

  const LetterDetailScreen({super.key, required this.data, required this.docId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final openedAt = data['openedAt'] != null
        ? (data['openedAt'] as Timestamp).toDate()
        : DateTime.now();
    final createdAt = data['createdAt'] != null
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();
    final openDate = data['openDate'] != null
        ? (data['openDate'] as Timestamp).toDate()
        : DateTime.now();
    final musicUrl = data['musicUrl'] as String?;
    final showMusicLink = isValidHttpsMusicUrl(musicUrl);
    final voiceUrl = data['voiceUrl'] as String?;
    final showVoice = isValidVoiceLetterUrl(voiceUrl);
    final senderLoc = parseSenderLocationData(data['senderLocation']);

    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: context.pal.headerGradient,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.arrow_back, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(data['title'] ?? '',
                        style: GoogleFonts.dmSerifDisplay(fontSize: 18, color: context.pal.white, fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (_) => QrCodeScreen(
                          docId: docId,
                          title: data['title'] ?? '',
                          senderName: data['senderName'] ?? '',
                          openDate: openDate,
                        ),
                      )),
                      child: Container(
                        width: 36, height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.qr_code, size: 18, color: Colors.white.withOpacity(0.6)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2E8D5),
                      borderRadius: BorderRadius.circular(4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 32, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 5,
                          decoration: BoxDecoration(
                            color: context.pal.accent,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          ),
                        ),
                        Stack(
                          children: [
                            CustomPaint(
                              size: Size(MediaQuery.of(context).size.width - 32, 600),
                              painter: _PaperLinesPainter(),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(48, 32, 24, 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(l10n.letterDetailHeaderFrom,
                                    style: TextStyle(fontSize: 9, letterSpacing: 4, color: context.pal.accent.withOpacity(0.8))),
                                  const SizedBox(height: 8),
                                  Text(data['senderName'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 22, color: const Color(0xFF160D04))),
                                  const SizedBox(height: 4),
                                  Text(l10n.letterDetailTo(data['receiverName'] ?? ''),
                                    style: GoogleFonts.dmSans(fontSize: 12, fontStyle: FontStyle.italic, color: const Color(0xFF7A5C3A))),
                                  const SizedBox(height: 20),
                                  Container(width: 32, height: 1, color: context.pal.accent.withOpacity(0.4)),
                                  const SizedBox(height: 12),
                                  Text(data['title'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 20, color: const Color(0xFF160D04), fontStyle: FontStyle.italic)),
                                  const SizedBox(height: 20),
                                  Text(data['message'] ?? '',
                                    style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF241608), height: 2.0)),
                                  const SizedBox(height: 32),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text('— ${data['senderName'] ?? ''}',
                                          style: GoogleFonts.dmSerifDisplay(fontSize: 16, fontStyle: FontStyle.italic, color: const Color(0xFF4A2E14))),
                                        const SizedBox(height: 4),
                                        Text(l10n.letterDetailWrittenOn(formatShortDate(createdAt, locale)),
                                          style: TextStyle(fontSize: 9, letterSpacing: 2, color: context.pal.accent.withOpacity(0.5))),
                                        Text(l10n.letterDetailOpenedOn(formatShortDate(openedAt, locale)),
                                          style: TextStyle(fontSize: 9, letterSpacing: 2, color: context.pal.accent.withOpacity(0.5))),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: Column(
                      children: [
                        if (showMusicLink) ...[
                          MusicLinkTileDark(url: musicUrl!.trim()),
                          const SizedBox(height: 12),
                        ],
                        if (showVoice) ...[
                          VoiceLetterTileDark(url: voiceUrl!.trim()),
                          const SizedBox(height: 12),
                        ],
                        if (senderLoc != null) ...[
                          LocationShareTileDark(lat: senderLoc.lat, lng: senderLoc.lng),
                          const SizedBox(height: 12),
                        ],
                        GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(
                            builder: (_) => QrCodeScreen(
                              docId: docId,
                              title: data['title'] ?? '',
                              senderName: data['senderName'] ?? '',
                              openDate: openDate,
                            ),
                          )),
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
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: context.pal.accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: context.pal.accent.withOpacity(0.3)),
                                  ),
                                  child: Icon(Icons.qr_code, size: 22, color: context.pal.accent),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.letterDetailQrTitle,
                                        style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
                                      Text(l10n.letterDetailQrSubtitle,
                                        style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.4))),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        GestureDetector(
                          onTap: () {},
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
                                  width: 44, height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                                  ),
                                  child: Icon(Icons.share_outlined, size: 22, color: Colors.white.withOpacity(0.5)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(l10n.letterDetailShareTitle,
                                        style: GoogleFonts.dmSans(fontSize: 14, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
                                      Text(l10n.letterDetailShareSubtitle,
                                        style: GoogleFonts.dmSans(fontSize: 12, color: Colors.white.withOpacity(0.3))),
                                    ],
                                  ),
                                ),
                                Icon(Icons.chevron_right, color: Colors.white.withOpacity(0.3)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black.withOpacity(0.04)..strokeWidth = 1;
    for (double y = 28; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    canvas.drawLine(const Offset(36, 0), Offset(36, size.height),
      Paint()..color = const Color(0xFFC0392B).withOpacity(0.12)..strokeWidth = 1);
  }
  @override
  bool shouldRepaint(_) => false;
}
