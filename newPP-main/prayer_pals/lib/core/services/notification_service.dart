import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:prayer_pals/core/utils/constants.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final MethodChannel platform =
      const MethodChannel('dexterx.dev/flutter_local_notifications_example');
  //NotificationService a singleton object
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    await _configureLocalTimeZone();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  final AndroidNotificationDetails _androidNotificationDetails =
      const AndroidNotificationDetails(
    'channel ID',
    'channel name',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
  );

  final IOSNotificationDetails _iosNotificationDetails =
      const IOSNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
          badgeNumber: null,
          attachments: null,
          subtitle: '',
          threadIdentifier: 'id');

  Future<void> showNotifications() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        0,
        StringConstants.prayerPals,
        StringConstants.justAFriendlyReminder,
        NotificationDetails(iOS: _iosNotificationDetails),
      );
    } else {
      await flutterLocalNotificationsPlugin.show(
        0,
        StringConstants.prayerPals,
        StringConstants.justAFriendlyReminder,
        NotificationDetails(android: _androidNotificationDetails),
      );
    }
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    debugPrint('TimeZone: $currentTimeZone');
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  Future<String> scheduleNotifications(
      BuildContext context, int id, String title, String body) async {
    final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.dial,
        confirmText: StringConstants.okCaps,
        cancelText: StringConstants.cancel,
        helpText: StringConstants.setReminder);
    if (timeOfDay != null) {
      final newTimeOfDay =
          TimeOfDay(hour: timeOfDay.hour + 5, minute: timeOfDay.minute);
      final tzs = tz.TZDateTime.now(tz.local);
      debugPrint('TZS: $tzs');
      if (Platform.isIOS) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            title,
            body,
            _setTimeInstanceForReminder(newTimeOfDay, tzs),
            NotificationDetails(iOS: _iosNotificationDetails),
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.time,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
        debugPrint('Notification Set: $timeOfDay');
        return timeOfDay.format(context);
      } else {
        await flutterLocalNotificationsPlugin.zonedSchedule(
            0,
            StringConstants.prayerPals,
            StringConstants.justAFriendlyReminder,
            _setTimeInstanceForReminder(timeOfDay, tzs),
            NotificationDetails(android: _androidNotificationDetails),
            androidAllowWhileIdle: true,
            matchDateTimeComponents: DateTimeComponents.time,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime);
        debugPrint('Notification Set: $timeOfDay');
        return "${timeOfDay.hour.toString()}:${timeOfDay.minute.toString()}";
      }
    }
    return '';
  }

  tz.TZDateTime _setTimeInstanceForReminder(
      TimeOfDay timeOfDay, tz.TZDateTime tzs) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
      0,
      0,
      0,
    );
    // if (scheduledDate.isBefore(now)) {
    //   scheduledDate = scheduledDate.add(const Duration(days: 1));
    // }
    debugPrint('ScheduledDate: $scheduledDate');
    return scheduledDate;
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(String? payload) async {
  debugPrint('Notification Selected');
}
