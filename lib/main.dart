import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'provider/provider.dart';  // Corrected import path if necessary
import 'pages/start_page.dart';
import 'pages/food_page.dart';
import 'pages/snack_page.dart';
import 'pages/walk_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocaleProvider(),
      child: Consumer<LocaleProvider>( // Use Consumer to rebuild on locale change
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'טאפי קר',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: provider.locale, // Reflects the current locale from LocaleProvider
            supportedLocales: const [
              Locale('en', 'US'),  // English
              Locale('he', 'IL'),  // Hebrew
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizationsDelegate(), // Ensure your custom delegate is listed
            ],
            localeResolutionCallback: (locale, supportedLocales) {
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },
            initialRoute: '/',
            routes: {
              '/': (context) => const StartPage(),
              '/main': (context) => const FoodPage(),
              '/snack': (context) => const SnackPage(),
              '/walk': (context) => const WalkPage(),
            },
          );
        },
      ),
    );
  }
}
