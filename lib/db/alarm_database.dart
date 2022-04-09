import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediala/model/alarm.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/medicine.dart';

class AlarmDatabase {
  static final  AlarmDatabase instance = AlarmDatabase._init();

  static Database ? _database;

  AlarmDatabase._init();

  // initialize DB
  Future<Database?> get database async {
    if (_database!=null) return _database;

    _database = await _initDB('alarms.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const boolType = 'BOOLEAN NOT NULL';
    const intType = 'INTEGER';
    const textType = 'TEXT NOT NULL';
    const timeType = 'TIME NOT NULL';
    const foreignKeyType = 'FOREIGN KEY';

    // create table medicine
    db.execute('''
    CREATE TABLE $tableMedicines(
      ${MedicineFields.id} $idType,
      ${MedicineFields.name} $textType,
      ${MedicineFields.memo} $textType
    )
    ''');

    // create table alarm
    db.execute('''
    CREATE TABLE $tableAlarms(
      ${AlarmFields.id} $idType,
      ${AlarmFields.medicine_id} $intType,
      ${AlarmFields.time} $timeType,
      ${AlarmFields.day_1} $boolType,
      ${AlarmFields.day_2} $boolType,
      ${AlarmFields.day_3} $boolType,
      ${AlarmFields.day_4} $boolType,
      ${AlarmFields.day_5} $boolType,
      ${AlarmFields.day_6} $boolType,
      ${AlarmFields.day_7} $boolType,
      $foreignKeyType(${AlarmFields.medicine_id}) REFERENCES $tableMedicines(${MedicineFields.id})
    )
    ''');

  }

  Future close() async {
    final db = await instance.database;
    db?.close();
  }

  //Try function
  Future<int?> create(Medicine medicine) async {
    final db = await instance.database;
    final id = await db?.insert(tableMedicines, medicine.toJson());
    print('id of inserted medicine is ${id}');
    return  id;
  }

}