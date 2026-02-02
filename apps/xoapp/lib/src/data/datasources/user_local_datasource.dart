import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xoapp/src/common/providers/shared_preferences_provider.dart';

part 'user_local_datasource.g.dart';

abstract class UserLocalDatasource {
  Future<void> saveUser(Map<String, dynamic> json);
  Future<Map<String, dynamic>?> getUser();
}

class UserLocalDatasourceImpl implements UserLocalDatasource {
  static const _key = 'user2';
  final SharedPreferences _prefs;

  UserLocalDatasourceImpl(this._prefs);

  @override
  Future<void> saveUser(Map<String, dynamic> json) =>
      _prefs.setString(_key, jsonEncode(json));

  @override
  Future<Map<String, dynamic>?> getUser() async {
    final raw = _prefs.getString(_key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}

@riverpod
UserLocalDatasource userLocalDatasource(Ref ref) {
  return UserLocalDatasourceImpl(ref.watch(sharedPreferencesProvider));
}
