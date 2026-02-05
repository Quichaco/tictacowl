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
  String playerWinsRound(String name) {
    return '$name gagne la manche !';
  }

  @override
  String playerWinsMatch(String name) {
    return '$name gagne la partie !';
  }

  @override
  String get drawRoundResult => 'Égalité de la manche !';

  @override
  String get drawMatchResult => 'Égalité de la partie !';

  @override
  String get tapToContinue => 'Appuyer pour continuer';

  @override
  String get tapToReplay => 'Appuyer pour rejouer';

  @override
  String get nextRoundButton => 'Manche suivante';

  @override
  String get replayButton => 'Rejouer';

  @override
  String get gameModeMultiplayer => '2 Joueurs';

  @override
  String get gameModeEasy => 'Facile';

  @override
  String get gameModeMedium => 'Moyen';

  @override
  String get gameModeHard => 'Difficile';

  @override
  String get owlMultiTitle => 'Invité';

  @override
  String get owlMultiSubtitle => 'Défie un ami en local';

  @override
  String get owlEasyTitle => 'Hibou Sage';

  @override
  String get owlMediumTitle => 'Hibou Rusé';

  @override
  String get owlHardTitle => 'Hibou Maître';

  @override
  String get owlEasySubtitle => 'Parfait pour débuter';

  @override
  String get owlMediumSubtitle => 'Un défi équilibré';

  @override
  String get owlHardSubtitle => 'Réservé aux plus courageux';

  @override
  String get restartButton => 'Recommencer';

  @override
  String get restartTitle => 'Recommencer la partie ?';

  @override
  String get restartMessage => 'Les scores seront remis à zéro.';

  @override
  String get quitTitle => 'Quitter la partie ?';

  @override
  String get quitMessage => 'La partie en cours sera perdue.';

  @override
  String get confirmButton => 'Confirmer';

  @override
  String get cancelButton => 'Annuler';

  @override
  String get quitButton => 'Quitter';
}
