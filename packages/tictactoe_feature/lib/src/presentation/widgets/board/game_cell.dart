import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui_components/ui_components.dart';

class GameCell extends StatelessWidget {
  const GameCell({
    required this.symbolType,
    required this.isEmpty,
    required this.gradient,
    required this.onTap,
    this.isWinning = false,
    super.key,
  });

  final XoSymbolType symbolType;
  final bool isEmpty;
  final LinearGradient gradient;
  final VoidCallback onTap;
  final bool isWinning;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return GestureDetector(
      onTap: isEmpty ? onTap : null,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellSize = constraints.maxWidth;

          const borderWidth = 3.0;
          final innerRadius = BorderRadius.circular(AppRadius.md - borderWidth);

          return AnimatedContainer(
            duration: AppDurations.medium,
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: AppRadius.card,
              border: isWinning
                  ? Border.all(
                      color: context.brand.gold,
                      width: borderWidth,
                    )
                  : null,
            ),
            child: ClipRRect(
              borderRadius: isWinning ? innerRadius : AppRadius.card,
              child: Stack(
                children: [
                  if (isWinning)
                    Positioned.fill(
                      child: _GoldShimmer(),
                    ),
                Center(
                  child: AnimatedSwitcher(
                    duration: AppDurations.extraSlow,
                    transitionBuilder: (child, animation) {
                      final curvedAnimation = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      );
                      return ScaleTransition(
                        scale: curvedAnimation,
                        child: RotationTransition(
                          turns: Tween<double>(begin: -0.25, end: 0.0)
                              .animate(curvedAnimation),
                          child: child,
                        ),
                      );
                    },
                    child: isEmpty
                        ? const SizedBox.shrink(key: ValueKey('empty'))
                        : Padding(
                            key: ValueKey(symbolType),
                            padding: EdgeInsets.all(cellSize * 0.2),
                            child: XoSymbol(
                              type: symbolType,
                              gradient: gradient,
                            ),
                          ),
                  ),
                ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GoldShimmer extends HookWidget {
  const _GoldShimmer();

  @override
  Widget build(BuildContext context) {
    final controller = useAnimationController(
      duration: const Duration(milliseconds: 1200),
    );

    final animation = useMemoized(
      () => Tween<double>(begin: 0.1, end: 0.4).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeInOut),
      ),
      [controller],
    );

    useEffect(() {
      controller.repeat(reverse: true);
      return null;
    }, []);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ColoredBox(
          color: context.brand.gold.withValues(alpha: animation.value),
        );
      },
    );
  }
}
