import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ui_components/ui_components.dart';

import 'helpers/test_app.dart';

void main() {
  testWidgets('signup → home → logout → login', (tester) async {
    final testEmail = 'test${DateTime.now().millisecondsSinceEpoch}@test.com';
    const testPassword = 'TestPassword123!';
    const testUsername = 'TestUser';

    await tester.pumpWidget(await createTestApp(useFirebase: true));

    // Welcome
    await waitFor(tester, find.byIcon(Icons.person_add_outlined));
    expect(find.byType(GradientButton), findsNWidgets(2));

    // Signup: email
    await tester.tap(find.byIcon(Icons.person_add_outlined));
    await settle(tester);
    await tester.enterText(find.byType(TextFormField), testEmail);
    await tester.tap(find.byType(GradientButton).first);
    await settle(tester);

    // Signup: passwords
    await waitUntil(tester, () => find.byType(TextFormField).evaluate().length >= 2);
    final passwordFields = find.byType(TextFormField);
    await tester.enterText(passwordFields.first, testPassword);
    await tester.enterText(passwordFields.last, testPassword);
    await tester.tap(find.byType(GradientButton).first);

    // Set username
    await waitFor(tester, find.byIcon(Icons.person_outline), timeout: const Duration(seconds: 20));
    await settle(tester);
    await tester.enterText(find.byType(TextFormField).first, testUsername);
    await tester.tap(find.byType(GradientButton).first);

    // Home
    await waitFor(tester, find.byIcon(Icons.settings), timeout: const Duration(seconds: 20));
    expect(find.byIcon(Icons.settings), findsOneWidget);

    // Logout
    await tester.tap(find.byIcon(Icons.settings));
    await settle(tester);
    await tester.tap(find.byIcon(Icons.logout));
    await waitFor(tester, find.byIcon(Icons.login), timeout: const Duration(seconds: 20));

    // Login
    await tester.tap(find.byIcon(Icons.login));
    await settle(tester);
    final loginFields = find.byType(TextFormField);
    await tester.enterText(loginFields.first, testEmail);
    await tester.enterText(loginFields.last, testPassword);
    await tester.tap(find.byType(GradientButton).first);

    // Back home
    await waitFor(tester, find.byIcon(Icons.settings), timeout: const Duration(seconds: 20));
    expect(find.byIcon(Icons.settings), findsOneWidget);
  });
}
