// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.
// @dart=2.12
// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = MessageLookup();

typedef String? MessageIfAbsent(
    String? messageStr, List<Object>? args);

class MessageLookup extends MessageLookupByLibrary {
  @override
  String get localeName => 'en';

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'authenticationFailed': MessageLookupByLibrary.simpleMessage('Authentication Failed'),
    'by': MessageLookupByLibrary.simpleMessage('by'),
    'clear': MessageLookupByLibrary.simpleMessage('Clear'),
    'clearSpecificTime': MessageLookupByLibrary.simpleMessage('Clear Specific Time'),
    'foodGivenToday': MessageLookupByLibrary.simpleMessage('Tafi has been fed today!'),
    'foodLabel': MessageLookupByLibrary.simpleMessage('Food'),
    'foodQuestion': MessageLookupByLibrary.simpleMessage('Did you feed Tafi today?'),
    'login': MessageLookupByLibrary.simpleMessage('Login'),
    'logout': MessageLookupByLibrary.simpleMessage('Logout'),
    'password': MessageLookupByLibrary.simpleMessage('Password'),
    'pupuLabel': MessageLookupByLibrary.simpleMessage('Pupu'),
    'pupuQuestion': MessageLookupByLibrary.simpleMessage('no pupu was collected today'),
    'pupuTimes': MessageLookupByLibrary.simpleMessage('pupu was collected at:'),
    'snackQuestion': MessageLookupByLibrary.simpleMessage('No snacks given yet'),
    'snackTimes': MessageLookupByLibrary.simpleMessage('Snacks given at:'),
    'snacksLabel': MessageLookupByLibrary.simpleMessage('Snacks'),
    'startPupuNow': MessageLookupByLibrary.simpleMessage('i just collected pupu!!!!'),
    'startSnackNow': MessageLookupByLibrary.simpleMessage('I gave Snack just Now'),
    'startWalkNow': MessageLookupByLibrary.simpleMessage('Start Walk Now'),
    'title': MessageLookupByLibrary.simpleMessage('Tafi Care'),
    'undo': MessageLookupByLibrary.simpleMessage('I didn\'t feed her... I pressed by mistake'),
    'username': MessageLookupByLibrary.simpleMessage('Username'),
    'walkGivenToday': MessageLookupByLibrary.simpleMessage('Walk recorded for today!'),
    'walkNotYetEvening': MessageLookupByLibrary.simpleMessage('No evening walk yet'),
    'walkNotYetMorning': MessageLookupByLibrary.simpleMessage('No morning walk yet'),
    'walkPeriodEvening': MessageLookupByLibrary.simpleMessage('Evening'),
    'walkPeriodMorning': MessageLookupByLibrary.simpleMessage('Morning'),
    'walkQuestion': MessageLookupByLibrary.simpleMessage('Did you walk Tafi today?'),
    'walksLabel': MessageLookupByLibrary.simpleMessage('Walks'),
    'welcome': MessageLookupByLibrary.simpleMessage('Welcome to Tafi Care')
  };
}
