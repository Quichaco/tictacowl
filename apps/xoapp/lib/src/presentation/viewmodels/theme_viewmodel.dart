import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xoapp/src/data/repositories/app_preferences_repository_impl.dart';

part 'theme_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class ThemeViewModel extends _$ThemeViewModel {
  @override
  ThemeMode build() {
    return ref.read(appPreferencesRepositoryProvider).getThemeMode();
  }

  void setThemeMode(ThemeMode mode) {
    ref.read(appPreferencesRepositoryProvider).setThemeMode(mode);
    state = mode;
  }
}
