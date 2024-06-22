// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  @override
  final Map<String, dynamic> messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, dynamic> _notInlinedMessages(_) => {
      'authenticationFailed': MessageLookupByLibrary.simpleMessage('认证失败'),
    'by': MessageLookupByLibrary.simpleMessage('by'),
    'clear': MessageLookupByLibrary.simpleMessage('清除'),
    'clearSpecificTime': MessageLookupByLibrary.simpleMessage('清除特定时间'),
    'foodGivenToday': MessageLookupByLibrary.simpleMessage('塔菲今天已经被喂食了！'),
    'foodLabel': MessageLookupByLibrary.simpleMessage('食品'),
    'foodQuestion': MessageLookupByLibrary.simpleMessage('你今天喂塔菲了吗？'),
    'login': MessageLookupByLibrary.simpleMessage('登录'),
    'logout': MessageLookupByLibrary.simpleMessage('退出登录'),
    'password': MessageLookupByLibrary.simpleMessage('密码'),
    'pupuQuestion': MessageLookupByLibrary.simpleMessage('今天没有收集到便便'),
    'pupuTimes': MessageLookupByLibrary.simpleMessage('便便收集时间:'),
    'snackQuestion': MessageLookupByLibrary.simpleMessage('还没有给零食'),
    'snackTimes': MessageLookupByLibrary.simpleMessage('给零食的时间：'),
    'snacksLabel': MessageLookupByLibrary.simpleMessage('小吃'),
    'startPupuNow': MessageLookupByLibrary.simpleMessage('我刚刚收集了便便！'),
    'startSnackNow': MessageLookupByLibrary.simpleMessage('我刚刚给了零食'),
    'startWalkNow': MessageLookupByLibrary.simpleMessage('现在开始遛'),
    'title': MessageLookupByLibrary.simpleMessage('塔菲护理'),
    'undo': MessageLookupByLibrary.simpleMessage('我没有喂她...我按错了'),
    'username': MessageLookupByLibrary.simpleMessage('用户名'),
    'walkGivenToday': MessageLookupByLibrary.simpleMessage('今天的散步已记录！'),
    'walkNotYetEvening': MessageLookupByLibrary.simpleMessage('晚上还没遛'),
    'walkNotYetMorning': MessageLookupByLibrary.simpleMessage('早上还没遛'),
    'walkPeriodEvening': MessageLookupByLibrary.simpleMessage('晚上'),
    'walkPeriodMorning': MessageLookupByLibrary.simpleMessage('早上'),
    'walkQuestion': MessageLookupByLibrary.simpleMessage('你今天遛塔菲了吗？'),
    'walksLabel': MessageLookupByLibrary.simpleMessage('散步'),
    'welcome': MessageLookupByLibrary.simpleMessage('欢迎来到塔菲护理')
  };
}
