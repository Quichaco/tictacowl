import 'package:flutter/material.dart';

enum XoSymbolType { x, o }

class XoPainter extends CustomPainter {
  XoPainter({
    required this.type,
    required this.gradient,
    this.strokeWidthFactor = 0.15,
  });

  final XoSymbolType type;
  final LinearGradient gradient;
  final double strokeWidthFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final dimension = size.shortestSide;
    final strokeWidth = dimension * strokeWidthFactor;
    final drawSize = dimension - strokeWidth;

    final paint = Paint()
      ..shader = gradient.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: drawSize,
      height: drawSize,
    );

    if (type == XoSymbolType.x) {
      canvas.drawLine(rect.topLeft, rect.bottomRight, paint);
      canvas.drawLine(rect.topRight, rect.bottomLeft, paint);
    } else {
      canvas.drawCircle(rect.center, rect.width / 2, paint);
    }
  }

  @override
  bool shouldRepaint(XoPainter oldDelegate) =>
      type != oldDelegate.type ||
      gradient != oldDelegate.gradient ||
      strokeWidthFactor != oldDelegate.strokeWidthFactor;
}
