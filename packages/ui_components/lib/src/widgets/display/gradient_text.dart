import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.style,
    this.gradient,
    super.key,
  });

  final String text;
  final TextStyle style;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) =>
          (gradient ?? context.brand.actionGradient)
              .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
      child: Text(text, style: style),
    );
  }
}
