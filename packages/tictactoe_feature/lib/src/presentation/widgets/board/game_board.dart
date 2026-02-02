import 'package:flutter/material.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/win_line.dart';
import 'package:ui_components/ui_components.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    required this.children,
    this.gridSize = 3,
    this.winPattern,
    this.winGradient,
    super.key,
  });

  final List<Widget> children;
  final int gridSize;
  final List<int>? winPattern;
  final LinearGradient? winGradient;

  @override
  Widget build(BuildContext context) {
    const spacing = AppSpacing.xs;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSize = constraints.maxWidth;
        final cellSize = (totalSize - spacing * (gridSize - 1)) / gridSize;

        return Stack(
          children: [
            GridView.count(
              crossAxisCount: gridSize,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: spacing,
              crossAxisSpacing: spacing,
              children: children,
            ),
            if (winPattern != null && winGradient != null)
              Positioned.fill(
                child: WinLine(
                  pattern: winPattern!,
                  cellSize: cellSize,
                  spacing: spacing,
                  gradient: winGradient!,
                  gridSize: gridSize,
                ),
              ),
          ],
        );
      },
    );
  }
}
