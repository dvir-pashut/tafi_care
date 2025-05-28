import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/pages/walk_page.dart';
import 'package:flutter_app/mongo_methods/mongo_methods.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:provider/provider.dart';

import 'fake_mongo_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    databaseService = FakeMongoService(
      walkTimes: {
        'morning': {'time': '07:00', 'updater': 'walker'},
        'evening': {'time': '', 'updater': ''},
      },
    );
  });

  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(const Locale('en', 'US')),
      child: const MaterialApp(home: WalkPage()),
    );
  }

  testWidgets('shows walk times from service', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('07:00'), findsOneWidget);
  });
}
