import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:user_domain/src/common/validators.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
abstract class User with _$User {
  const User._();

  const factory User({
    required String uid,
    required String name,
    required String email,
    required DateTime createdAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  static const minNameLength = Validators.minNameLength;
  static const maxNameLength = Validators.maxNameLength;

  factory User.create({
    required String uid,
    required String name,
    required String email,
    DateTime? createdAt,
  }) {
    final trimmedName = name.trim();
    final error = Validators.name(
      trimmedName,
      tooShortMessage: 'must be at least $minNameLength characters',
      tooLongMessage: 'must be at most $maxNameLength characters',
    );
    if (error != null) {
      throw ArgumentError.value(name, 'name', error);
    }
    return User(
      uid: uid,
      name: trimmedName,
      email: email,
      createdAt: createdAt ?? DateTime.now(),
    );
  }
}
