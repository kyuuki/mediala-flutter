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