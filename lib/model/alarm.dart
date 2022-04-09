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
  List<bool> days = [ false, false, false, false, false, false, false ];
  Alarm(this.hour, this.minute, this.days) {
    if (days.length != 7) {
      throw Error();
    }
  }
}