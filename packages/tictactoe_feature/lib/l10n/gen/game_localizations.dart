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

  /// No description provided for @difficultyEasy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get difficultyEasy;

  /// No description provided for @difficultyMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get difficultyMedium;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;
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
