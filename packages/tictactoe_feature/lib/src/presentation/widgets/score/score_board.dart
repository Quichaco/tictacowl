import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/build_context_extensions.dart';
import 'package:tictactoe_feature/src/common/models/game_mode_theme.dart';
import 'package:tictactoe_feature/src/common/extensions/player_extensions.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:ui_components/ui_components.dart';

class ScoreBoard extends ConsumerWidget {
  const ScoreBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(
      gameConfigViewModelProvider.select((c) => c.mode),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          mode.theme.owlImageTop,
          height: 50,
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: context.colorScheme.outline,
            ),
          ),
          child: const Row(
            children: [
              Expanded(child: _PlayerScoreX()),
              _VsIndicator(),
              Expanded(child: _PlayerScoreO()),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayerScoreX extends ConsumerWidget {
  const _PlayerScoreX();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:score, :isActive, :name) = ref.watch(
      gameViewModelProvider.select((s) => (
        score: s.scoreX,
        isActive: s.currentPlayer == Player.x,
        name: s.playerName,
      )),
    );

    return _PlayerScoreDisplay(
      player: Player.x,
      score: score,
      name: name,
      isActive: isActive,
    );
  }
}

class _PlayerScoreO extends ConsumerWidget {
  const _PlayerScoreO();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:score, :isActive) = ref.watch(
      gameViewModelProvider.select((s) => (
        score: s.scoreO,
        isActive: s.currentPlayer == Player.o,
      )),
    );
    final mode = ref.watch(
      gameConfigViewModelProvider.select((c) => c.mode),
    );

    return _PlayerScoreDisplay(
      player: Player.o,
      score: score,
      name: mode.theme.title(context.l10n),
      isActive: isActive,
    );
  }
}

class _PlayerScoreDisplay extends StatelessWidget {
  const _PlayerScoreDisplay({
    required this.player,
    required this.score,
    required this.name,
    required this.isActive,
  });

  final Player player;
  final int score;
  final String name;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final gradient = player.gradient(context);
    final isX = player == Player.x;
    final inactiveColor = context.brand.textSecondary;
    final inactiveGradient = LinearGradient(colors: [inactiveColor, inactiveColor]);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainer,
            borderRadius: AppRadius.button,
            border: Border.all(
              color: gradient.colors.first.withAlpha(isActive ? 255 : 80),
              width: isActive ? 2.5 : 1,
            ),
          ),
          child: Text(
            '$score',
            style: context.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          height: 20,
          width: 20,
          child: XoSymbol(
            type: isX ? XoSymbolType.x : XoSymbolType.o,
            gradient: isActive ? gradient : inactiveGradient,
          ),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          name,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isActive ? gradient.colors.first : inactiveColor,
          ),
        ),
      ],
    );
  }
}

class _VsIndicator extends ConsumerWidget {
  const _VsIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:currentRound, :totalRounds) = ref.watch(
      gameViewModelProvider.select((s) => (
        currentRound: s.currentRound,
        totalRounds: s.totalRounds,
      )),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'VS',
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: context.brand.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xxs),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xxs,
            ),
            decoration: BoxDecoration(
              color: context.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              '$currentRound/$totalRounds',
              style: context.textTheme.labelMedium?.copyWith(
                color: context.brand.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
