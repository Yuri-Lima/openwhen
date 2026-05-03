import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/whenote_palette.dart';
import '../widgets/owl_watermark.dart';
import 'story_share_content.dart';

/// Renders a 1080×1920 PNG for Instagram Stories (no message body — [StoryShareContent] only).
class StoryAssetBuilder {
  StoryAssetBuilder._();

  static const double _w = 1080;
  static const double _h = 1920;

  static Future<File?> buildPngFile({
    required BuildContext context,
    required StoryShareContent content,
  }) async {
    final palette = Theme.of(context).extension<WhenotePalette>();
    if (palette == null) return null;

    final completer = Completer<Uint8List?>();
    final key = GlobalKey();
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: -12000,
        top: 0,
        child: Material(
          color: Colors.transparent,
          child: RepaintBoundary(
            key: key,
            child: SizedBox(
              width: _w,
              height: _h,
              child: content.kind == StoryShareKind.paperLetter
                  ? _PaperLetterStoryTemplate(content: content, palette: palette)
                  : _StoryShareTemplate(content: content, palette: palette),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);

    void scheduleCapture() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          try {
            RenderRepaintBoundary? boundary =
                key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
            if (boundary == null) {
              debugPrint('[StoryAssetBuilder] boundary is null after 2 frames');
              completer.complete(null);
              return;
            }
            // Wait up to ~3 extra frames for pending paints (Impeller can be slower).
            for (int i = 0; i < 3 && boundary!.debugNeedsPaint; i++) {
              await Future<void>.delayed(const Duration(milliseconds: 32));
              boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
              if (boundary == null) {
                debugPrint('[StoryAssetBuilder] boundary lost during paint wait');
                completer.complete(null);
                return;
              }
            }
            final image = await boundary!.toImage(pixelRatio: 1.0);
            final bd = await image.toByteData(format: ui.ImageByteFormat.png);
            completer.complete(bd?.buffer.asUint8List());
          } catch (e) {
            // Complete with null instead of error so callers get a graceful fallback.
            debugPrint('[StoryAssetBuilder] toImage failed: $e');
            completer.complete(null);
          } finally {
            entry.remove();
          }
        });
      });
    }

    scheduleCapture();

    final bytes = await completer.future;
    if (bytes == null || bytes.isEmpty) return null;

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/whenote_story_${DateTime.now().millisecondsSinceEpoch}.png');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
}

class _StoryShareTemplate extends StatelessWidget {
  const _StoryShareTemplate({
    required this.content,
    required this.palette,
  });

  final StoryShareContent content;
  final WhenotePalette palette;

  @override
  Widget build(BuildContext context) {
    final g = palette.headerGradient;
    final gColors = g.length >= 2
        ? [g[0], g[1]]
        : <Color>[palette.bg, palette.card];

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gColors,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(72, 96, 72, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Whenote',
              style: GoogleFonts.dmSans(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
                color: palette.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: 48),
            Text(
              content.truncatedTitle,
              style: GoogleFonts.dmSerifDisplay(
                fontSize: 56,
                fontStyle: FontStyle.italic,
                color: palette.white,
                height: 1.15,
              ),
            ),
            if (content.dateSubtitle.isNotEmpty) ...[
              const SizedBox(height: 28),
              Text(
                content.dateSubtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  color: palette.white.withValues(alpha: 0.65),
                ),
              ),
            ],
            const Spacer(),
            Center(
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 32,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: QrImageView(
                  data: content.deepLink,
                  size: 300,
                  backgroundColor: Colors.white,
                  eyeStyle: QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: palette.accent,
                  ),
                  dataModuleStyle: QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: const Color(0xFF1A1714),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: Text(
                content.brandLine,
                style: GoogleFonts.dmSans(
                  fontSize: 26,
                  letterSpacing: 2,
                  color: palette.white.withValues(alpha: 0.45),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Template de Story com carta em papel + watermark ────────────────────
class _PaperLetterStoryTemplate extends StatelessWidget {
  const _PaperLetterStoryTemplate({
    required this.content,
    required this.palette,
  });

  final StoryShareContent content;
  final WhenotePalette palette;

  @override
  Widget build(BuildContext context) {
    final accentColor = palette.accent;

    return Container(
      width: 1080,
      height: 1920,
      color: const Color(0xFF0A0A08),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(48, 80, 48, 60),
        child: Column(
          children: [
            // ── Header: owl + Whenote ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OwlWatermark(
                  width: 40,
                  height: 48,
                  color: Colors.white,
                  opacity: 3.0,
                ),
                const SizedBox(width: 16),
                Text(
                  'Whenote',
                  style: GoogleFonts.dmSans(
                    fontSize: 36,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 4,
                    color: Colors.white.withOpacity(0.85),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 48),

            // ── Carta em papel ─────────────────────────────────────────
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF2E8D5),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.15),
                      blurRadius: 48,
                      spreadRadius: 4,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Barra colorida
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      ),
                    ),
                    // Conteúdo com linhas do papel
                    Expanded(
                      child: Stack(
                        children: [
                          // Linhas ruled
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _StoryPaperLinesPainter(),
                            ),
                          ),
                          // Texto da carta
                          Padding(
                            padding: const EdgeInsets.fromLTRB(72, 48, 48, 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // FROM
                                Text('A LETTER FROM',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 6,
                                    color: accentColor.withOpacity(0.8),
                                  )),
                                const SizedBox(height: 14),
                                // Sender name
                                Text(content.senderName ?? '',
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 36,
                                    color: const Color(0xFF160D04),
                                  )),
                                const SizedBox(height: 8),
                                // To: receiver
                                Text('To: ${content.receiverName ?? ''}',
                                  style: GoogleFonts.dmSans(
                                    fontSize: 22,
                                    fontStyle: FontStyle.italic,
                                    color: const Color(0xFF7A5C3A),
                                  )),
                                const SizedBox(height: 28),
                                // Divider
                                Container(width: 48, height: 2, color: accentColor.withOpacity(0.5)),
                                const SizedBox(height: 16),
                                // Title
                                Text(content.truncatedTitle,
                                  style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 30,
                                    color: const Color(0xFF160D04),
                                    fontStyle: FontStyle.italic,
                                  )),
                                const SizedBox(height: 24),
                                // Message (truncated)
                                Expanded(
                                  child: Text(content.message ?? '',
                                    overflow: TextOverflow.fade,
                                    style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 26,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF241608),
                                      height: 1.9,
                                    )),
                                ),
                                const SizedBox(height: 20),
                                // Signature
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('— ${content.senderName ?? ''}',
                                    style: GoogleFonts.dmSerifDisplay(
                                      fontSize: 26,
                                      fontStyle: FontStyle.italic,
                                      color: const Color(0xFF4A2E14),
                                    )),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),

            // ── QR code + branding ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: QrImageView(
                    data: content.deepLink,
                    size: 140,
                    backgroundColor: Colors.white,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: accentColor,
                    ),
                    dataModuleStyle: const QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: Color(0xFF1A1714),
                    ),
                  ),
                ),
                const SizedBox(width: 28),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      content.brandLine,
                      style: GoogleFonts.dmSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      content.dateSubtitle,
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.35),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StoryPaperLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final line = Paint()
      ..color = Colors.black.withOpacity(0.04)
      ..strokeWidth = 1.5;
    for (double y = 48; y < size.height; y += 48) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), line);
    }
    // Margem vermelha
    canvas.drawLine(
      const Offset(56, 0),
      Offset(56, size.height),
      Paint()
        ..color = const Color(0xFFC0392B).withOpacity(0.12)
        ..strokeWidth = 1.5,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
