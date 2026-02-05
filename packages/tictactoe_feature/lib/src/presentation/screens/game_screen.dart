import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/build_context_extensions.dart';
import 'package:tictactoe_feature/src/common/models/game_mode_theme.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_config_viewmodel.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:tictactoe_feature/src/presentation/widgets/board/game_grid.dart';
import 'package:tictactoe_feature/src/presentation/widgets/dialogs/victory_dialog.dart';
import 'package:tictactoe_feature/src/presentation/widgets/score/score_board.dart';
import 'package:ui_components/ui_components.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      gameViewModelProvider.select((s) => s.isRoundOver),
      (wasGameOver, isRoundOver) {
        if (isRoundOver && wasGameOver == false) {
          _showVictoryDialog(context, ref);
        }
      },
    );

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        await _handleQuit(context);
      },
      child: Scaffold(
        appBar: XoAppBar(
          onBackPressed: () => _handleQuit(context),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: Column(
              children: [
                const ScoreBoard()
                    .animate()
                    .fadeIn(duration: AppDurations.medium)
                    .slideY(begin: -0.2, curve: Curves.easeOut),
                const SizedBox(height: AppSpacing.sm),
                const Expanded(
                  child: Center(child: GameGrid()),
                ),
                const SizedBox(height: AppSpacing.sm),
                const _RestartButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleQuit(BuildContext context) async {
    final l10n = context.l10n;
    final shouldQuit = await ConfirmationDialog.show(
      context: context,
      title: l10n.quitTitle,
      message: l10n.quitMessage,
      confirmLabel: l10n.confirmButton,
      cancelLabel: l10n.cancelButton,
      icon: Icons.exit_to_app,
    );
    if (shouldQuit && context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showVictoryDialog(BuildContext context, WidgetRef ref) async {
    final state = ref.read(gameViewModelProvider);
    final mode = ref.read(gameConfigViewModelProvider).mode;
    final l10n = context.l10n;

    String getName(Player player) {
      if (player == Player.x) return state.playerName;
      return mode.theme.title(l10n);
    }

    String getWinnerDisplayText() {
      if (state.isMatchOver) {
        if (state.isMatchDraw) return l10n.drawMatchResult;
        return l10n.playerWinsMatch(getName(state.matchWinner!));
      }
      if (state.isRoundDraw) return l10n.drawRoundResult;
      return l10n.playerWinsRound(getName(state.winner!));
    }

    final displayWinner = state.isMatchOver ? state.matchWinner : state.winner;
    final displayIsDraw = state.isMatchOver ? state.isMatchDraw : state.isRoundDraw;

    final result = await VictoryDialog.show(
      context: context,
      winner: displayWinner,
      winnerName: getWinnerDisplayText(),
      isDraw: displayIsDraw,
      isMatchOver: state.isMatchOver,
      scoreX: state.scoreX,
      scoreO: state.scoreO,
    );

    if (!context.mounted) return;

    switch (result) {
      case VictoryDialogResult.next:
        ref.read(gameViewModelProvider.notifier).next();
      case VictoryDialogResult.replay:
        ref.read(gameViewModelProvider.notifier).restart();
      case VictoryDialogResult.quit:
        Navigator.of(context).pop();
      case null:
        break;
    }
  }
}

class _RestartButton extends ConsumerWidget {
  const _RestartButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRoundOver = ref.watch(
      gameViewModelProvider.select((s) => s.isRoundOver),
    );

    if (isRoundOver) return const SizedBox.shrink();

    return GradientButton(
      onPressed: () => _showRestartDialog(context, ref),
      icon: Icons.refresh,
      label: context.l10n.restartButton,
    );
  }

  Future<void> _showRestartDialog(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final confirmed = await ConfirmationDialog.show(
      context: context,
      title: l10n.restartTitle,
      message: l10n.restartMessage,
      confirmLabel: l10n.confirmButton,
      cancelLabel: l10n.cancelButton,
      icon: Icons.refresh,
    );
    if (confirmed) {
      ref.read(gameViewModelProvider.notifier).restart();
    }
  }
}
