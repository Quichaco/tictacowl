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

  factory User.create({required String name}) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError.value(name, 'name', 'must not be empty');
    }
    return User(name: trimmed);
  }
}
