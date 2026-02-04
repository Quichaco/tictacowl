import 'package:flutter/material.dart';
import 'package:ui_components/src/painters/xo_painter.dart';

class XoSymbol extends StatelessWidget {
  const XoSymbol({
    required this.type,
    required this.gradient,
    this.strokeWidthFactor = 0.15,
    this.size,
    super.key,
  });

  const XoSymbol.x({
    required this.gradient,
    this.strokeWidthFactor = 0.15,
    this.size,
    super.key,
  }) : type = XoSymbolType.x;

  const XoSymbol.o({
    required this.gradient,
    this.strokeWidthFactor = 0.15,
    this.size,
    super.key,
  }) : type = XoSymbolType.o;

  final XoSymbolType type;
  final LinearGradient gradient;
  final double strokeWidthFactor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final painter = CustomPaint(
      painter: XoPainter(
        type: type,
        gradient: gradient,
        strokeWidthFactor: strokeWidthFactor,
      ),
    );

    if (size != null) {
      return SizedBox.square(
        dimension: size,
        child: painter,
      );
    }

    return SizedBox.expand(child: painter);
  }
}
