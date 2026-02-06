/// Tests for [UserRemoteDataSourceImpl] with Firestore.
///
/// Uses [FakeFirebaseFirestore] to test actual Firestore operations
/// without requiring a real Firebase instance.
///
/// Verifies:
/// - Document structure (uid as doc ID, not in data)
/// - Timestamp conversion (DateTime ↔ Firestore Timestamp)
/// - Roundtrip data integrity (save then get preserves all fields)
/// - Null handling for non-existent documents
///
/// Note: This is NOT an integration test - FakeFirebaseFirestore is an
/// in-memory implementation, not the real Firebase.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:user_domain/user_domain.dart';
import 'package:user_feature/src/data/datasources/user_remote_datasource.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late UserRemoteDataSourceImpl dataSource;

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    dataSource = UserRemoteDataSourceImpl(fakeFirestore);
  });

  group('UserRemoteDataSourceImpl', () {
    group('saveUser', () {
      test('saves user to Firestore with correct data', () async {
        final user = User(
          uid: 'uid123',
          name: 'John Doe',
          email: 'john@example.com',
          createdAt: DateTime.now(),
        );

        await dataSource.saveUser(user);

        final doc = await fakeFirestore.collection('users').doc('uid123').get();
        expect(doc.exists, isTrue);
        expect(doc.data()!['name'], equals('John Doe'));
        expect(doc.data()!['email'], equals('john@example.com'));
        expect(doc.data()!['createdAt'], isA<Timestamp>());
      });

      test('does not store uid in document data (uses doc ID)', () async {
        final user = User(
          uid: 'uid123',
          name: 'John',
          email: 'john@example.com',
          createdAt: DateTime.now(),
        );

        await dataSource.saveUser(user);

        final doc = await fakeFirestore.collection('users').doc('uid123').get();
        expect(doc.data()!.containsKey('uid'), isFalse);
        expect(doc.id, equals('uid123'));
      });
    });

    group('getUser', () {
      test('returns user when document exists', () async {
        await fakeFirestore.collection('users').doc('uid123').set({
          'name': 'John Doe',
          'email': 'john@example.com',
          'createdAt': Timestamp.now(),
        });

        final user = await dataSource.getUser('uid123');

        expect(user, isNotNull);
        expect(user!.uid, equals('uid123'));
        expect(user.name, equals('John Doe'));
        expect(user.email, equals('john@example.com'));
        expect(user.createdAt, isA<DateTime>());
      });

      test('returns null when document does not exist', () async {
        final user = await dataSource.getUser('nonexistent');
        expect(user, isNull);
      });

      test('uses document ID as uid', () async {
        await fakeFirestore.collection('users').doc('custom-doc-id').set({
          'name': 'Jane',
          'email': 'jane@example.com',
          'createdAt': Timestamp.now(),
        });

        final user = await dataSource.getUser('custom-doc-id');

        expect(user!.uid, equals('custom-doc-id'));
      });
    });

    group('roundtrip', () {
      test('save then get preserves all fields', () async {
        final original = User(
          uid: 'uid123',
          name: 'John Doe',
          email: 'john@example.com',
          createdAt: DateTime.now(),
        );

        await dataSource.saveUser(original);
        final retrieved = await dataSource.getUser(original.uid);

        expect(retrieved, isNotNull);
        expect(retrieved!.uid, equals(original.uid));
        expect(retrieved.name, equals(original.name));
        expect(retrieved.email, equals(original.email));
        // DateTime comparison with tolerance for Firestore precision
        expect(
          retrieved.createdAt.difference(original.createdAt).inSeconds.abs(),
          lessThan(2),
        );
      });
    });
  });
}
