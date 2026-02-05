import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'game_localizations_en.dart';
import 'game_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GameLocalizations
/// returned by `GameLocalizations.of(context)`.
///
/// Applications need to include `GameLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/game_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GameLocalizations.localizationsDelegates,
///   supportedLocales: GameLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the GameLocalizations.supportedLocales
/// property.
abstract class GameLocalizations {
  GameLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GameLocalizations? of(BuildContext context) {
    return Localizations.of<GameLocalizations>(context, GameLocalizations);
  }

  static const LocalizationsDelegate<GameLocalizations> delegate =
      _GameLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @roundTitle.
  ///
  /// In en, this message translates to:
  /// **'Round {current}'**
  String roundTitle(int current);

  /// No description provided for @aiName.
  ///
  /// In en, this message translates to:
  /// **'AI {difficulty}'**
  String aiName(String difficulty);

  /// No description provided for @playerWinsRound.
  ///
  /// In en, this message translates to:
  /// **'{name} wins the round!'**
  String playerWinsRound(String name);

  /// No description provided for @playerWinsMatch.
  ///
  /// In en, this message translates to:
  /// **'{name} wins the game!'**
  String playerWinsMatch(String name);

  /// No description provided for @drawRoundResult.
  ///
  /// In en, this message translates to:
  /// **'Round draw!'**
  String get drawRoundResult;

  /// No description provided for @drawMatchResult.
  ///
  /// In en, this message translates to:
  /// **'Match draw!'**
  String get drawMatchResult;

  /// No description provided for @tapToContinue.
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get tapToContinue;

  /// No description provided for @tapToReplay.
  ///
  /// In en, this message translates to:
  /// **'Tap to replay'**
  String get tapToReplay;

  /// No description provided for @nextRoundButton.
  ///
  /// In en, this message translates to:
  /// **'Next round'**
  String get nextRoundButton;

  /// No description provided for @replayButton.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replayButton;

  /// No description provided for @gameModeMultiplayer.
  ///
  /// In en, this message translates to:
  /// **'2 Players'**
  String get gameModeMultiplayer;

  /// No description provided for @gameModeEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get gameModeEasy;

  /// No description provided for @gameModeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get gameModeMedium;

  /// No description provided for @gameModeHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get gameModeHard;

  /// No description provided for @owlMultiTitle.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get owlMultiTitle;

  /// No description provided for @owlMultiSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Challenge a friend locally'**
  String get owlMultiSubtitle;

  /// No description provided for @owlEasyTitle.
  ///
  /// In en, this message translates to:
  /// **'Wise Owl'**
  String get owlEasyTitle;

  /// No description provided for @owlMediumTitle.
  ///
  /// In en, this message translates to:
  /// **'Cunning Owl'**
  String get owlMediumTitle;

  /// No description provided for @owlHardTitle.
  ///
  /// In en, this message translates to:
  /// **'Master Owl'**
  String get owlHardTitle;

  /// No description provided for @owlEasySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Perfect for beginners'**
  String get owlEasySubtitle;

  /// No description provided for @owlMediumSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A balanced challenge'**
  String get owlMediumSubtitle;

  /// No description provided for @owlHardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Only for the brave'**
  String get owlHardSubtitle;

  /// No description provided for @restartButton.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restartButton;

  /// No description provided for @restartTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart game?'**
  String get restartTitle;

  /// No description provided for @restartMessage.
  ///
  /// In en, this message translates to:
  /// **'The scores will be reset to zero.'**
  String get restartMessage;

  /// No description provided for @quitTitle.
  ///
  /// In en, this message translates to:
  /// **'Quit game?'**
  String get quitTitle;

  /// No description provided for @quitMessage.
  ///
  /// In en, this message translates to:
  /// **'The current game will be lost.'**
  String get quitMessage;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @quitButton.
  ///
  /// In en, this message translates to:
  /// **'Quit'**
  String get quitButton;
}

class _GameLocalizationsDelegate
    extends LocalizationsDelegate<GameLocalizations> {
  const _GameLocalizationsDelegate();

  @override
  Future<GameLocalizations> load(Locale locale) {
    return SynchronousFuture<GameLocalizations>(
      lookupGameLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_GameLocalizationsDelegate old) => false;
}

GameLocalizations lookupGameLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return GameLocalizationsEn();
    case 'fr':
      return GameLocalizationsFr();
  }

  throw FlutterError(
    'GameLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
