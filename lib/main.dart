import 'package:flutter/material.dart';
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
    return MaterialApp(
      title: 'Tafi Care',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/main',
      routes: {
        '/': (context) => const StartPage(),
        '/main': (context) => const FoodPage(),
        '/snack': (context) => const SnackPage(),  // Add route for snack page
        '/walk': (context) => const WalkPage(),    // Add route for walk page
      },
    );
  }
}
