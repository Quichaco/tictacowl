import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/build_context_extensions.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_grid.dart';
import 'package:tictactoe_feature/src/presentation/widgets/game_action_button.dart';
import 'package:tictactoe_feature/src/presentation/widgets/score/player_score_card.dart';
import 'package:ui_components/ui_components.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentRound = ref.watch(
      gameViewModelProvider.select((s) => s.currentRound),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.roundTitle(currentRound)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: PlayerScoreCard(player: Player.x),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: PlayerScoreCard(player: Player.o),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Expanded(child: Center(child: GameGrid())),
              const GameActionButton(),
              const SizedBox(height: AppSpacing.sm),
            ],
          ),
        ),
      ),
    );
  }
}
