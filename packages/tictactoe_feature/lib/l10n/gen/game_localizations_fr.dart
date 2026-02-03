// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'game_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class GameLocalizationsFr extends GameLocalizations {
  GameLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String roundTitle(int current) {
    return 'Manche $current';
  }

  @override
  String aiName(String difficulty) {
    return 'IA $difficulty';
  }

  @override
  String get nextRoundButton => 'Manche suivante';

  @override
  String get replayButton => 'Rejouer';

  @override
  String get difficultyEasy => 'Facile';

  @override
  String get difficultyMedium => 'Moyen';

  @override
  String get difficultyHard => 'Difficile';
}
