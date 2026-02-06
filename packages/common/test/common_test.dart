/// Tests for the common package core types.
///
/// This file tests:
/// - [Result]: Success/failure wrapper for operation results
/// - [AppException]: Typed exceptions for error handling across the app
///
/// These are foundational types used throughout all packages for consistent
/// error handling and result propagation.
library;

import 'package:common/common.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('success contains data', () {
      final result = Result.success(42);
      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull, equals(42));
    });

    test('failure contains exception', () {
      final result = Result<int>.failure(AppException.network());
      expect(result.isFailure, isTrue);
      expect(result.exceptionOrNull, isA<NetworkException>());
    });
  });

  group('AppException', () {
    test('AuthException stores code and message', () {
      const exception = AuthException(code: 'invalid', message: 'Invalid credentials');
      expect(exception.code, equals('invalid'));
      expect(exception.message, equals('Invalid credentials'));
    });

    test('NetworkException stores message', () {
      const exception = NetworkException(message: 'No connection');
      expect(exception.message, equals('No connection'));
    });
  });
}
