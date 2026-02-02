import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:xoapp/src/data/repositories/app_preferences_repository_impl.dart';

part 'locale_viewmodel.g.dart';

@Riverpod(keepAlive: true)
class LocaleViewModel extends _$LocaleViewModel {
  @override
  Locale? build() {
    return ref.read(appPreferencesRepositoryProvider).getLocale();
  }

  void setLocale(Locale? locale) {
    ref.read(appPreferencesRepositoryProvider).setLocale(locale);
    state = locale;
  }
}
