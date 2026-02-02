import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:xoapp/l10n/gen/app_localizations.dart';

extension DifficultyExtensions on Difficulty {
  String label(AppLocalizations l10n) => switch (this) {
        Difficulty.easy => l10n.difficultyEasy,
        Difficulty.medium => l10n.difficultyMedium,
        Difficulty.hard => l10n.difficultyHard,
      };

  String get emoji => switch (this) {
        Difficulty.easy => '😊',
        Difficulty.medium => '😐',
        Difficulty.hard => '😱',
      };
}
