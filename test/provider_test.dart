import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_app/provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('LocaleProvider persists locale', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = LocaleProvider();
    await provider.setLocale(const Locale('en', 'US'));

    final prefs = await SharedPreferences.getInstance();
    expect(provider.locale, const Locale('en'));
    expect(prefs.getString('language_code'), 'en');

    final newProvider = LocaleProvider();
    await newProvider.loadLocale();
    expect(newProvider.locale, const Locale('en'));
  });

  test('BackgroundColorProvider persists color', () async {
    SharedPreferences.setMockInitialValues({});
    final provider = BackgroundColorProvider();
    await provider.setColor(Colors.grey);

    final prefs = await SharedPreferences.getInstance();
    expect(provider.color, const Color(0xFF9E9E9E));
    expect(prefs.getInt('background_color'), Colors.grey.value);

    final newProvider = BackgroundColorProvider();
    await newProvider.loadColor();
    expect(newProvider.color, const Color(0xFF9E9E9E));
  });
}
