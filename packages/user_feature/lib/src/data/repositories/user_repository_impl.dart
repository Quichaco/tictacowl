import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/data/datasources/user_remote_datasource.dart';

part 'user_repository_impl.g.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  Future<Result<void>> saveUser(User user) async {
    try {
      await _remoteDataSource
          .saveUser(user);
      return const Result.success(null);
    } on FirebaseException catch (e) {
      return Result.failure(_mapFirestoreException(e));
    } on TimeoutException {
      return Result.failure(
        const NetworkException(message: 'Request timed out'),
      );
    } on SocketException {
      return Result.failure(
        const NetworkException(message: 'No internet connection'),
      );
    } catch (e) {
      return Result.failure(UnknownException(error: e));
    }
  }

  @override
  Future<Result<User?>> getUser(String uid) async {
    try {
      final user = await _remoteDataSource
          .getUser(uid);
      return Result.success(user);
    } on FirebaseException catch (e) {
      return Result.failure(_mapFirestoreException(e));
    } on FormatException catch (e) {
      return Result.failure(ServerException(message: e.message));
    } on TimeoutException {
      return Result.failure(
        const NetworkException(message: 'Request timed out'),
      );
    } on SocketException {
      return Result.failure(
        const NetworkException(message: 'No internet connection'),
      );
    } catch (e) {
      return Result.failure(UnknownException(error: e));
    }
  }

  AppException _mapFirestoreException(FirebaseException e) {
    return switch (e.code) {
      'permission-denied' => const AuthException(
          code: 'permission-denied',
          message: 'Permission denied',
        ),
      'not-found' => const NotFoundException(),
      'unavailable' => const NetworkException(message: 'Service unavailable'),
      _ => ServerException(message: e.message),
    };
  }
}

@Riverpod(keepAlive: true)
UserRepository userRepository(Ref ref) {
  return UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider));
}
