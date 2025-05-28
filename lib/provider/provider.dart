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

class BackgroundColorProvider with ChangeNotifier {
  Color _color = Colors.white;

  BackgroundColorProvider() {
    loadColor();
  }

  Color get color => _color;

  Future<void> loadColor() async {
    final prefs = await SharedPreferences.getInstance();
    int? colorValue = prefs.getInt('background_color');
    if (colorValue != null) {
      _color = Color(colorValue);
    }
    notifyListeners();
  }

  Future<void> setColor(Color newColor) async {
    if (_color != newColor) {
      _color = newColor;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('background_color', newColor.value);
    }
  }
}
