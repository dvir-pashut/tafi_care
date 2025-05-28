import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/pages/start_page.dart';
import 'package:flutter_app/mongo_methods/mongo_methods.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fake_mongo_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    databaseService = FakeMongoService(authResult: true);
  });

  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(const Locale('en', 'US')),
      child: MaterialApp(
        routes: {
          '/': (_) => const StartPage(),
          '/main': (_) => const Text('main'),
        },
      ),
    );
  }

  testWidgets('login stores credentials and navigates to main', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.enterText(find.byType(TextField).at(0), 'user');
    await tester.enterText(find.byType(TextField).at(1), 'pass');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    expect(find.text('main'), findsOneWidget);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('isLoggedIn'), true);
    expect(prefs.getString('email'), 'user');
  });
}
