import 'package:flutter/material.dart';

/// Repository for app-level UI preferences (theme, locale).
///
/// Game-related preferences are handled by GamePreferencesRepository.
abstract class AppPreferencesRepository {
  ThemeMode getThemeMode();
  void setThemeMode(ThemeMode mode);

  Locale? getLocale();
  void setLocale(Locale? locale);
}
