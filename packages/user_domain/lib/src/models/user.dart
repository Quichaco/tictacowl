import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const minNameLength = 2;
  static const maxNameLength = 30;

  static String? Function(String?) nameValidator(String minLengthError) {
    return (value) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.length < minNameLength) {
        return minLengthError;
      }
      return null;
    };
  }

  factory User.create({required String name}) {
    final trimmed = name.trim();
    if (trimmed.length < minNameLength) {
      throw ArgumentError.value(
        name,
        'name',
        'must be at least $minNameLength characters',
      );
    }
    if (trimmed.length > maxNameLength) {
      throw ArgumentError.value(
        name,
        'name',
        'must be at most $maxNameLength characters',
      );
    }
    return User(name: trimmed);
  }
}
