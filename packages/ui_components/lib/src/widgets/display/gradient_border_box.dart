import 'package:flutter/material.dart';
import 'package:ui_components/src/extensions/build_context_extensions.dart';

class GradientBorderBox extends StatelessWidget {
  const GradientBorderBox({
    required this.gradient,
    required this.borderWidthFraction,
    required this.borderRadius,
    required this.child,
    this.size,
    super.key,
  });

  final LinearGradient gradient;
  final double borderWidthFraction;
  final double borderRadius;
  final double? size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveSize = size ?? constraints.maxWidth;
        final borderWidth = effectiveSize * borderWidthFraction;

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.all(borderWidth),
          child: Container(
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainerLow,
              borderRadius:
                  BorderRadius.circular(borderRadius - borderWidth),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
