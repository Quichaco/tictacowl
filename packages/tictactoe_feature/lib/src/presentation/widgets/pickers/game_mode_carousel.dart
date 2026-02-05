import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/build_context_extensions.dart';
import 'package:tictactoe_feature/src/common/models/game_mode_theme.dart';
import 'package:ui_components/ui_components.dart';

class GameModeCarousel extends HookWidget {
  const GameModeCarousel({
    required this.selected,
    required this.onChanged,
    required this.assetPath,
    super.key,
  });

  final GameMode selected;
  final ValueChanged<GameMode> onChanged;
  final String Function(GameMode) assetPath;

  @override
  Widget build(BuildContext context) {
    final pageController = usePageController(
      initialPage: GameMode.values.indexOf(selected),
    );

    useEffect(() {
      final targetPage = GameMode.values.indexOf(selected);
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
        AspectRatio(
          aspectRatio: 3,
          child: PageView.builder(
            controller: pageController,
            itemCount: GameMode.values.length,
            onPageChanged: (index) => onChanged(GameMode.values[index]),
            itemBuilder: (context, index) {
              final mode = GameMode.values[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: _GameModePage(
                  mode: mode,
                  assetPath: assetPath(mode),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        _PageIndicator(
          count: GameMode.values.length,
          selected: GameMode.values.indexOf(selected),
        ),
      ],
    );
  }
}

class _GameModePage extends StatelessWidget {
  const _GameModePage({
    required this.mode,
    required this.assetPath,
  });

  final GameMode mode;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = mode.theme;
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
            flex: 2,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          theme.title(l10n),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          theme.subtitle(l10n),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withAlpha(200),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (theme.difficultyLevel != null)
                          _DifficultyIndicator(level: theme.difficultyLevel!),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Image.asset(
              assetPath,
              fit: BoxFit.contain,
            ),
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
      children: List.generate(GameModeTheme.maxDifficultyLevel, (index) {
        final isActive = index < level;
        return Padding(
          padding: EdgeInsets.only(right: index < 2 ? AppSpacing.xxs : 0),
          child: Icon(
            Icons.local_fire_department,
            size: 18,
            color: isActive ? Colors.white : Colors.white.withAlpha(80),
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
