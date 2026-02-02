import 'package:flutter/material.dart';

class XoLoader extends StatelessWidget {
  const XoLoader({
    this.size = 20,
    this.strokeWidth = 2,
    this.color,
    super.key,
  });

  final double size;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}
