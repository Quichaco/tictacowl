import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

/// Typed exceptions for error handling with [Result].
@freezed
sealed class AppException with _$AppException {
  /// Authentication error (invalid credentials, expired session, etc.)
  const factory AppException.auth({
    required String code,
    required String message,
  }) = AuthException;

  /// Network connectivity error.
  const factory AppException.network({String? message}) = NetworkException;

  /// Server-side error (5xx responses).
  const factory AppException.server({String? message}) = ServerException;

  /// Resource not found (404).
  const factory AppException.notFound({String? message}) = NotFoundException;

  /// Unexpected/unhandled error.
  const factory AppException.unknown({Object? error}) = UnknownException;
}
