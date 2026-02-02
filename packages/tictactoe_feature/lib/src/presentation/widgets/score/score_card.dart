import 'package:flutter/material.dart';
import 'package:ui_components/ui_components.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({
    required this.symbol,
    required this.name,
    required this.score,
    required this.gradient,
    required this.isActive,
    super.key,
  });

  final String symbol;
  final String name;
  final int score;
  final LinearGradient gradient;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              borderRadius: AppRadius.card,
            ),
          ),
        ),
        Positioned.fill(
          child: AnimatedOpacity(
            duration: AppDurations.fast,
            curve: Curves.easeOut,
            opacity: isActive ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: AppRadius.card,
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: AppDurations.fast,
          margin: const EdgeInsets.all(AppBorder.cardWidth),
          padding: const EdgeInsets.all(AppSpacing.xs),
          decoration: isActive
              ? BoxDecoration(
                  color: colors.surface.withAlpha(200),
                  borderRadius: AppRadius.card,
                )
              : BoxDecoration(
                  color: colors.surfaceContainerLow,
                  borderRadius: AppRadius.card,
                ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '$score',
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              GradientBorderBox(
                gradient: gradient,
                borderWidthFraction: AppBorder.symbolBoxFraction,
                borderRadius: AppRadius.sm,
                size: AppBorder.symbolBoxSize,
                child: Center(
                  child: GradientText(
                    symbol,
                    style: context.textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    gradient: gradient,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
