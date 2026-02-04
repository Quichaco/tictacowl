import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/build_context_extensions.dart';
import 'package:tictactoe_feature/src/common/models/difficulty_theme.dart';
import 'package:ui_components/ui_components.dart';

class DifficultyCarousel extends HookWidget {
  const DifficultyCarousel({
    required this.selected,
    required this.onChanged,
    required this.assetPath,
    super.key,
  });

  final Difficulty selected;
  final ValueChanged<Difficulty> onChanged;
  final String Function(Difficulty) assetPath;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(
      initialPage: Difficulty.values.indexOf(selected),
    );

    useEffect(() {
      final targetPage = Difficulty.values.indexOf(selected);
      if (pageController.hasClients &&
          pageController.page?.round() != targetPage) {
        pageController.animateToPage(
          targetPage,
          duration: AppDurations.medium,
          curve: Curves.easeInOut,
        );
      }
      return null;
    }, [selected]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
            controller: pageController,
            itemCount: Difficulty.values.length,
            onPageChanged: (index) => onChanged(Difficulty.values[index]),
            itemBuilder: (context, index) {
              final difficulty = Difficulty.values[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _DifficultyPage(
                  difficulty: difficulty,
                  assetPath: assetPath(difficulty),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        _PageIndicator(
          count: Difficulty.values.length,
          selected: Difficulty.values.indexOf(selected),
        ),
      ],
    );
  }
}

class _DifficultyPage extends StatelessWidget {
  const _DifficultyPage({
    required this.difficulty,
    required this.assetPath,
  });

  final Difficulty difficulty;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = difficulty.theme;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        gradient: theme.gradient(context.brand),
        borderRadius: AppRadius.card,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  theme.title(l10n),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  theme.subtitle(l10n),
                  style: context.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withAlpha(200),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                _DifficultyIndicator(level: difficulty.index + 1),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Image.asset(
            assetPath,
            height: 80,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}

class _DifficultyIndicator extends StatelessWidget {
  const _DifficultyIndicator({required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        final isActive = index < level;
        return Container(
          margin: EdgeInsets.only(right: index < 2 ? AppSpacing.xxs : 0),
          width: 24,
          height: 5,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withAlpha(80),
            borderRadius: BorderRadius.circular(2.5),
          ),
        );
      }),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({
    required this.count,
    required this.selected,
  });

  final int count;
  final int selected;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == selected;
        return AnimatedContainer(
          duration: AppDurations.fast,
          margin: EdgeInsets.only(right: index < count - 1 ? AppSpacing.xs : 0),
          width: isActive ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: isActive
                ? context.colorScheme.primary
                : context.colorScheme.outline,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
