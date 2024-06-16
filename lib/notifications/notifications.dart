// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import '../mongo_methods/mongo_methods.dart';

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//   @override
//   void initState() {
//     super.initState();
//     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//     _initializeNotifications();
//     _scheduleDailyFoodCheck();
//   }

//   Future<void> _initializeNotifications() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     const IOSInitializationSettings initializationSettingsIOS =
//         IOSInitializationSettings();

//     const InitializationSettings initializationSettings = InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   Future<void> _scheduleDailyFoodCheck() async {
//     var androidDetails = const AndroidNotificationDetails(
//       'daily_food_id',
//       'Daily Food Check',
//       channelDescription: 'Check if food has been given',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     var iOSDetails = const IOSNotificationDetails();
//     var platformDetails = NotificationDetails(android: androidDetails, iOS: iOSDetails);

//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       0,
//       'Food Time!',
//       'Did you feed the dog?',
//       _nextInstanceOfSixPM(),
//       platformDetails,
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents: DateTimeComponents.time,
//     );

//     _checkFoodStatusAndNotify();
//   }

//   tz.TZDateTime _nextInstanceOfSixPM() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 18);
//     if (scheduledDate.isBefore(now)) {
//       scheduledDate = scheduledDate.add(const Duration(days: 1));
//     }
//     return scheduledDate;
//   }

//   Future<void> _checkFoodStatusAndNotify() async {
//     // Replace with your MongoDB fetching logic
//     final data = await MongoDatabase.getTodayDogData();
//     if (data.isEmpty || data['food'] != 'true') {
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         'Food Time!',
//         'Did you feed the dog?',
//         const NotificationDetails(
//           android: AndroidNotificationDetails(
//             'daily_food_id',
//             'Daily Food Check',
//             channelDescription: 'Check if food has been given',
//             importance: Importance.max,
//             priority: Priority.high,
//           ),
//           iOS: IOSNotificationDetails(),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Flutter Notification Demo'),
//       ),
//       body: const Center(
//         child: Text('Notifications scheduled for 6:00 PM daily.'),
//       ),
//     );
//   }
// }
