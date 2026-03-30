import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../theme/open_when_palette.dart';
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
    final palette = Theme.of(context).extension<OpenWhenPalette>();
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
              child: _StoryShareTemplate(content: content, palette: palette),
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
              completer.complete(null);
              return;
            }
            if (boundary.debugNeedsPaint) {
              await Future<void>.delayed(const Duration(milliseconds: 32));
              boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
            }
            if (boundary == null) {
              completer.complete(null);
              return;
            }
            final image = await boundary.toImage(pixelRatio: 1.0);
            final bd = await image.toByteData(format: ui.ImageByteFormat.png);
            completer.complete(bd?.buffer.asUint8List());
          } catch (e, st) {
            completer.completeError(e, st);
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
    final file = File('${dir.path}/openwhen_story_${DateTime.now().millisecondsSinceEpoch}.png');
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
  final OpenWhenPalette palette;

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
              'OpenWhen',
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
