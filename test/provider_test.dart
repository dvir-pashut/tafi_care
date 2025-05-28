import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('default locale is Hebrew', () async {
    final provider = LocaleProvider();
    await provider.loadLocale();
    expect(provider.locale, const Locale('he', 'IL'));
  });

  test('setLocale updates locale and saves preference', () async {
    final provider = LocaleProvider();
    await provider.setLocale(const Locale('en', 'US'));
    expect(provider.locale, const Locale('en', 'US'));
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('language_code'), 'en');
  });

  test('loadLocale reads saved preference', () async {
    SharedPreferences.setMockInitialValues({'language_code': 'zh'});
    final provider = LocaleProvider();
    await provider.loadLocale();
    expect(provider.locale, const Locale('zh'));
  });
}
