import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, "example.db");
    return await openDatabase(
      path,
      version: 2, // Updated version to 2
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
      "CREATE TABLE example(id INTEGER PRIMARY KEY, name TEXT)",
    );
    await db.execute(
      "CREATE TABLE bookings("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "profileId TEXT, "
      "role TEXT, "
      "date TEXT, "
      "hour TEXT"
      ")",
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute(
        "CREATE TABLE bookings("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "profileId TEXT, "
        "role TEXT, "
        "date TEXT, "
        "hour TEXT"
        ")",
      );
    }
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('example', row);
  }

  Future<int> insertBooking(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('bookings', row);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await instance.database;
    return await db.query('example');
  }

  Future<List<Map<String, dynamic>>> queryAllBookings() async {
    Database db = await instance.database;
    return await db.query('bookings');
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('example', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete('example', where: 'id = ?', whereArgs: [id]);
  }

  static final DatabaseHelper instance = DatabaseHelper();
}
