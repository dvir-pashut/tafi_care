import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'messages_all.dart'; // Make sure this line points to your generated messages

class AppLocalizations {
  static Future<AppLocalizations> load(Locale locale) {
  final String name = locale.countryCode!.isEmpty ? locale.languageCode : locale.toString();
  final localeName = Intl.canonicalizedLocale(name);
  print("AppLocalizations loading locale: $localeName");
  return initializeMessages(localeName).then((bool _) {
    Intl.defaultLocale = localeName;
    return AppLocalizations();
  });
}


  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // General
  String get title => Intl.message('טאפי קר', name: 'title');
  String get welcome => Intl.message('ברוך הבא לטאפי קר', name: 'welcome');
  String get username => Intl.message('שם משתמש', name: 'username');
  String get password => Intl.message('סיסמא', name: 'password');
  String get login => Intl.message('התחברות', name: 'login');
  String get logout => Intl.message('Logout', name: 'logout');
  String get undo => Intl.message('I didn not feed her... I pressed by mistake', name: 'undo');

  // Authentication
  String get authenticationFailed => Intl.message('Authentication Failed', name: 'authenticationFailed');

  // Food Page
  String get foodQuestion => Intl.message('Did you feed Tafi today?', name: 'foodQuestion');
  String get foodGivenToday => Intl.message('Tafi has been fed today!', name: 'foodGivenToday');

  // Snack Page
  String get snackQuestion => Intl.message('No snacks given yet', name: 'snackQuestion');
  String get snackTimes => Intl.message('Snacks given at: ', name: 'snackTimes');
  String get startSnackNow => Intl.message('I gave Snack just Now', name: 'startSnackNow');
  String get clearSpecificTime => Intl.message('Clear Specific Time', name: 'clearSpecificTime');

  // Walk Page
  String get walkQuestion => Intl.message('Did you walk Tafi today?', name: 'walkQuestion');
  String get walkGivenToday => Intl.message('Walk recorded for today!', name: 'walkGivenToday');
  String get walkPeriodMorning => Intl.message("Morning", name: 'walkPeriodMorning', desc: 'Label for morning walk period');
  String get walkPeriodEvening => Intl.message("Evening", name: 'walkPeriodEvening', desc: 'Label for evening walk period');
  String get walkNotYetMorning => Intl.message("No morning walk yet", name: 'walkNotYetMorning', desc: 'Message shown when no morning walk has been recorded');
  String get walkNotYetEvening => Intl.message("No evening walk yet", name: 'walkNotYetEvening', desc: 'Message shown when no evening walk has been recorded');
  String get startWalkNow => Intl.message('Start Walk Now', name: 'startWalkNow');
  String get clear => Intl.message('Clear', name: 'clear');

  // bottom navigation bar
  String get foodLabel => Intl.message('Food', name: 'foodLabel');
  String get snacksLabel => Intl.message('Snacks', name: 'snacksLabel');
  String get walksLabel => Intl.message('Walks', name: 'walksLabel');
  String get pupuLabel => Intl.message('pupu', name: 'pupuLabel');
  
  // pupu
  String get pupuQuestion => Intl.message('no pupu was collected today', name: 'pupuQuestion');
  String get pupuTimes => Intl.message('pupu was collected at:', name: 'pupuTimes');
  String get startPupuNow => Intl.message('i just collected pupu', name: 'startPupuNow');

  //general
  String get by => Intl.message('by', name: 'by');

}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'he', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

