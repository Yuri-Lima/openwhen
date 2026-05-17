import 'package:flutter/material.dart';

class OwlLogoThemed extends StatelessWidget {
  final double size;
  final Color color;

  const OwlLogoThemed({
    super.key,
    this.size = 56,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.75,
      child: CustomPaint(painter: _OwlLogoThemedPainter(color: color)),
    );
  }
}

class _OwlLogoThemedPainter extends CustomPainter {
  final Color color;
  _OwlLogoThemedPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Envelope da cor do tema — muito suave
    final envColor = Color.fromARGB(
      255,
      (255 - (255 - color.red) * 0.15).round(),
      (255 - (255 - color.green) * 0.15).round(),
      (255 - (255 - color.blue) * 0.15).round(),
    );
    final envDark = Color.fromARGB(
      255,
      (255 - (255 - color.red) * 0.22).round(),
      (255 - (255 - color.green) * 0.22).round(),
      (255 - (255 - color.blue) * 0.22).round(),
    );

    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, w, h), Radius.circular(w * 0.07));
    canvas.drawRRect(rrect, Paint()..color = envColor);
    canvas.drawRRect(rrect, Paint()
      ..color = color.withOpacity(0.20)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8);

    // Abas com variações sutis da cor
    canvas.drawPath(Path()..moveTo(0,0)..lineTo(w/2,h*0.52)..lineTo(w,0)..close(), Paint()..color = envDark);
    canvas.drawPath(Path()..moveTo(0,h)..lineTo(w/2,h*0.52)..lineTo(0,h*0.2)..close(), Paint()..color = envDark.withOpacity(0.85));
    canvas.drawPath(Path()..moveTo(w,h)..lineTo(w/2,h*0.52)..lineTo(w,h*0.2)..close(), Paint()..color = envDark.withOpacity(0.80));
    canvas.drawPath(Path()..moveTo(0,h)..lineTo(w/2,h*0.52)..lineTo(w,h)..close(), Paint()..color = envDark.withOpacity(0.90));

    // Linhas sutis
    final lp = Paint()..color = color.withOpacity(0.12)..strokeWidth = 0.5..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0,0), Offset(w/2,h*0.52), lp);
    canvas.drawLine(Offset(w,0), Offset(w/2,h*0.52), lp);

    // Lacre branco/creme — elegante em qualquer cor de envelope
    final lacreCenter = Offset(w/2, h*0.52);
    final lacreRadius = w * 0.18;
    canvas.drawCircle(lacreCenter, lacreRadius, Paint()..color = const Color(0xFFC9A84C));
    canvas.drawCircle(lacreCenter, lacreRadius, Paint()
      ..color = const Color(0xFFB8943E).withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8);
    canvas.drawCircle(lacreCenter, lacreRadius * 0.85, Paint()..color = const Color(0xFFB8943E));

    // Olhos da coruja — cor do tema
    final eyeRadius = lacreRadius * 0.28;
    final eyeY = lacreCenter.dy - lacreRadius * 0.05;
    for (final eyeX in [lacreCenter.dx - lacreRadius*0.38, lacreCenter.dx + lacreRadius*0.38]) {
      final eye = Offset(eyeX, eyeY);
      canvas.drawCircle(eye, eyeRadius, Paint()..color = Colors.white.withOpacity(0.9));
      canvas.drawCircle(eye, eyeRadius, Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.8);
      canvas.drawCircle(eye, eyeRadius * 0.5, Paint()..color = const Color(0xFFB8943E));
    }

    // Bico — cor do tema suave
    canvas.drawPath(
      Path()
        ..moveTo(lacreCenter.dx - lacreRadius*0.12, lacreCenter.dy + lacreRadius*0.15)
        ..lineTo(lacreCenter.dx, lacreCenter.dy + lacreRadius*0.38)
        ..lineTo(lacreCenter.dx + lacreRadius*0.12, lacreCenter.dy + lacreRadius*0.15)
        ..close(),
      Paint()..color = Colors.white.withOpacity(0.5),
    );

    // Plumas — cor do tema suave
    final pp = Paint()..color = Colors.white.withOpacity(0.3);
    final leftEye = Offset(lacreCenter.dx - lacreRadius*0.38, eyeY);
    final rightEye = Offset(lacreCenter.dx + lacreRadius*0.38, eyeY);
    canvas.drawPath(
      Path()..moveTo(leftEye.dx-eyeRadius, eyeY-eyeRadius)..lineTo(leftEye.dx-eyeRadius*1.4, eyeY-eyeRadius*2.2)..lineTo(leftEye.dx+eyeRadius*0.2, eyeY-eyeRadius*0.8)..close(),
      pp,
    );
    canvas.drawPath(
      Path()..moveTo(rightEye.dx+eyeRadius, eyeY-eyeRadius)..lineTo(rightEye.dx+eyeRadius*1.4, eyeY-eyeRadius*2.2)..lineTo(rightEye.dx-eyeRadius*0.2, eyeY-eyeRadius*0.8)..close(),
      pp,
    );
  }

  @override
  bool shouldRepaint(_OwlLogoThemedPainter old) => old.color != color;
}

// Cores prontas para usar
class OwlLogoColors {
  // Cartas — estados emocionais
  static const love         = Color(0xFFE91E8C);
  static const achievement  = Color(0xFFF59E0B);
  static const advice       = Color(0xFF10B981);
  static const nostalgia    = Color(0xFFD97706);
  static const farewell     = Color(0xFF8B5CF6);

  // Cápsulas — temas
  static const memories     = Color(0xFF6B6560);
  static const goals        = Color(0xFFC0392B);
  static const feelings     = Color(0xFFC9A84C);
  static const relationships= Color(0xFF5B8DB8);
  static const growth       = Color(0xFF4A8C6F);
}
