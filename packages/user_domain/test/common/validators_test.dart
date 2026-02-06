/// Tests for form validators.
///
/// These validators are used in the UI layer for form validation.
/// They return error messages (not exceptions) for invalid input.
///
/// Tested validators:
/// - [Validators.email]: Email format validation
/// - [Validators.password]: Minimum length validation
/// - [Validators.name]: Length range validation with trimming
library;

import 'package:test/test.dart';
import 'package:user_domain/user_domain.dart';

void main() {
  group('Validators.email', () {
    const error = 'Invalid email';

    final validCases = ['test@example.com', 'user@mail.co', 'a@b.c'];
    final invalidCases = [null, '', 'test', 'test@', '@example.com', 'test@example'];

    for (final email in validCases) {
      test('accepts "$email"', () {
        expect(Validators.email(email, invalidMessage: error), isNull);
      });
    }

    for (final email in invalidCases) {
      test('rejects "$email"', () {
        expect(Validators.email(email, invalidMessage: error), equals(error));
      });
    }

    test('trims whitespace', () {
      expect(Validators.email('  test@example.com  ', invalidMessage: error), isNull);
    });
  });

  group('Validators.password', () {
    const error = 'Too short';

    test('accepts password with ${Validators.minPasswordLength}+ chars', () {
      expect(
        Validators.password('a' * Validators.minPasswordLength, tooShortMessage: error),
        isNull,
      );
    });

    test('rejects password with less than ${Validators.minPasswordLength} chars', () {
      expect(
        Validators.password('a' * (Validators.minPasswordLength - 1), tooShortMessage: error),
        equals(error),
      );
    });

    test('rejects null', () {
      expect(Validators.password(null, tooShortMessage: error), equals(error));
    });
  });

  group('Validators.name', () {
    const tooShort = 'Too short';
    const tooLong = 'Too long';

    test('accepts name between ${Validators.minNameLength}-${Validators.maxNameLength} chars', () {
      expect(
        Validators.name('John', tooShortMessage: tooShort, tooLongMessage: tooLong),
        isNull,
      );
    });

    test('rejects name with less than ${Validators.minNameLength} chars', () {
      expect(
        Validators.name('A', tooShortMessage: tooShort, tooLongMessage: tooLong),
        equals(tooShort),
      );
    });

    test('rejects name with more than ${Validators.maxNameLength} chars', () {
      expect(
        Validators.name('a' * (Validators.maxNameLength + 1), tooShortMessage: tooShort, tooLongMessage: tooLong),
        equals(tooLong),
      );
    });

    test('trims whitespace before validation', () {
      expect(
        Validators.name('  ab  ', tooShortMessage: tooShort, tooLongMessage: tooLong),
        isNull,
      );
    });
  });
}
