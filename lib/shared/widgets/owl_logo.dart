import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

/// [fullEnvelope] — marca completa (envelope + lacre), ex.: login, splash.
/// [sealOnly] — só o lacre de cera com a coruja, ex.: abertura da carta (evita envelope duplicado).
enum OwlLogoMode { fullEnvelope, sealOnly }

class OwlLogo extends StatelessWidget {
  final double size;
  final OwlLogoMode mode;

  const OwlLogo({
    super.key,
    this.size = 56,
    this.mode = OwlLogoMode.fullEnvelope,
  });

  @override
  Widget build(BuildContext context) {
    if (mode == OwlLogoMode.sealOnly) {
      return SizedBox(
        width: size,
        height: size,
        child: CustomPaint(painter: _OwlLogoPainter(mode: mode)),
      );
    }
    return SizedBox(
      width: size,
      height: size * 0.75,
      child: CustomPaint(painter: _OwlLogoPainter(mode: mode)),
    );
  }
}

class _OwlLogoPainter extends CustomPainter {
  _OwlLogoPainter({required this.mode});

  final OwlLogoMode mode;

  @override
  void paint(Canvas canvas, Size size) {
    if (mode == OwlLogoMode.sealOnly) {
      final s = size.shortestSide;
      final center = Offset(s / 2, s / 2);
      final radius = s * 0.38;
      _drawSealShadow(canvas, center, radius);
      _drawWaxSeal(canvas, center, radius);
      _drawOwlFace(canvas, center, radius);
      return;
    }

    final w = size.width;
    final h = size.height;

    _drawEnvelopePaper(canvas, w, h);
    _drawEnvelopeFlaps(canvas, w, h);

    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset.zero, Offset(w / 2, h * 0.52), linePaint);
    canvas.drawLine(Offset(w, 0), Offset(w / 2, h * 0.52), linePaint);

    final lacreCenter = Offset(w / 2, h * 0.52);
    final lacreRadius = w * 0.18;
    _drawSealShadow(canvas, lacreCenter, lacreRadius);
    _drawWaxSeal(canvas, lacreCenter, lacreRadius);
    _drawOwlFace(canvas, lacreCenter, lacreRadius);
  }

  /// Papel do envelope: tons alinhados ao papel da carta (#F2E8D5) — família quente.
  void _drawEnvelopePaper(Canvas canvas, double w, double h) {
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, w, h),
      Radius.circular(w * 0.07),
    );
    final base = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, 0),
        Offset(w, h),
        [const Color(0xFF3A332D), const Color(0xFF2C2622)],
      );
    canvas.drawRRect(rrect, base);

    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    canvas.drawRRect(rrect, borderPaint);

    final linePaint = Paint()
      ..color = Colors.black.withOpacity(0.12)
      ..strokeWidth = 0.35;
    for (double y = 6; y < h - 4; y += 5.5) {
      canvas.drawLine(Offset(4, y), Offset(w - 4, y), linePaint);
    }
  }

  void _drawEnvelopeFlaps(Canvas canvas, double w, double h) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(w / 2, h * 0.52)
        ..lineTo(w, 0)
        ..close(),
      Paint()..color = const Color(0xFF383028),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h)
        ..lineTo(w / 2, h * 0.52)
        ..lineTo(0, h * 0.2)
        ..close(),
      Paint()..color = const Color(0xFF2E2820),
    );
    canvas.drawPath(
      Path()
        ..moveTo(w, h)
        ..lineTo(w / 2, h * 0.52)
        ..lineTo(w, h * 0.2)
        ..close(),
      Paint()..color = const Color(0xFF2A241C),
    );
    canvas.drawPath(
      Path()
        ..moveTo(0, h)
        ..lineTo(w / 2, h * 0.52)
        ..lineTo(w, h)
        ..close(),
      Paint()..color = const Color(0xFF322B24),
    );
  }

  void _drawSealShadow(Canvas canvas, Offset center, double radius) {
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.28)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(
        center: center + Offset(0, radius * 0.42),
        width: radius * 1.85,
        height: radius * 0.52,
      ),
      shadowPaint,
    );
  }

  void _drawWaxSeal(Canvas canvas, Offset center, double radius) {
    final wax = Paint()
      ..shader = ui.Gradient.radial(
        center + Offset(-radius * 0.15, -radius * 0.12),
        radius * 1.05,
        [
          const Color(0xFFE88878),
          const Color(0xFFC0392B),
          const Color(0xFF8E2318),
          const Color(0xFF5C150E),
        ],
        [0.0, 0.35, 0.72, 1.0],
      );
    canvas.drawCircle(center, radius, wax);

    final innerEdge = Paint()
      ..color = Colors.black.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.8, radius * 0.06);
    canvas.drawCircle(center, radius * 0.88, innerEdge);

    final highlight = Paint()
      ..shader = ui.Gradient.radial(
        center + Offset(-radius * 0.42, -radius * 0.38),
        radius * 0.55,
        [
          Colors.white.withOpacity(0.45),
          Colors.white.withOpacity(0.08),
          Colors.transparent,
        ],
        [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(center + Offset(-radius * 0.18, -radius * 0.15), radius * 0.65, highlight);

    final rim = Paint()
      ..color = Colors.white.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;
    canvas.drawCircle(center, radius * 0.995, rim);
  }

  void _drawOwlFace(Canvas canvas, Offset lacreCenter, double lacreRadius) {
    final eyeRadius = lacreRadius * 0.28;
    final eyeY = lacreCenter.dy - lacreRadius * 0.05;
    final leftEye = Offset(lacreCenter.dx - lacreRadius * 0.38, eyeY);
    final rightEye = Offset(lacreCenter.dx + lacreRadius * 0.38, eyeY);

    for (final eye in [leftEye, rightEye]) {
      canvas.drawCircle(eye, eyeRadius, Paint()..color = Colors.white.withOpacity(0.95));
      canvas.drawCircle(
        eye,
        eyeRadius,
        Paint()
          ..color = Colors.white.withOpacity(0.35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8,
      );
      canvas.drawCircle(eye, eyeRadius * 0.45, Paint()..color = const Color(0xFF6E1810));
    }

    final bicoPath = Path()
      ..moveTo(lacreCenter.dx - lacreRadius * 0.12, lacreCenter.dy + lacreRadius * 0.15)
      ..lineTo(lacreCenter.dx, lacreCenter.dy + lacreRadius * 0.38)
      ..lineTo(lacreCenter.dx + lacreRadius * 0.12, lacreCenter.dy + lacreRadius * 0.15)
      ..close();
    canvas.drawPath(bicoPath, Paint()..color = Colors.white.withOpacity(0.5));

    final plumaPaint = Paint()..color = Colors.white.withOpacity(0.26);
    canvas.drawPath(
      Path()
        ..moveTo(leftEye.dx - eyeRadius, eyeY - eyeRadius)
        ..lineTo(leftEye.dx - eyeRadius * 1.4, eyeY - eyeRadius * 2.2)
        ..lineTo(leftEye.dx + eyeRadius * 0.2, eyeY - eyeRadius * 0.8)
        ..close(),
      plumaPaint,
    );
    canvas.drawPath(
      Path()
        ..moveTo(rightEye.dx + eyeRadius, eyeY - eyeRadius)
        ..lineTo(rightEye.dx + eyeRadius * 1.4, eyeY - eyeRadius * 2.2)
        ..lineTo(rightEye.dx - eyeRadius * 0.2, eyeY - eyeRadius * 0.8)
        ..close(),
      plumaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _OwlLogoPainter) return true;
    try {
      return oldDelegate.mode != mode;
    } catch (_) {
      // Stale painter after hot reload can leave `mode` unreadable.
      return true;
    }
  }
}
