import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:tictactoe_feature/src/common/extensions/build_context_extensions.dart';
import 'package:tictactoe_feature/src/common/extensions/player_extensions.dart';
import 'package:tictactoe_feature/src/common/hooks/use_confetti_controller.dart';
import 'package:ui_components/ui_components.dart';

class VictoryDialog extends HookWidget {
  const VictoryDialog({
    required this.winner,
    required this.winnerName,
    required this.isDraw,
    required this.isMatchOver,
    required this.scoreX,
    required this.scoreO,
    super.key,
  });

  final Player? winner;
  final String winnerName;
  final bool isDraw;
  final bool isMatchOver;
  final int scoreX;
  final int scoreO;

  static Future<VictoryDialogResult?> show({
    required BuildContext context,
    required Player? winner,
    required String winnerName,
    required bool isDraw,
    required bool isMatchOver,
    required int scoreX,
    required int scoreO,
  }) {
    return showDialog<VictoryDialogResult>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => VictoryDialog(
        winner: winner,
        winnerName: winnerName,
        isDraw: isDraw,
        isMatchOver: isMatchOver,
        scoreX: scoreX,
        scoreO: scoreO,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final confettiController = useConfettiController(const Duration(seconds: 3));
    final scaleController = useAnimationController(duration: AppDurations.slow);
    final emojiController = useAnimationController(duration: AppDurations.extraSlow);

    final scaleAnimation = useMemoized(
      () => CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
      [scaleController],
    );
    final rotateAnimation = useMemoized(
      () => Tween<double>(begin: -0.1, end: 0.0).animate(
        CurvedAnimation(parent: scaleController, curve: Curves.easeOutBack),
      ),
      [scaleController],
    );
    final emojiRotateAnimation = useMemoized(
      () => Tween<double>(begin: -0.05, end: 0.05).animate(
        CurvedAnimation(parent: emojiController, curve: Curves.easeInOut),
      ),
      [emojiController],
    );

    useEffect(() {
      scaleController.forward();
      emojiController.repeat(reverse: true);
      if (!isDraw) confettiController.play();
      return null;
    }, []);

    final emoji = _getEmoji(winner, isDraw);

    final gradient = winner?.gradient(context) ?? Player.x.gradient(context);

    final glowColor = isDraw
        ? Colors.grey.withAlpha(100)
        : gradient.colors.first.withAlpha(120);

    return Stack(
      children: [
        // Confetti at top
        if (!isDraw)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: isMatchOver ? 0.05 : 0.02,
              numberOfParticles: isMatchOver ? 20 : 10,
              maxBlastForce: isMatchOver ? 30 : 15,
              minBlastForce: isMatchOver ? 10 : 5,
              gravity: 0.3,
              colors: gradient.colors,
            ),
          ),
        // Dialog content
        Center(
          child: ScaleTransition(
            scale: scaleAnimation,
            child: RotationTransition(
              turns: rotateAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.md,
                ),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: AppRadius.card,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor,
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RotationTransition(
                      turns: emojiRotateAnimation,
                      child: Text(
                        emoji,
                        style: context.textTheme.displayLarge,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      winnerName,
                      style: context.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (isMatchOver) ...[
                      const SizedBox(height: AppSpacing.md),
                      _FinalScore(scoreX: scoreX, scoreO: scoreO),
                    ],
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      isMatchOver
                          ? context.l10n.tapToReplay
                          : context.l10n.tapToContinue,
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: context.brand.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (isMatchOver)
                      _MatchOverActions(
                        onReplay: () =>
                            Navigator.of(context).pop(VictoryDialogResult.replay),
                        onQuit: () =>
                            Navigator.of(context).pop(VictoryDialogResult.quit),
                      )
                    else
                      GradientButton.secondary(
                        onPressed: () =>
                            Navigator.of(context).pop(VictoryDialogResult.next),
                        icon: Icons.arrow_forward,
                        label: context.l10n.nextRoundButton,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum VictoryDialogResult { next, replay, quit }

String _getEmoji(Player? winner, bool isDraw) {
  if (isDraw) return '🤝';
  return winner == Player.x ? '🏆' : '🦉';
}

class _MatchOverActions extends StatelessWidget {
  const _MatchOverActions({
    required this.onReplay,
    required this.onQuit,
  });

  final VoidCallback onReplay;
  final VoidCallback onQuit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GradientButton(
          onPressed: onReplay,
          icon: Icons.replay,
          label: context.l10n.replayButton,
        ),
        const SizedBox(height: AppSpacing.xs),
        TextButton(
          onPressed: onQuit,
          child: Text(
            context.l10n.quitButton,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.brand.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _FinalScore extends StatelessWidget {
  const _FinalScore({
    required this.scoreX,
    required this.scoreO,
  });

  final int scoreX;
  final int scoreO;

  @override
  Widget build(BuildContext context) {
    final gradientX = Player.x.gradient(context);
    final gradientO = Player.o.gradient(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$scoreX',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: gradientX.colors.first,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            '-',
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.brand.textSecondary,
            ),
          ),
        ),
        Text(
          '$scoreO',
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: gradientO.colors.first,
          ),
        ),
      ],
    );
  }
}
