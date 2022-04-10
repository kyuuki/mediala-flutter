import '../model/alarm.dart';

final String tableMedicines = 'medicines';

class MedicineFields {

  static final List<String> values = [
    /// Add all fields
    id, name, memo
  ];

  static final String id = '_id';
  static final String name = 'name';
  static final String memo = 'memo';
}

class Medicine {
  int? id;
  String name;
  String memo;

  Medicine(this.name, [this.memo = '', this.id]);

  List<Alarm> alarms() {
    return [];
  }

  Map<String, Object?> toJson() => {
    MedicineFields.id: id,
    MedicineFields.name: name,
    MedicineFields.memo: memo,
  };

  Medicine copy ({
    int? id,
    String? name,
    String? memo,
  }) => Medicine (
      name ?? this.name,
      memo ?? this.memo,
      id ?? this.id
  );
}