import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/widgets/bottom_nav_bar.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp() {
    return ChangeNotifierProvider(
      create: (_) => LocaleProvider()..setLocale(const Locale('en', 'US')),
      child: MaterialApp(
        home: Scaffold(
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: 0,
            onItemTapped: (_) {},
          ),
        ),
      ),
    );
  }

  testWidgets('bottom nav bar displays localized labels', (tester) async {
    await tester.pumpWidget(buildApp());
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Snacks'), findsOneWidget);
    expect(find.text('Walks'), findsOneWidget);
    expect(find.text('pupu'), findsOneWidget);
  });
}
