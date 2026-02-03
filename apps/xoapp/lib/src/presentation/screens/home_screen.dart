import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_feature/tictactoe_feature.dart';
import 'package:ui_components/ui_components.dart';
import 'package:xoapp/src/common/extensions/build_context_extensions.dart';
import 'package:xoapp/src/routing/app_routes.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final userAsync = ref.watch(userViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: userAsync.when(
            data: (user) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  GradientText(
                    l10n.appTitle,
                    style: context.textTheme.headlineLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    user != null
                        ? l10n.homeGreeting(user.name)
                        : l10n.homeGreetingFallback,
                    style: context.textTheme.titleMedium,
                  ),
                  const Spacer(),
                  const _DifficultyPicker(),
                  const SizedBox(height: AppSpacing.sm),
                  const _RoundsSelector(),
                  const SizedBox(height: AppSpacing.md),
                  GradientButton(
                    onPressed: () => context.go(AppRoutes.game),
                    icon: Icons.play_arrow,
                    label: l10n.playButton,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  GradientButton.secondary(
                    onPressed: () => context.go(AppRoutes.settings),
                    icon: Icons.settings,
                    label: l10n.settingsButton,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text(l10n.genericError)),
          ),
        ),
      ),
    );
  }
}

class _DifficultyPicker extends ConsumerWidget {
  const _DifficultyPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.gameL10n;
    final difficulty = ref.watch(
      gameConfigViewModelProvider.select((c) => c.difficulty),
    );

    return HorizontalPicker<Difficulty>(
      values: Difficulty.values,
      selected: difficulty,
      labelOf: (d) => d.label(l10n),
      emojiOf: (d) => d.emoji,
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
