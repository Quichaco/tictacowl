// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'game_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class GameLocalizationsEn extends GameLocalizations {
  GameLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String roundTitle(int current) {
    return 'Round $current';
  }

  @override
  String get aiName => 'AI XO';

  @override
  String get nextRoundButton => 'Next round';

  @override
  String get replayButton => 'Replay';

  @override
  String get difficultyEasy => 'Easy';

  @override
  String get difficultyMedium => 'Medium';

  @override
  String get difficultyHard => 'Hard';
}
