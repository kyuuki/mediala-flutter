import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mediala/db/mediala_database.dart';
import 'package:mediala/model/alarm.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../main.dart';

class NotificationService {

  static final NotificationService _notificationService = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const String notificationTitle = 'お薬アラーム';
  static const String notificationBody = 'の時間になりました。';
  static const String channelId = '0';
  static const String channelName = 'メッセージ通知';
  static const String channelDescription = 'お薬の時間を通知します。';

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

  //
  // NotificationDetails 生成
  //
  static NotificationDetails createNotificationDetails() {
    const int insistentFlag = 4;

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(channelId, channelName,
            channelDescription: channelDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker',
            additionalFlags: Int32List.fromList(<int>[insistentFlag]),
            largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher')
        );

    return NotificationDetails(android: androidPlatformChannelSpecifics);
  }

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

  // scheduling alarm
  static Future<void> scheduleAlarm(Alarm alarm) async {
    tz.initializeTimeZones();
    //UILocalNotificationDateInterpretation timeInter =  as UILocalNotificationDateInterpretation;
    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
    debugPrint('In here');
    debugPrint(tz.TZDateTime.now(tz.local).toString());

    final int alarmId = alarm.id ?? 0;
    String medicineName = await getMedicineName(alarm.medicineId);
    String zoneNotificationBody = medicineName + notificationBody;
    bool daily = checkDaily(alarm);
    if (daily) {
      print("For daily");
      var zoneAlarmId = alarmId*100;
      await flutterLocalNotificationsPlugin.zonedSchedule(
          zoneAlarmId,
          notificationTitle,
          zoneNotificationBody,
          _dailyTime(alarm),
          createNotificationDetails(),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time);
    }

    else {
      var zoneAlarmId;
      print("For specific day");
      for (int i=0; i<alarm.days.length; i++) {
        if (alarm.days[i]) {
          zoneAlarmId = (alarmId*100)+(i+1);
          await _scheduleWeekly(alarm,i,zoneAlarmId);
        }
      }
    }
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

  // Scheduling weekly alarm
  static Future<void> _scheduleWeekly(Alarm alarm, int day, int alarmID) async {

    final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
    debugPrint('In here');
    debugPrint(tz.TZDateTime.now(tz.local).toString());
    String medicineName = await getMedicineName(alarm.medicineId);
    medicineName = medicineName + notificationBody;

    await flutterLocalNotificationsPlugin.zonedSchedule(
        alarmID,
        notificationTitle,
        medicineName,
        _nextInstanceOfWeek(alarm, day),
        createNotificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static tz.TZDateTime _nextInstanceOfWeek(Alarm alarm, int alarmDay) {
    tz.TZDateTime scheduledDate = _dailyTime(alarm);
    if (alarmDay == 0) {
      while (scheduledDate.weekday != DateTime.sunday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    else if (alarmDay == 1) {
      while (scheduledDate.weekday != DateTime.monday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    else if (alarmDay == 2) {
      while (scheduledDate.weekday != DateTime.tuesday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    else if (alarmDay == 3) {
      while (scheduledDate.weekday != DateTime.wednesday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    else if (alarmDay == 4) {
      while (scheduledDate.weekday != DateTime.thursday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    else if (alarmDay == 5) {
      while (scheduledDate.weekday != DateTime.friday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    else {
      while (scheduledDate.weekday != DateTime.saturday) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }
    }
    return scheduledDate;
  }

  static bool checkDaily(Alarm alarm) {
    bool isDaily = true;
    var falseCount = alarm.days.where((item) => item == false).length;
    if (falseCount!=0) {
      isDaily = false;
    }
    return isDaily;
  }

  static Future<void> cancelNotification(Alarm alarm) async {
    int alarmId = alarm.id ?? 0;
    if (checkDaily(alarm)) {
      print ("in cancel");
      await flutterLocalNotificationsPlugin.cancel(alarmId*100);
    }
    else {
      for (int i =0; i<alarm.days.length; i++) {
        if (alarm.days[i]) {
          print ("in cancel");
          await flutterLocalNotificationsPlugin.cancel((alarmId*100)+(i+1));
        }
      }
    }
  }

  static Future<String> getMedicineName(int medicineId) async {
    return MediaAlaDatabase.instance.getMedicineName(medicineId);
  }

}
