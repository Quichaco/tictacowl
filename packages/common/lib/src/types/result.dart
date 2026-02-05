import 'package:common/src/types/app_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

/// Result type for operations that can succeed or fail.
/// Use instead of throwing exceptions for expected failure cases.
@freezed
sealed class Result<T> with _$Result<T> {
  const Result._();

  /// Successful result containing [data].
  const factory Result.success(T data) = Success<T>;

  /// Failed result containing an [exception].
  const factory Result.failure(AppException exception) = Failure<T>;

  /// Whether this result is a success.
  bool get isSuccess => this is Success<T>;

  /// Whether this result is a failure.
  bool get isFailure => this is Failure<T>;

  /// Returns the data if success, null otherwise.
  T? get dataOrNull => switch (this) {
        Success(:final data) => data,
        Failure() => null,
      };

  /// Returns the exception if failure, null otherwise.
  AppException? get exceptionOrNull => switch (this) {
        Success() => null,
        Failure(:final exception) => exception,
      };

  /// Pattern match on success/failure.
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) {
    return switch (this) {
      Success(:final data) => success(data),
      Failure(:final exception) => failure(exception),
    };
  }

  /// Transform the success value.
  Result<R> map<R>(R Function(T data) transform) {
    return switch (this) {
      Success(:final data) => Result.success(transform(data)),
      Failure(:final exception) => Result.failure(exception),
    };
  }
}
