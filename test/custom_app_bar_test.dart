import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:flutter_app/l10n/localizations.dart';

void main() {
  testWidgets('shows logout icon when logged in', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
          ChangeNotifierProvider(create: (_) => BackgroundColorProvider()),
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
          home: Scaffold(appBar: const CustomAppBar(isLoggedIn: true)),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.exit_to_app), findsOneWidget);
  });
}
