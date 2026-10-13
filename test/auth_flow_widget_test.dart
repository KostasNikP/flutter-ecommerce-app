import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/auth/models/user_provider.dart';
import 'package:shop_app/auth/pages/registration_page.dart';
import 'package:shop_app/auth/pages/login_page.dart';
import 'package:shop_app/auth/themes/dark_mode.dart';

void main() {
  Future<UserProvider> openEntry(WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final user = UserProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: user,
        child: MaterialApp(
          theme: darkMode,
          home: const LoginPage(),
          routes: {
            '/shop_page': (_) => const Scaffold(
                  body: Center(child: Text('SHOP_READY')),
                ),
            '/registration_page': (_) => const RegistrationPage(),
          },
        ),
      ),
    );
    await tester.pump();
    return user;
  }

  testWidgets('new phone login presents clear demo entry choices',
      (tester) async {
    await openEntry(tester);
    expect(find.text('Start exploring'), findsOneWidget);
    expect(find.byKey(const Key('continueEmailButton')), findsOneWidget);
    expect(find.byKey(const Key('demoAccountButton')), findsOneWidget);
    expect(find.byKey(const Key('guestButton')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('demo account immediately enters the shop', (tester) async {
    final user = await openEntry(tester);
    final button = find.byKey(const Key('demoAccountButton'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(user.username, 'Demo Shopper');
    expect(user.email, 'demo@techstore.example');
    expect(find.text('SHOP_READY'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('guest entry does not request personal data', (tester) async {
    final user = await openEntry(tester);
    final button = find.byKey(const Key('guestButton'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(user.username, 'Guest');
    expect(user.email, isEmpty);
    expect(find.text('SHOP_READY'), findsOneWidget);
  });

  testWidgets('invalid email blocks entry and valid email enters demo',
      (tester) async {
    final user = await openEntry(tester);
    final field = find.byKey(const Key('demoEmailField'));
    await tester.enterText(field, 'wrong-email');
    final continueButton = find.byKey(const Key('continueEmailButton'));
    await tester.ensureVisible(continueButton);
    await tester.tap(continueButton);
    await tester.pump();
    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(user.username, isEmpty);

    await tester.enterText(field, 'alex@example.com');
    await tester.tap(continueButton);
    await tester.pumpAndSettle();
    expect(user.username, 'Alex');
    expect(user.email, 'alex@example.com');
    expect(find.text('SHOP_READY'), findsOneWidget);
  });
  testWidgets('entry does not use decorative sparkle or AI icons',
      (tester) async {
    await openEntry(tester);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsNothing);
    expect(find.byIcon(Icons.bolt_rounded), findsNothing);
    expect(find.text('Browse the collection.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('desktop entry keeps the same minimal brand',
      (tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final user = UserProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: user,
        child: const MaterialApp(
          home: LoginPage(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('TECH STORE'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome_rounded), findsNothing);
    expect(find.byIcon(Icons.bolt_rounded), findsNothing);
    expect(tester.takeException(), isNull);
  });

}
