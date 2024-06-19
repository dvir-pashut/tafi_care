import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('he', 'IL'); // Default to Hebrew directly

  LocaleProvider() {
    loadLocale();
  }

  Locale get locale => _locale;

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String? langCode = prefs.getString('language_code');
    if (langCode != null) {
      _locale = Locale(langCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale != locale) {
      _locale = locale;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', locale.languageCode);
    }
  }
}

