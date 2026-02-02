import 'package:flutter/material.dart';

/// Repository for simple UI preferences (theme, locale).
///
/// Domain entities with business rules go through dedicated domain packages.
/// Simple key-value preferences use this repository directly.
abstract class AppPreferencesRepository {
  ThemeMode getThemeMode();
  void setThemeMode(ThemeMode mode);

  Locale? getLocale();
  void setLocale(Locale? locale);
}
