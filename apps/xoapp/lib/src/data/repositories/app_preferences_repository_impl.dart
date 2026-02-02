import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tictactoe_domain/tictactoe_domain.dart';
import 'package:xoapp/src/common/providers/shared_preferences_provider.dart';
import 'package:xoapp/src/domain/repositories/app_preferences_repository.dart';

part 'app_preferences_repository_impl.g.dart';

class AppPreferencesRepositoryImpl implements AppPreferencesRepository {
  AppPreferencesRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const _themeKey = 'theme_mode';
  static const _localeKey = 'locale';
  static const _difficultyKey = 'difficulty';
  static const _roundsKey = 'rounds';

  @override
  ThemeMode getThemeMode() {
    final raw = _prefs.getString(_themeKey);
    return ThemeMode.values.firstWhere(
      (m) => m.name == raw,
      orElse: () => ThemeMode.system,
    );
  }

  @override
  void setThemeMode(ThemeMode mode) {
    _prefs.setString(_themeKey, mode.name);
  }

  @override
  Locale? getLocale() {
    final raw = _prefs.getString(_localeKey);
    return raw != null ? Locale(raw) : null;
  }

  @override
  void setLocale(Locale? locale) {
    if (locale == null) {
      _prefs.remove(_localeKey);
    } else {
      _prefs.setString(_localeKey, locale.languageCode);
    }
  }

  @override
  Difficulty getDifficulty() {
    final raw = _prefs.getString(_difficultyKey);
    return Difficulty.values.firstWhere(
      (d) => d.name == raw,
      orElse: () => Difficulty.easy,
    );
  }

  @override
  void setDifficulty(Difficulty difficulty) {
    _prefs.setString(_difficultyKey, difficulty.name);
  }

  @override
  int getRounds() => _prefs.getInt(_roundsKey) ?? 3;

  @override
  void setRounds(int rounds) {
    _prefs.setInt(_roundsKey, rounds.clamp(GameConfig.minRounds, GameConfig.maxRounds));
  }
}

@Riverpod(keepAlive: true)
AppPreferencesRepository appPreferencesRepository(Ref ref) {
  return AppPreferencesRepositoryImpl(ref.watch(sharedPreferencesProvider));
}
