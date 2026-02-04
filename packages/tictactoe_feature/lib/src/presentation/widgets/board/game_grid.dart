import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/player_extensions.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_cell.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:ui_components/ui_components.dart';

class GameGrid extends ConsumerWidget {
  const GameGrid({
    this.entranceStagger = const Duration(milliseconds: 30),
    this.frameDelay = const Duration(milliseconds: 100),
    super.key,
  });

  final Duration entranceStagger;
  final Duration frameDelay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:board, :gridSize, :winPattern) = ref.watch(
      gameViewModelProvider.select((s) => (
        board: s.board,
        gridSize: s.gridSize,
        winPattern: s.winPattern,
      )),
    );
    final notifier = ref.read(gameViewModelProvider.notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxSize = min(constraints.maxWidth, constraints.maxHeight);
        final padding = AppSpacing.md;
        final gridSize_ = maxSize - padding * 2;

        return Container(
          width: maxSize,
          height: maxSize,
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceContainerLow,
            borderRadius: AppRadius.card,
            border: Border.all(
              color: context.colorScheme.outline,
            ),
          ),
          padding: EdgeInsets.all(padding),
          child: SizedBox.square(
            dimension: gridSize_,
            child: GridView.count(
              crossAxisCount: gridSize,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.xs,
              crossAxisSpacing: AppSpacing.xs,
              children: List.generate(board.length, (index) {
                final cell = board[index];

                return GameCell(
                  symbolType:
                      cell == Player.x ? XoSymbolType.x : XoSymbolType.o,
                  isEmpty: cell == null,
                  gradient:
                      cell?.gradient(context) ?? Player.x.gradient(context),
                  isWinning: winPattern?.contains(index) ?? false,
                  onTap: () => notifier.play(index),
                )
                    .animate()
                    .fadeIn(
                      delay: frameDelay + (entranceStagger * index),
                      duration: AppDurations.fast,
                    )
                    .scale(
                      begin: const Offset(0.5, 0.5),
                      curve: Curves.easeOut,
                      delay: frameDelay + (entranceStagger * index),
                      duration: AppDurations.medium,
                    );
              }),
            ),
          ),
        )
            .animate()
            .fadeIn(delay: frameDelay, duration: AppDurations.medium)
            .scale(
              begin: const Offset(0.9, 0.9),
              curve: Curves.easeOut,
              delay: frameDelay,
              duration: AppDurations.medium,
            );
      },
    );
  }
}
