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

  Map<String, Object?> toMap() => {
    MedicineFields.id: id,
    MedicineFields.name: name,
    MedicineFields.memo: memo,
  };

  static Medicine fromMap(Map<String, Object?> json) => Medicine(
    json[MedicineFields.name] as String,
    json[MedicineFields.memo] as String,
    json[MedicineFields.id] as int?,
  );

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