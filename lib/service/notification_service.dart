import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediala/model/alarm.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../main.dart';

class NotificationService {

  static final NotificationService _notificationService = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationDetails androidNotificationsDetails = AndroidNotificationDetails(
    'channel-id',
    'channel-name',
    channelDescription: 'channel-description',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
  );
  static const IOSNotificationDetails iosChannel = IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    //badgeNumber: 1,
    //attachments: List<IOSNotificationAttachment>?
    subtitle: 'subtitle',
    //threadIdentifier: ?
  );

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() async {

    final AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestAlertPermission: false,
      requestBadgePermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
        initializationSettings, onSelectNotification: selectNotification);

    /** tz.initializeTimeZones();
        final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName!));**/
    await AndroidAlarmManager.initialize();
    debugPrint('Alarm manager initialized');
    SendPort? uiSendPort;
    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
    uiSendPort?.send(null);
  }
  Future selectNotification(String? payload) async{
  }
  static const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidNotificationsDetails,
    iOS: iosChannel,
  );
  Future<void> requestIOSPermissions() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  Future<void> showNotificationCustomSound() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your other channel id',
      'your other channel name',
      channelDescription: 'your other channel description',
      sound: RawResourceAndroidNotificationSound('notification'),
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      'custom sound notification title',
      'custom sound notification body',
      platformChannelSpecifics,
    );
  }

  // scheduling alarm
  static Future<void> scheduleAlarm(bool daily, Alarm alarm) async {
    tz.initializeTimeZones();
    //UILocalNotificationDateInterpretation timeInter =  as UILocalNotificationDateInterpretation;
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
    debugPrint('In here');
    debugPrint(tz.TZDateTime.now(tz.local).toString());
    const int insistentFlag = 4;
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails('your channel id', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        additionalFlags: Int32List.fromList(<int>[insistentFlag]));
    final NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    debugPrint(platformChannelSpecifics.toString());
    int alarmId = alarm.id ?? 0;
   await flutterLocalNotificationsPlugin.zonedSchedule(
         alarmId,
        'scheduled title',
        'scheduled body',
        _dailyTime(alarm),
        //tz.TZDateTime.now(tz.local).add(const Duration(seconds: 1)),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime);
  }

  static tz.TZDateTime _dailyTime(Alarm alarm) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, alarm.hour, alarm.minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    print(scheduledDate);
    return scheduledDate;
  }

}
