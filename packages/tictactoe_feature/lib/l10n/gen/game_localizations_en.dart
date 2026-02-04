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
  String aiName(String difficulty) {
    return 'AI $difficulty';
  }

  @override
  String playerWinsRound(String name) {
    return '$name wins the round!';
  }

  @override
  String playerWinsMatch(String name) {
    return '$name wins the game!';
  }

  @override
  String get drawRoundResult => 'Round draw!';

  @override
  String get drawMatchResult => 'Match draw!';

  @override
  String get tapToContinue => 'Tap to continue';

  @override
  String get tapToReplay => 'Tap to replay';

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

  @override
  String get owlEasyTitle => 'Wise Owl';

  @override
  String get owlMediumTitle => 'Cunning Owl';

  @override
  String get owlHardTitle => 'Master Owl';

  @override
  String get owlEasySubtitle => 'Perfect for beginners';

  @override
  String get owlMediumSubtitle => 'A balanced challenge';

  @override
  String get owlHardSubtitle => 'Only for the brave';

  @override
  String get restartButton => 'Restart';

  @override
  String get restartTitle => 'Restart game?';

  @override
  String get restartMessage => 'The scores will be reset to zero.';

  @override
  String get quitTitle => 'Quit game?';

  @override
  String get quitMessage => 'The current game will be lost.';

  @override
  String get confirmButton => 'Confirm';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get quitButton => 'Quit';
}
