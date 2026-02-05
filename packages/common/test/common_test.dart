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
    test('auth exception has code and message', () {
      const exception = AppException.auth(code: 'invalid', message: 'Invalid credentials');
      expect(exception, isA<AuthException>());
    });

    test('network exception is created', () {
      const exception = AppException.network(message: 'No connection');
      expect(exception, isA<NetworkException>());
    });
  });
}
