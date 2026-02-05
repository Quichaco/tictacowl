import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

/// Represents a minimal authenticated user from Firebase Auth.
@freezed
abstract class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String uid,
    required String email,
  }) = _AuthUser;
}
