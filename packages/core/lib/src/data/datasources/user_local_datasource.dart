import 'dart:convert';

import 'package:core/src/providers/shared_preferences_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_local_datasource.g.dart';

abstract class UserLocalDatasource {
  Future<void> saveUser(Map<String, dynamic> json);
  Future<Map<String, dynamic>?> getUser();
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  static const _key = 'user';
  final SharedPreferences _prefs;

  UserLocalDatasourceImpl(this._prefs);

  @override
  Future<void> saveUser(Map<String, dynamic> json) =>
      _prefs.setString(_key, jsonEncode(json));

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } on FormatException {
      return null; // Corrupted data, treat as no user
    }
  }
}

@riverpod
UserLocalDatasource userLocalDatasource(Ref ref) {
  return UserLocalDatasourceImpl(ref.watch(sharedPreferencesProvider));
}
