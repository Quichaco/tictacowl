import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/l10n/gen/game_localizations.dart';
import 'package:tictactoe_feature/src/presentation/widgets/score/score_card.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:ui_components/ui_components.dart';

class PlayerScoreCard extends ConsumerWidget {
  const PlayerScoreCard({
    required this.player,
    super.key,
  });

  final Player player;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPlayerX = player == Player.x;

    final (:score, :isActive, :playerName) = ref.watch(
      gameViewModelProvider.select((s) => (
        score: isPlayerX ? s.scoreX : s.scoreO,
        isActive: s.currentPlayer == player,
        playerName: s.playerName,
      )),
    );

    final gradient = isPlayerX
        ? context.brand.actionGradient
        : context.brand.secondaryGradient;

    final name = isPlayerX ? playerName : GameLocalizations.of(context)!.aiName;

    return ScoreCard(
      symbol: isPlayerX ? 'X' : 'O',
      name: name,
      score: score,
      gradient: gradient,
      isActive: isActive,
    );
  }
}
