import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'messages_all.dart'; // Make sure this line points to your generated messages

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
    final String name = locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    print("Loading messages for: $localeName");
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return AppLocalizations();
    });
  }


  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String get title {
    return Intl.message('טאפי קר', name: 'title');
  }

  String get welcome {
    return Intl.message('ברוך הבא לטאפי קר', name: 'welcome');
  }

  String get username {
    return Intl.message('שם משתמש', name: 'username');
  }

  String get password {
    return Intl.message('סיסמא', name: 'password');
  }

  String get login {
    return Intl.message('התחברות', name: 'login');
  }

  String get authenticationFailed {
    return Intl.message('Authentication Failed', name: 'authenticationFailed');
  }

  String get logout {
    return Intl.message('Logout', name: 'logout');
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'he'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
