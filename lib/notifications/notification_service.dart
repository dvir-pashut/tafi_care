import 'package:awesome_notifications/awesome_notifications.dart';
import 'dart:async';
import 'package:flutter_app/mongo_methods/mongo_methods.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotifications() async {
    await AwesomeNotifications()
        .initialize('resource://drawable/res_app_icon', [
          NotificationChannel(
            channelKey: 'scheduled_channel',
            channelName: 'Scheduled notifications',
            channelDescription: 'Notification channel for scheduled tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            importance: NotificationImportance.High,
          ),
        ]);

    // Request notification permission on iOS
    await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  static Future<void> createNotification() async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'scheduled_channel',
        title: 'Dog Feeding Reminder',
        body: 'The dog has not been fed today!',
      ),
    );
  }

  static Future<void> scheduleDailyCheck() async {
    String localTimeZone = await AwesomeNotifications()
        .getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 10,
        channelKey: 'scheduled_channel',
        title: 'Daily Dog Feeding Check',
        body: 'Checking if the dog has been fed.',
      ),
      schedule: NotificationCalendar(
        hour: 20,
        minute: 33,
        second: 0,
        timeZone: localTimeZone,
        repeats: true,
      ),
    );
  }

  static Future<void> checkDogFeedingStatus() async {
    final data = await databaseService.getTodayDogData();
    final foodStatus = data['food']['status'] ?? 'false';
    if (foodStatus != 'false') {
      await createNotification();
    }
  }
}
