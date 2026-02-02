import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_board.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_cell.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:ui_components/ui_components.dart';

class GameGrid extends ConsumerWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:board, :gridSize, :winPattern, :winner) = ref.watch(
      gameViewModelProvider.select((s) => (
        board: s.board,
        gridSize: s.gridSize,
        winPattern: s.winPattern,
        winner: s.winner,
      )),
    );
    final notifier = ref.read(gameViewModelProvider.notifier);

    final winGradient = winner == null
        ? null
        : winner == Player.x
            ? context.brand.actionGradient
            : context.brand.secondaryGradient;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, constraints.maxHeight);

        return SizedBox.square(
          dimension: size,
          child: GameBoard(
            gridSize: gridSize,
            winPattern: winPattern,
            winGradient: winGradient,
            children: List.generate(board.length, (index) {
              final cell = board[index];
              final gradient = cell == Player.x
                  ? context.brand.actionGradient
                  : context.brand.secondaryGradient;

              return GameCell(
                symbol: cell == Player.x ? 'X' : 'O',
                isEmpty: cell == null,
                gradient: gradient,
                onTap: () => notifier.play(index),
              );
            }),
          ),
        );
      },
    );
  }
}
