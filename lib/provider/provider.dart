// locale_provider.dart
import 'package:flutter/material.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('he', 'IL'); // Default to Hebrew

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    print("Locale change requested to: ${locale.toString()}");
    if (_locale != locale) {
      _locale = locale;
      print("Locale changed to: ${locale.toString()}");
      notifyListeners();
    }
  }
}

