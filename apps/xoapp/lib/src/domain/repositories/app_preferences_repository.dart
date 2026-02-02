import 'package:flutter/material.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';

/// Repository for simple UI preferences (theme, locale, game config).
///
/// Domain entities with business rules go through dedicated domain packages.
/// Simple key-value preferences use this repository directly.
abstract class AppPreferencesRepository {
  ThemeMode getThemeMode();
  void setThemeMode(ThemeMode mode);

  Locale? getLocale();
  void setLocale(Locale? locale);

  Difficulty getDifficulty();
  void setDifficulty(Difficulty difficulty);

  int getRounds();
  void setRounds(int rounds);
}
