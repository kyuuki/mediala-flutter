import '../model/alarm.dart';

class Medicine {
  String name;
  String memo;

  Medicine(this.name, this.memo);

  List<Alarm> alarms() {
    return [];
  }
}