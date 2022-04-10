import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final String tableAlarms = 'alarms';

class AlarmFields {

  static final List<String> values = [
    /// Add all fields
    id,
    medicine_id,
    time,
    day_1,
    day_2,
    day_3,
    day_4,
    day_5,
    day_6,
    day_7
  ];

  static final String id = '_id';
  static final String medicine_id = 'medicine_id';
  static final String time = 'time';
  static final String day_1 = 'day_1';
  static final String day_2 = 'day_2';
  static final String day_3 = 'day_3';
  static final String day_4 = 'day_4';
  static final String day_5 = 'day_5';
  static final String day_6 = 'day_6';
  static final String day_7 = 'day_7';
}

class Alarm {
  static const List<String> dayTexts = [ "日", "月", "火", "水", "木", "金", "土" ];  // TODO: 曜日クラス作成

  int hour = 0;
  int minute = 0;
  String? timeOfMedicine;
  int medicine_id;
  int? id;
  bool? day_1;
  bool? day_2;
  bool? day_3;
  bool? day_4;
  bool? day_5;
  bool? day_6;
  bool? day_7;
  List<bool> days = [ false, false, false, false, false, false, false ];

  Alarm(this.hour, this.minute, this.days, this.medicine_id, [this.id]) {
    if (days.length != 7) {
      throw Error();
    }
    // Assigning values in single variable for easily storing in DB
    day_1 = days[0];
    day_2 = days[1];
    day_3 = days[2];
    day_4 = days[3];
    day_5 = days[4];
    day_6 = days[5];
    day_7 = days[6];

    // Changing into time
    timeOfMedicine = hour.toString()+':' +minute.toString();
  }

  Alarm.fromDB(
      this.id,
      @required this.medicine_id,
      @required this.timeOfMedicine,
      @required this.day_1,
      @required this.day_2,
      @required this.day_3,
      @required this.day_4,
      @required this.day_5,
      @required this.day_6,
      @required this.day_7) {
     days[0] = day_1!;
     days[1] = day_2!;
     days[2] = day_3!;
     days[3] = day_4!;
     days[4] = day_5!;
     days[5] = day_6!;
     days[6] = day_7!;
     //hour = ;
     //minute = timeOfMedicine!. minute;
  }

  Map<String, Object?> toMap() => {
    AlarmFields.id: id,
    AlarmFields.medicine_id: medicine_id,
    AlarmFields.time: timeOfMedicine,
    AlarmFields.day_1: day_1! ? 1 : 0,
    AlarmFields.day_2: day_2! ? 1 : 0,
    AlarmFields.day_3: day_3! ? 1 : 0,
    AlarmFields.day_4: day_4! ? 1 : 0,
    AlarmFields.day_5: day_5! ? 1 : 0,
    AlarmFields.day_6: day_6! ? 1 : 0,
    AlarmFields.day_7: day_7! ? 1 : 0,
  };

  static Alarm fromMap(Map<String, Object?> json) {
    print(json[AlarmFields.time]);
    print(json[AlarmFields.day_1]);
    print(json[AlarmFields.day_2]);
    print(json[AlarmFields.day_3]);

    return Alarm.fromDB(
      json[AlarmFields.id] as int?,
      json[AlarmFields.medicine_id] as int,
      json[AlarmFields.time] as String,
      json[AlarmFields.day_1] == 1,
      json[AlarmFields.day_2] == 1,
      json[AlarmFields.day_3] == 1,
      json[AlarmFields.day_4] == 1,
      json[AlarmFields.day_5] == 1,
      json[AlarmFields.day_6] == 1,
      json[AlarmFields.day_7] == 1,
    );
  }

  Alarm idCopy ({
    int? id,
    int? medicine_id,
    String? time,
    bool? day_1,
    bool? day_2,
    bool? day_3,
    bool? day_4,
    bool? day_5,
    bool? day_6,
    bool? day_7,
  }) => Alarm.fromDB(
    id ?? this.id,
    medicine_id ?? this.medicine_id,
    time ?? timeOfMedicine,
    day_1 ?? this.day_1,
    day_2 ?? this.day_2,
    day_3 ?? this.day_3,
    day_4 ?? this.day_4,
    day_5 ?? this.day_5,
    day_6 ?? this.day_6,
    day_7 ?? this.day_7,
  );

}