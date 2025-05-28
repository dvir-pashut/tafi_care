import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/pages/snack_page.dart';
import 'package:flutter_app/mongo_methods/mongo_methods.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:provider/provider.dart';

import 'fake_mongo_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    databaseService = FakeMongoService(
      snackData: [
        {'time': '08:00', 'updater': 'me'},
      ],
    );
  });

  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(const Locale('en', 'US')),
      child: const MaterialApp(home: SnackPage()),
    );
  }

  testWidgets('shows snack times from service', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('08:00'), findsOneWidget);
  });
}
