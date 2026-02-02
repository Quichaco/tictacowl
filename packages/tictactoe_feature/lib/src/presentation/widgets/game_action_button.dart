import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tictactoe_feature/l10n/gen/game_localizations.dart';
import 'package:tictactoe_feature/src/presentation/viewmodels/game_viewmodel.dart';
import 'package:ui_components/ui_components.dart';

class GameActionButton extends ConsumerWidget {
  const GameActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (:isGameOver, :isMatchOver) = ref.watch(
      gameViewModelProvider.select((s) => (
        isGameOver: s.isGameOver,
        isMatchOver: s.isMatchOver,
      )),
    );

    if (!isGameOver) return const SizedBox.shrink();

    final l10n = GameLocalizations.of(context)!;
    final notifier = ref.read(gameViewModelProvider.notifier);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: GradientButton(
        onPressed: isMatchOver ? notifier.restart : notifier.next,
        icon: isMatchOver ? Icons.replay : Icons.arrow_forward,
        label: isMatchOver ? l10n.replayButton : l10n.nextRoundButton,
      ),
    );
  }
}
