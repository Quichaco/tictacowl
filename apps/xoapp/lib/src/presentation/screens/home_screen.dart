import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:ui_components/ui_components.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/presentation/widgets/animated_xo_logo.dart';
import 'package:xoapp/src/routing/app_routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userAsync = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: XoAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: IconButton.filledTonal(
              onPressed: () => context.go(AppRoutes.settings),
              icon: const Icon(Icons.settings),
            ),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: userAsync.when(
          data: (user) {
            return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: AppSpacing.screenPadding,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FractionallySizedBox(
                              widthFactor: 0.7,
                              child: const AnimatedXoLogo(),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          if (user != null)
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: user.name,
                                    style: context.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      color: context.brand.secondaryGradient.colors.first,
                                    ),
                                  ),
                                  TextSpan(
                                    text: l10n.homeGreetingSuffix,
                                    style: context.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Text(
                              l10n.homeGreetingFallback,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.md,
                      bottom: AppSpacing.xs,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        l10n.gameModeLabel,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  const _DifficultyPicker(),
                  const SizedBox(height: AppSpacing.sm),
                  Padding(
                    padding: AppSpacing.screenPadding.copyWith(top: 0, bottom: 0),
                    child: Column(
                      children: [
                        const _RoundsSelector(),
                        const SizedBox(height: AppSpacing.md),
                        GradientButton(
                          onPressed: () => context.go(AppRoutes.game),
                          icon: Icons.play_arrow,
                          label: l10n.playButton,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text(l10n.genericError)),
        ),
      ),
    );
  }
}

class _DifficultyPicker extends ConsumerWidget {
  const _DifficultyPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final difficulty = ref.watch(
      gameConfigViewModelProvider.select((c) => c.difficulty),
    );

    return DifficultyCarousel(
      selected: difficulty,
      assetPath: (d) => d.theme.owlImage,
      onChanged: (d) =>
          ref.read(gameConfigViewModelProvider.notifier).setDifficulty(d),
    );
  }
}

class _RoundsSelector extends ConsumerWidget {
  const _RoundsSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rounds = ref.watch(
      gameConfigViewModelProvider.select((c) => c.rounds),
    );

    return RoundCounter(
      value: rounds,
      min: GameConfig.minRounds,
      max: GameConfig.maxRounds,
      labelOf: (count) => context.l10n.roundsLabel(count),
      onChanged: (r) =>
          ref.read(gameConfigViewModelProvider.notifier).setRounds(r),
    );
  }
}

