import 'dart:ui';

import 'package:xoapp/l10n/gen/app_localizations.dart';

extension LocaleExtensions on Locale {
  /// Returns the native name of this locale from its own ARB file.
  String get nativeName => lookupAppLocalizations(this).languageName;
}
