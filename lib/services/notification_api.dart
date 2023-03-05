import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future init({bool isScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOS = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,onDidReceiveNotificationResponse: (payload)async{});
  }

  static Future showNotification(
          {int id = 0, String? title, String? body, String? payload}) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future _notificationDetails() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel id',
          'channel name',
          importance: Importance.max,
          icon: 'cloudy',
          colorized: true
        ),
        iOS: DarwinNotificationDetails());
  }
}
