import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:intl/intl.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final notification = FlutterLocalNotificationsPlugin();

class DoryNotificationService {
  Future<void> initializeTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> initializeNotification() async {
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notification.initialize(
      initializationSettings,
    );
  }

  Future<bool> addNotifcication({
    required int medicineId,
    required String alarmTimeStr,
    required String title, // HH:mm 약 먹을 시간이예요!
    required String body, // {약이름} 복약했다고 알려주세요!
  }) async {
    if (!await permissionNotification) {
      // show native setting page
      return false;
    }

    /// exception
    final now = tz.TZDateTime.now(tz.local);
    final alarmTime = DateFormat('HH:mm').parse(alarmTimeStr);
    final day = (alarmTime.hour < now.hour ||
            alarmTime.hour == now.hour && alarmTime.minute <= now.minute)
        ? now.day + 1
        : now.day;

    /// id
    String alarmTimeId = alarmTimeStr.replaceAll(':', '');
    alarmTimeId = medicineId.toString() +
        alarmTimeId; //1 + 0800 = 10800 아이디와 시간이 이렇게 표시될거야

    /// add schedule notification
    final details = _notificationDetails(
      alarmTimeId, // unique
      title: title,
      body: body,
    );

    await notification.zonedSchedule(
      int.parse(alarmTimeId), // unique
      title,
      body,
      tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        day,
        alarmTime.hour,
        alarmTime.minute,
      ),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    return true;
  }

  NotificationDetails _notificationDetails(
    String id, {
    required String title,
    required String body,
  }) {
    final android = AndroidNotificationDetails(
      id,
      title,
      channelDescription: body,
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = IOSNotificationDetails();

    return NotificationDetails(
      android: android,
      iOS: ios,
    );
  }

  Future<bool> get permissionNotification async {
    if (Platform.isAndroid) {
      return true;
    } else if (Platform.isIOS) {
      return await notification
              .resolvePlatformSpecificImplementation<
                  IOSFlutterLocalNotificationsPlugin>()
              ?.requestPermissions(alert: true, badge: true, sound: true) ??
          false;
    } else {
      return false;
    }
  }
}
