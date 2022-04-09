import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
    const intType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';

    db.execute('''
    CREATE TABLE $tableMedicines(
      ${MedicineFields.id} $idType,
      ${MedicineFields.name} $textType,
      ${MedicineFields.memo} $textType
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