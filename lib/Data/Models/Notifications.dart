import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';


class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

class ScheduleNotification {
  static Future<void> showDailyAtTime(DateTime activityTime, String activityName) async {
    var time = Time(activityTime.hour, activityTime.minute, activityTime.second);
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        activityName,
        activityName,
        activityName);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        '¡Hey! Daily activity approaching: $activityName',
        'Daily notification shown at approximately ${time.hour}:${time.minute}:${time.second}',
        time,
        platformChannelSpecifics);
  }
}
