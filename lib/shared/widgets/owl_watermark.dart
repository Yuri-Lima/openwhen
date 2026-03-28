import 'package:flutter/material.dart';

class OwlWatermark extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  /// Multiplies internal layer opacities (e.g. 2.2 on dark headers for visibility). Clamped 0–1 per layer.
  final double opacity;

  const OwlWatermark({
    super.key,
    this.width = 28,
    this.height = 34,
    this.color = Colors.white,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: _OwlPainter(color: color, opacity: opacity)),
    );
  }
}

class _OwlPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _OwlPainter({required this.color, this.opacity = 1.0});

  double _o(double base) => (base * opacity).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    canvas.drawOval(Rect.fromLTWH(w*0.1,h*0.28,w*0.8,h*0.62),
      Paint()..color = color.withOpacity(_o(0.06)));

    final lw = Path()
      ..moveTo(w*0.10,h*0.42)..quadraticBezierTo(0,h*0.65,w*0.08,h*0.82)
      ..quadraticBezierTo(w*0.18,h*0.70,w*0.22,h*0.55)..close();
    canvas.drawPath(lw, Paint()..color = color.withOpacity(_o(0.05)));

    final rw = Path()
      ..moveTo(w*0.90,h*0.42)..quadraticBezierTo(w,h*0.65,w*0.92,h*0.82)
      ..quadraticBezierTo(w*0.82,h*0.70,w*0.78,h*0.55)..close();
    canvas.drawPath(rw, Paint()..color = color.withOpacity(_o(0.05)));

    final le = Path()
      ..moveTo(w*0.25,h*0.28)..lineTo(w*0.20,h*0.10)..lineTo(w*0.35,h*0.22)..close();
    canvas.drawPath(le, Paint()..color = color.withOpacity(_o(0.08)));

    final re = Path()
      ..moveTo(w*0.75,h*0.28)..lineTo(w*0.80,h*0.10)..lineTo(w*0.65,h*0.22)..close();
    canvas.drawPath(re, Paint()..color = color.withOpacity(_o(0.08)));

    final bico = Path()
      ..moveTo(w*0.42,h*0.46)..lineTo(w*0.50,h*0.54)..lineTo(w*0.58,h*0.46)..close();
    canvas.drawPath(bico, Paint()..color = color.withOpacity(_o(0.07)));

    final pp = Paint()..color = color.withOpacity(_o(0.05))..strokeWidth = 1.2
      ..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(w*0.35,h*0.90),Offset(w*0.28,h*1.0),pp);
    canvas.drawLine(Offset(w*0.35,h*0.90),Offset(w*0.35,h*1.0),pp);
    canvas.drawLine(Offset(w*0.35,h*0.90),Offset(w*0.42,h*1.0),pp);
    canvas.drawLine(Offset(w*0.65,h*0.90),Offset(w*0.58,h*1.0),pp);
    canvas.drawLine(Offset(w*0.65,h*0.90),Offset(w*0.65,h*1.0),pp);
    canvas.drawLine(Offset(w*0.65,h*0.90),Offset(w*0.72,h*1.0),pp);

    for (final cx in [0.33, 0.67]) {
      final c = Offset(w*cx, h*0.36);
      final r = w*0.155;
      canvas.drawCircle(c, r, Paint()..color = color.withOpacity(_o(0.22)));
      canvas.drawCircle(c, r, Paint()
        ..color = color.withOpacity(_o(0.15))
        ..style = PaintingStyle.stroke..strokeWidth = 1.0);
      canvas.drawCircle(c, r*0.45, Paint()..color = color.withOpacity(_o(0.10)));
    }
  }

  @override
  bool shouldRepaint(_OwlPainter old) => old.color != color || old.opacity != opacity;
}
