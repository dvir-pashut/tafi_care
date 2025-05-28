import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/pages/food_page.dart';
import 'package:flutter_app/mongo_methods/mongo_methods.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:provider/provider.dart';

import 'fake_mongo_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    databaseService = FakeMongoService(
      dogData: {
        'food': {'status': 'true', 'updater': 'tester'},
      },
    );
  });

  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(const Locale('en', 'US')),
      child: const MaterialApp(home: FoodPage()),
    );
  }

  testWidgets('displays food status from service', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();
    expect(find.textContaining('tester'), findsOneWidget);
  });
}
