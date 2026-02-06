/// Tests for [UserRepositoryImpl] error mapping.
///
/// The repository's main responsibility is to:
/// - Delegate to the data source
/// - Map infrastructure exceptions to domain exceptions
///
/// Error mapping tested:
/// - [SocketException] → [NetworkException]
/// - Firebase 'permission-denied' → [AuthException]
/// - Firebase 'not-found' → [NotFoundException]
///
/// Note: Success cases are simple passthroughs to the data source,
/// which is already tested in user_remote_datasource_test.dart.
library;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/data/repositories/user_repository_impl.dart';

import '../../mocks.dart';

void main() {
  late MockUserRemoteDataSource mockDataSource;
  late UserRepositoryImpl repository;

  final testUser = User(
    uid: 'uid123',
    name: 'John',
    email: 'john@example.com',
    createdAt: DateTime(2024, 1, 15),
  );

  setUpAll(() {
    registerFallbackValue(FakeUser());
  });

  setUp(() {
    mockDataSource = MockUserRemoteDataSource();
    repository = UserRepositoryImpl(mockDataSource);
  });

  group('UserRepositoryImpl', () {
    group('saveUser', () {
      test('returns success when datasource succeeds', () async {
        when(() => mockDataSource.saveUser(any())).thenAnswer((_) async {});

        final result = await repository.saveUser(testUser);

        expect(result.isSuccess, isTrue);
      });
    });

    group('getUser', () {
      test('returns user when found', () async {
        when(() => mockDataSource.getUser(any()))
            .thenAnswer((_) async => testUser);

        final result = await repository.getUser('uid123');

        expect(result.dataOrNull, equals(testUser));
      });

      test('returns null when not found', () async {
        when(() => mockDataSource.getUser(any()))
            .thenAnswer((_) async => null);

        final result = await repository.getUser('uid123');

        expect(result.isSuccess, isTrue);
        expect(result.dataOrNull, isNull);
      });
    });

    group('error mapping', () {
      test('network errors map to NetworkException', () async {
        when(() => mockDataSource.saveUser(any()))
            .thenThrow(const SocketException(''));

        final result = await repository.saveUser(testUser);

        expect(result.exceptionOrNull, isA<NetworkException>());
      });

      test('permission-denied maps to AuthException', () async {
        when(() => mockDataSource.saveUser(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'),
        );

        final result = await repository.saveUser(testUser);

        expect(result.exceptionOrNull, isA<AuthException>());
      });

      test('not-found maps to NotFoundException', () async {
        when(() => mockDataSource.getUser(any())).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'not-found'),
        );

        final result = await repository.getUser('uid123');

        expect(result.exceptionOrNull, isA<NotFoundException>());
      });
    });
  });
}
