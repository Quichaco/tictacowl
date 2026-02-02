import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class GameCell extends StatelessWidget {
  const GameCell({
    required this.symbol,
    required this.isEmpty,
    required this.gradient,
    required this.onTap,
    super.key,
  });

  final String symbol;
  final bool isEmpty;
  final LinearGradient gradient;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return GestureDetector(
      onTap: isEmpty ? onTap : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth;
          final borderWidth = cellSize * AppBorder.cellFraction;

          return Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: AppRadius.card,
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: AnimatedOpacity(
                    duration: AppDurations.medium,
                    curve: Curves.easeOut,
                    opacity: isEmpty ? 0 : 1,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: gradient,
                        borderRadius: AppRadius.card,
                      ),
                      padding: EdgeInsets.all(borderWidth),
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(
                            AppRadius.md - borderWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: AnimatedSwitcher(
                    duration: AppDurations.medium,
                    switchInCurve: Curves.easeOut,
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: isEmpty
                        ? const SizedBox.shrink(key: ValueKey('empty'))
                        : GradientText(
                            symbol,
                            key: ValueKey(symbol),
                            style: context.textTheme.displayMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            gradient: gradient,
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
