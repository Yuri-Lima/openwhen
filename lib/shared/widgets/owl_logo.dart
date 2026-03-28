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

/// Desenho compartilhado do lacre e da coruja (usado pelo logo estático e pela animação de abertura).
class OwlSealArt {
  OwlSealArt._();

  static void drawSealShadow(Canvas canvas, Offset center, double radius) {
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

  static void drawWaxSeal(Canvas canvas, Offset center, double radius) {
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

  /// [eyeLookX] ∈ [-1, 1] desloca as pupilas horizontalmente.
  /// [showEarTufts] / [showSidePlumes]: opcionais (default `true`); detalhe acima dos olhos é sempre desenhado.
  static void drawOwlFace(
    Canvas canvas,
    Offset lacreCenter,
    double lacreRadius, {
    double eyeLookX = 0,
    bool drawBeakAndPlumes = true,
    bool showEarTufts = true,
    bool showSidePlumes = true,
  }) {
    final eyeRadius = lacreRadius * 0.28;
    final eyeY = lacreCenter.dy - lacreRadius * 0.05;
    final leftEye = Offset(lacreCenter.dx - lacreRadius * 0.38, eyeY);
    final rightEye = Offset(lacreCenter.dx + lacreRadius * 0.38, eyeY);
    final pupilShift = Offset(eyeLookX * eyeRadius * 0.42, 0);

    if (drawBeakAndPlumes && showEarTufts) {
      _drawOwlEarTufts(canvas, lacreRadius, leftEye, rightEye, eyeY, eyeRadius);
    }

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
      _drawOwlEyeUpperRimAndLashes(canvas, eye, eyeRadius, eyeLookX);
      final pupilCenter = eye + pupilShift;
      final maxOff = eyeRadius * 0.52;
      final clamped = Offset(
        pupilCenter.dx.clamp(eye.dx - maxOff, eye.dx + maxOff),
        pupilCenter.dy.clamp(eye.dy - maxOff, eye.dy + maxOff),
      );
      canvas.drawCircle(clamped, eyeRadius * 0.45, Paint()..color = const Color(0xFF6E1810));
      canvas.drawCircle(
        clamped + Offset(-eyeRadius * 0.14, -eyeRadius * 0.12),
        eyeRadius * 0.14,
        Paint()..color = Colors.white.withOpacity(0.72),
      );
    }

    if (!drawBeakAndPlumes) return;

    final bicoPath = Path()
      ..moveTo(lacreCenter.dx - lacreRadius * 0.12, lacreCenter.dy + lacreRadius * 0.15)
      ..lineTo(lacreCenter.dx, lacreCenter.dy + lacreRadius * 0.38)
      ..lineTo(lacreCenter.dx + lacreRadius * 0.12, lacreCenter.dy + lacreRadius * 0.15)
      ..close();
    canvas.drawPath(bicoPath, Paint()..color = Colors.white.withOpacity(0.5));
    canvas.drawPath(
      bicoPath,
      Paint()
        ..color = Colors.black.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.35,
    );

    _drawOwlChestBib(canvas, lacreCenter, lacreRadius);

    if (showSidePlumes) {
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

    _drawOwlFeet(canvas, lacreCenter, lacreRadius);
  }

  /// Sobrancelha / pálpebra superior + cílios curtos (sempre visíveis no rosto).
  static void _drawOwlEyeUpperRimAndLashes(
    Canvas canvas,
    Offset eye,
    double eyeRadius,
    double eyeLookX,
  ) {
    final nudge = Offset(eyeLookX * eyeRadius * 0.06, 0);
    final c = eye + nudge;
    final r = eyeRadius;

    final rim = Paint()
      ..color = const Color(0xFF9A8478).withOpacity(0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.75, r * 0.1)
      ..strokeCap = StrokeCap.round;
    final oval = Rect.fromCircle(center: c, radius: r * 0.99);
    canvas.drawArc(oval, -math.pi / 2 - 0.62, 1.24, false, rim);

    final softRim = Paint()
      ..color = const Color(0xFFD4C4B8).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.45, r * 0.055)
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: c + Offset(0, -r * 0.04), radius: r * 0.92),
      -math.pi / 2 - 0.58,
      1.16,
      false,
      softRim,
    );

    final lash = Paint()
      ..color = const Color(0xFF6B5A52).withOpacity(0.4)
      ..strokeWidth = math.max(0.35, r * 0.045)
      ..strokeCap = StrokeCap.round;
    for (var i = -2; i <= 2; i++) {
      final t = i / 2.0;
      final sx = c.dx + t * r * 0.62;
      final sy = c.dy - r * 0.78;
      canvas.drawLine(
        Offset(sx, sy),
        Offset(sx + t * r * 0.06 + eyeLookX * r * 0.04, sy - r * 0.16),
        lash,
      );
    }
  }

  static void _drawOwlEarTufts(
    Canvas canvas,
    double r,
    Offset leftEye,
    Offset rightEye,
    double eyeY,
    double eyeRadius,
  ) {
    final tuft = Paint()..color = Colors.white.withOpacity(0.38);
    final stroke = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.35;

    void oneTuft(Offset base, double dir) {
      final p = Path()
        ..moveTo(base.dx, base.dy)
        ..lineTo(base.dx + dir * r * 0.22, base.dy - r * 0.52)
        ..lineTo(base.dx + dir * r * 0.42, base.dy - r * 0.18)
        ..close();
      canvas.drawPath(p, tuft);
      canvas.drawPath(p, stroke);
    }

    oneTuft(Offset(leftEye.dx - eyeRadius * 0.35, eyeY - eyeRadius * 0.75), -1);
    oneTuft(Offset(leftEye.dx + eyeRadius * 0.1, eyeY - eyeRadius * 0.88), -0.35);
    oneTuft(Offset(rightEye.dx + eyeRadius * 0.35, eyeY - eyeRadius * 0.75), 1);
    oneTuft(Offset(rightEye.dx - eyeRadius * 0.1, eyeY - eyeRadius * 0.88), 0.35);
  }

  static void _drawOwlChestBib(Canvas canvas, Offset c, double r) {
    final bib = Path()
      ..moveTo(c.dx - r * 0.22, c.dy + r * 0.12)
      ..quadraticBezierTo(c.dx, c.dy + r * 0.38, c.dx + r * 0.22, c.dy + r * 0.12)
      ..lineTo(c.dx + r * 0.14, c.dy + r * 0.02)
      ..quadraticBezierTo(c.dx, c.dy + r * 0.18, c.dx - r * 0.14, c.dy + r * 0.02)
      ..close();
    canvas.drawPath(
      bib,
      Paint()
        ..shader = ui.Gradient.radial(
          c + Offset(0, r * 0.18),
          r * 0.45,
          [
            Colors.white.withOpacity(0.22),
            Colors.white.withOpacity(0.05),
          ],
        ),
    );
  }

  static void _drawOwlFeet(Canvas canvas, Offset c, double r) {
    final claw = Paint()
      ..color = const Color(0xFF8E6E5A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.85, r * 0.065)
      ..strokeCap = StrokeCap.round;

    void foot(double sign) {
      final ox = c.dx + sign * r * 0.24;
      final baseY = c.dy + r * 0.7;
      for (final i in [-1.0, 0.0, 1.0]) {
        canvas.drawLine(
          Offset(ox + i * r * 0.05, baseY),
          Offset(ox + i * r * 0.09, baseY + r * 0.13),
          claw,
        );
      }
    }

    foot(-1);
    foot(1);
  }

  /// Asas e corpo acima do lacre; [reveal] 0→1 controla opacidade global desta camada.
  static void drawOwlWingsAndBody(Canvas canvas, Offset lacreCenter, double r, double reveal) {
    if (reveal <= 0.001) return;
    final a = reveal.clamp(0.0, 1.0);
    final bodyPaint = Paint()
      ..color = Color.lerp(const Color(0xFFEDE5D8), const Color(0xFFC4B8A8), 0.35)!
          .withOpacity(0.92 * a);
    final wingPaint = Paint()
      ..color = Colors.white.withOpacity(0.88 * a);

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(lacreCenter.dx, lacreCenter.dy - r * 1.05 * a),
        width: r * 1.15 * a,
        height: r * 1.35 * a,
      ),
      Radius.circular(r * 0.45 * a),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    final leftWing = Path()
      ..moveTo(lacreCenter.dx - r * 0.55 * a, lacreCenter.dy - r * 0.35 * a)
      ..quadraticBezierTo(
        lacreCenter.dx - r * 2.1 * a,
        lacreCenter.dy - r * 1.55 * a,
        lacreCenter.dx - r * 1.85 * a,
        lacreCenter.dy - r * 2.35 * a,
      )
      ..quadraticBezierTo(
        lacreCenter.dx - r * 0.95 * a,
        lacreCenter.dy - r * 1.65 * a,
        lacreCenter.dx - r * 0.45 * a,
        lacreCenter.dy - r * 0.85 * a,
      )
      ..close();
    canvas.drawPath(leftWing, wingPaint);

    final rightWing = Path()
      ..moveTo(lacreCenter.dx + r * 0.55 * a, lacreCenter.dy - r * 0.35 * a)
      ..quadraticBezierTo(
        lacreCenter.dx + r * 2.1 * a,
        lacreCenter.dy - r * 1.55 * a,
        lacreCenter.dx + r * 1.85 * a,
        lacreCenter.dy - r * 2.35 * a,
      )
      ..quadraticBezierTo(
        lacreCenter.dx + r * 0.95 * a,
        lacreCenter.dy - r * 1.65 * a,
        lacreCenter.dx + r * 0.45 * a,
        lacreCenter.dy - r * 0.85 * a,
      )
      ..close();
    canvas.drawPath(rightWing, wingPaint);

    final feather = Paint()
      ..color = Colors.black.withOpacity(0.1 * a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.35, r * 0.028);
    canvas.drawLine(
      Offset(lacreCenter.dx - r * 1.2 * a, lacreCenter.dy - r * 1.35 * a),
      Offset(lacreCenter.dx - r * 0.65 * a, lacreCenter.dy - r * 0.55 * a),
      feather,
    );
    canvas.drawLine(
      Offset(lacreCenter.dx + r * 1.2 * a, lacreCenter.dy - r * 1.35 * a),
      Offset(lacreCenter.dx + r * 0.65 * a, lacreCenter.dy - r * 0.55 * a),
      feather,
    );

    final stroke = Paint()
      ..color = Colors.black.withOpacity(0.12 * a)
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(0.5, r * 0.04);
    canvas.drawPath(leftWing, stroke);
    canvas.drawPath(rightWing, stroke);
  }
}

/// Lacre de cera + sombra (camada inferior da animação de abertura).
class OwlSealLayerPainter extends CustomPainter {
  OwlSealLayerPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = Offset(s / 2, s / 2);
    final radius = s * 0.38;
    OwlSealArt.drawSealShadow(canvas, center, radius);
    OwlSealArt.drawWaxSeal(canvas, center, radius);
  }

  @override
  bool shouldRepaint(covariant OwlSealLayerPainter oldDelegate) => false;
}

/// Corpo, asas e rosto completo da coruja (sem lacre). Desenhado acima do lacre.
/// [bodyReveal] só controla asas/corpo; rosto (tufts, penas laterais, detalhe acima dos olhos) é sempre completo.
class OwlSealFullOwlPainter extends CustomPainter {
  OwlSealFullOwlPainter({
    required this.eyeLookX,
    required this.bodyReveal,
  });

  final double eyeLookX;
  final double bodyReveal;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final center = Offset(s / 2, s / 2);
    final radius = s * 0.38;
    OwlSealArt.drawOwlWingsAndBody(canvas, center, radius, bodyReveal);
    OwlSealArt.drawOwlFace(canvas, center, radius, eyeLookX: eyeLookX);
  }

  @override
  bool shouldRepaint(covariant OwlSealFullOwlPainter oldDelegate) {
    return oldDelegate.eyeLookX != eyeLookX || oldDelegate.bodyReveal != bodyReveal;
  }
}

/// Mapeia [t] ∈ [0,1] (progresso do controller) para fases da animação de abertura.
class OwlSealOpeningPhase {
  const OwlSealOpeningPhase({
    required this.eyeLookX,
    required this.bodyReveal,
    required this.owlLayerOpacity,
    required this.flyDx,
    required this.flyDy,
    required this.flyRotation,
    required this.owlRestoreOpacity,
  });

  final double eyeLookX;
  final double bodyReveal;
  final double owlLayerOpacity;
  final double flyDx;
  final double flyDy;
  final double flyRotation;
  /// Rosto completo no lacre (sem asas) com fade suave após a pausa.
  final double owlRestoreOpacity;

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  static OwlSealOpeningPhase fromT(double t) {
    t = t.clamp(0.0, 1.0);

    double eyeLookX = 0;
    if (t < 0.07) {
      eyeLookX = _lerp(0, -1, t / 0.07);
    } else if (t < 0.15) {
      eyeLookX = _lerp(-1, 1, (t - 0.07) / 0.08);
    } else if (t < 0.20) {
      eyeLookX = _lerp(1, 0, (t - 0.15) / 0.05);
    }

    double bodyReveal = 0;
    if (t >= 0.20 && t < 0.42) {
      bodyReveal = Curves.easeOut.transform((t - 0.20) / 0.22);
    } else if (t >= 0.42) {
      bodyReveal = 1.0;
    }

    double flyK = 0;
    if (t >= 0.42 && t < 0.62) {
      flyK = Curves.easeInCubic.transform((t - 0.42) / 0.20);
    } else if (t >= 0.62) {
      flyK = 1.0;
    }

    final flyDx = -48 * flyK;
    final flyDy = -72 * flyK - 28 * flyK * flyK;
    final flyRotation = -0.42 * flyK;

    double owlLayerOpacity = 1.0;
    if (t >= 0.42 && t < 0.62) {
      owlLayerOpacity = 1.0 - Curves.easeIn.transform((t - 0.42) / 0.20);
    } else if (t >= 0.62 && t < 0.72) {
      owlLayerOpacity = 0;
    } else if (t >= 0.72) {
      owlLayerOpacity = 0;
    }

    double owlRestoreOpacity = 0;
    if (t >= 0.72) {
      final u = ((t - 0.72) / 0.28).clamp(0.0, 1.0);
      owlRestoreOpacity = Curves.easeOutCubic.transform(u);
    }

    return OwlSealOpeningPhase(
      eyeLookX: eyeLookX,
      bodyReveal: bodyReveal,
      owlLayerOpacity: owlLayerOpacity,
      flyDx: flyDx,
      flyDy: flyDy,
      flyRotation: flyRotation,
      owlRestoreOpacity: owlRestoreOpacity,
    );
  }
}

/// Selo com sequência de animação ao abrir a carta: olhos, asas, voo, lacre só, rosto completo de volta (sem asas).
class OwlSealOpeningAnimation extends StatelessWidget {
  const OwlSealOpeningAnimation({
    super.key,
    required this.size,
    required this.animation,
  });

  final double size;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, _) {
          final phase = OwlSealOpeningPhase.fromT(animation.value);
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: Size(size, size),
                painter: OwlSealLayerPainter(),
              ),
              if (phase.owlLayerOpacity > 0.001)
                Opacity(
                  opacity: phase.owlLayerOpacity,
                  child: Transform.translate(
                    offset: Offset(phase.flyDx, phase.flyDy),
                    child: Transform.rotate(
                      angle: phase.flyRotation,
                      child: CustomPaint(
                        size: Size(size, size),
                        painter: OwlSealFullOwlPainter(
                          eyeLookX: phase.eyeLookX,
                          bodyReveal: phase.bodyReveal,
                        ),
                      ),
                    ),
                  ),
                ),
              if (phase.owlRestoreOpacity > 0.001)
                Opacity(
                  opacity: phase.owlRestoreOpacity,
                  child: CustomPaint(
                    size: Size(size, size),
                    painter: OwlSealFullOwlPainter(
                      eyeLookX: 0,
                      bodyReveal: 0,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
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
      OwlSealArt.drawSealShadow(canvas, center, radius);
      OwlSealArt.drawWaxSeal(canvas, center, radius);
      OwlSealArt.drawOwlFace(canvas, center, radius);
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
    OwlSealArt.drawSealShadow(canvas, lacreCenter, lacreRadius);
    OwlSealArt.drawWaxSeal(canvas, lacreCenter, lacreRadius);
    OwlSealArt.drawOwlFace(canvas, lacreCenter, lacreRadius);
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

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    if (oldDelegate is! _OwlLogoPainter) return true;
    try {
      return oldDelegate.mode != mode;
    } catch (_) {
      return true;
    }
  }
}
