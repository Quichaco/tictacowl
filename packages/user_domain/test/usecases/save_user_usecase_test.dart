/// Tests for [SaveUserUseCase].
///
/// This use case has actual business logic (unlike simple passthroughs):
/// - Validates name length before saving
/// - Trims whitespace from name
/// - Creates [User] entity with generated createdAt
/// - Propagates repository failures
///
/// Note: [GetUserUseCase] is not tested as it's a trivial passthrough
/// (`return repository.getUser(uid)`).
library;

import 'package:common/common.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:user_domain/user_domain.dart';

import '../mocks.dart';

void main() {
  late MockUserRepository mockRepository;
  late SaveUserUseCase useCase;

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockRepository = MockUserRepository();
    useCase = SaveUserUseCase(mockRepository);
  });

  group('SaveUserUseCase', () {
    test('creates user with trimmed name and saves', () async {
      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => const Result.success(null));

      final result = await useCase.call(
        uid: 'uid123',
        name: '  John  ',
        email: 'john@example.com',
      );

      expect(result.isSuccess, isTrue);
      expect(result.dataOrNull!.name, equals('John'));
      verify(() => mockRepository.saveUser(any())).called(1);
    });

    test('throws on invalid name without calling repository', () {
      expect(
        () => useCase.call(uid: 'uid123', name: 'A', email: 'john@example.com'),
        throwsA(isA<ArgumentError>()),
      );
      verifyNever(() => mockRepository.saveUser(any()));
    });

    test('propagates repository failure', () async {
      when(() => mockRepository.saveUser(any()))
          .thenAnswer((_) async => const Result.failure(AppException.network()));

      final result = await useCase.call(
        uid: 'uid123',
        name: 'John',
        email: 'john@example.com',
      );

      expect(result.exceptionOrNull, isA<NetworkException>());
    });
  });
}
