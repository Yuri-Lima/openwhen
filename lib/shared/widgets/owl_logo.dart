import 'package:flutter/material.dart';

class OwlLogo extends StatelessWidget {
  final double size;
  const OwlLogo({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.75,
      child: CustomPaint(painter: _OwlLogoPainter()),
    );
  }
}

class _OwlLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Corpo do envelope
    final envPaint = Paint()..color = const Color(0xFF2C2420)..style = PaintingStyle.fill;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(w * 0.07));
    canvas.drawRRect(rrect, envPaint);

    // Bordas do envelope
    final borderPaint = Paint()..color = Colors.white.withOpacity(0.08)..style = PaintingStyle.stroke..strokeWidth = 0.8;
    canvas.drawRRect(rrect, borderPaint);

    // Aba superior
    final abaPath = Path()
      ..moveTo(0, 0)
      ..lineTo(w / 2, h * 0.52)
      ..lineTo(w, 0)
      ..close();
    canvas.drawPath(abaPath, Paint()..color = const Color(0xFF2A2520));

    // Aba inferior esquerda
    canvas.drawPath(
      Path()..moveTo(0, h)..lineTo(w / 2, h * 0.52)..lineTo(0, h * 0.2)..close(),
      Paint()..color = const Color(0xFF221E1A),
    );

    // Aba inferior direita
    canvas.drawPath(
      Path()..moveTo(w, h)..lineTo(w / 2, h * 0.52)..lineTo(w, h * 0.2)..close(),
      Paint()..color = const Color(0xFF1E1A16),
    );

    // Base inferior
    canvas.drawPath(
      Path()..moveTo(0, h)..lineTo(w / 2, h * 0.52)..lineTo(w, h)..close(),
      Paint()..color = const Color(0xFF252118),
    );

    // Linhas sutis
    final linePaint = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, 0), Offset(w / 2, h * 0.52), linePaint);
    canvas.drawLine(Offset(w, 0), Offset(w / 2, h * 0.52), linePaint);

    // Lacre vermelho
    final lacreCenter = Offset(w / 2, h * 0.52);
    final lacreRadius = w * 0.18;
    canvas.drawCircle(lacreCenter, lacreRadius, Paint()..color = const Color(0xFFC0392B));
    canvas.drawCircle(lacreCenter, lacreRadius * 0.85, Paint()..color = const Color(0xFFA93226));

    // Olhos da coruja no lacre
    final eyeRadius = lacreRadius * 0.28;
    final eyeY = lacreCenter.dy - lacreRadius * 0.05;
    final leftEye = Offset(lacreCenter.dx - lacreRadius * 0.38, eyeY);
    final rightEye = Offset(lacreCenter.dx + lacreRadius * 0.38, eyeY);

    for (final eye in [leftEye, rightEye]) {
      canvas.drawCircle(eye, eyeRadius, Paint()..color = Colors.white.withOpacity(0.9));
      canvas.drawCircle(eye, eyeRadius, Paint()..color = Colors.white.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 0.8);
      canvas.drawCircle(eye, eyeRadius * 0.45, Paint()..color = const Color(0xFFC0392B));
    }

    // Bico
    final bicoPath = Path()
      ..moveTo(lacreCenter.dx - lacreRadius * 0.12, lacreCenter.dy + lacreRadius * 0.15)
      ..lineTo(lacreCenter.dx, lacreCenter.dy + lacreRadius * 0.38)
      ..lineTo(lacreCenter.dx + lacreRadius * 0.12, lacreCenter.dy + lacreRadius * 0.15)
      ..close();
    canvas.drawPath(bicoPath, Paint()..color = Colors.white.withOpacity(0.45));

    // Plumas
    final plumaPaint = Paint()..color = Colors.white.withOpacity(0.22);
    canvas.drawPath(
      Path()..moveTo(leftEye.dx - eyeRadius, eyeY - eyeRadius)..lineTo(leftEye.dx - eyeRadius * 1.4, eyeY - eyeRadius * 2.2)..lineTo(leftEye.dx + eyeRadius * 0.2, eyeY - eyeRadius * 0.8)..close(),
      plumaPaint,
    );
    canvas.drawPath(
      Path()..moveTo(rightEye.dx + eyeRadius, eyeY - eyeRadius)..lineTo(rightEye.dx + eyeRadius * 1.4, eyeY - eyeRadius * 2.2)..lineTo(rightEye.dx - eyeRadius * 0.2, eyeY - eyeRadius * 0.8)..close(),
      plumaPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
