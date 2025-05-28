import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_app/l10n/localizations.dart';
import 'provider/provider.dart';
import 'pages/start_page.dart';
import 'pages/food_page.dart';
import 'pages/snack_page.dart';
import 'pages/walk_page.dart';
import 'pages/pupu_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'widgets/app_bar.dart';
import 'notifications/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firabase/options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotifications();
  await NotificationService.scheduleDailyCheck();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationSettings =
      await FirebaseMessaging.instance.requestPermission(provisional: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => BackgroundColorProvider()),
      ],
      child: Consumer2<LocaleProvider, BackgroundColorProvider>(
        builder: (context, localeProvider, colorProvider, child) {
          return MaterialApp(
            title: 'טאפי קר',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            locale: localeProvider.locale,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('he', 'IL'),
              Locale('zh', 'ZH'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              AppLocalizationsDelegate(),
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
