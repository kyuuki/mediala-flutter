import 'package:sprintf/sprintf.dart';

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

  int? id;  // 保存前は null
  int medicineId;
  int hour = 0;
  int minute = 0;
  List<bool> days = [ false, false, false, false, false, false, false ];

  // DB にアクセスする直前と直後に作ればいいので保持しておく必要はない
  // String? timeOfMedicine;
  // bool? day_1;
  // bool? day_2;
  // bool? day_3;
  // bool? day_4;
  // bool? day_5;
  // bool? day_6;
  // bool? day_7;

  Alarm(this.hour, this.minute, this.days, this.medicineId, [this.id]) {
    if (days.length != 7) {
      throw Error();
    }
  }

  Map<String, Object?> toMap() => {
    AlarmFields.id: id,
    AlarmFields.medicine_id: medicineId,
    AlarmFields.time: sprintf("%02d:%02d", [ hour, minute ]),
    AlarmFields.day_1: days[0] ? 1 : 0,
    AlarmFields.day_2: days[1] ? 1 : 0,
    AlarmFields.day_3: days[2] ? 1 : 0,
    AlarmFields.day_4: days[3] ? 1 : 0,
    AlarmFields.day_5: days[4] ? 1 : 0,
    AlarmFields.day_6: days[5] ? 1 : 0,
    AlarmFields.day_7: days[6] ? 1 : 0,
  };

  static Alarm fromMap(Map<String, Object?> map) {
    print(map[AlarmFields.time]);
    print(map[AlarmFields.day_1]);
    print(map[AlarmFields.day_2]);
    print(map[AlarmFields.day_3]);

    // TODO: map[AlarmFields.time] を hour と minute に分割
    int hour = 10;
    int minute = 0;

    return Alarm(
      hour,
      minute,
      [
        map[AlarmFields.day_1] == 1,
        map[AlarmFields.day_2] == 1,
        map[AlarmFields.day_3] == 1,
        map[AlarmFields.day_4] == 1,
        map[AlarmFields.day_5] == 1,
        map[AlarmFields.day_6] == 1,
        map[AlarmFields.day_7] == 1,
      ],
      map[AlarmFields.medicine_id] as int,
      map[AlarmFields.id] as int?,
    );
  }

}