import 'package:flutter/material.dart';
import 'package:flutter_app/l10n/localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'provider/provider.dart';  // Corrected import path if necessary
import 'pages/start_page.dart';
import 'pages/food_page.dart';
import 'pages/snack_page.dart';
import 'pages/walk_page.dart';
import 'pages/pupu_page.dart';
import 'widgets/bottom_nav_bar.dart';  // Add this import
import 'widgets/app_bar.dart';  // Add this import

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
              Locale('zh', 'ZH'),
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
              '/main': (context) => const MainScreen(),
            },
          );
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _selectedIndex = _pageController.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isLoggedIn: true),
      body: PageView(
        controller: _pageController,
        children: const [
          FoodPage(),
          SnackPage(),
          WalkPage(),
          PupuPage(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
