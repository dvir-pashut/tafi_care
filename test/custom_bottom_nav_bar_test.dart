import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/widgets/bottom_nav_bar.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:flutter_app/l10n/localizations.dart';

void main() {
  testWidgets('tapping navigation item notifies callback', (WidgetTester tester) async {
    int tappedIndex = -1;

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => BackgroundColorProvider()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('he', 'IL'),
            Locale('zh', 'ZH'),
          ],
          home: Scaffold(
            bottomNavigationBar: CustomBottomNavBar(
              selectedIndex: 0,
              onItemTapped: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.cake));
    await tester.pump();

    expect(tappedIndex, 1);
  });
}
