import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "snatalabb_v1.db");
    return await openDatabase(
      path,
      version: 3, // Incremented database version
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
    await db.execute(
      "CREATE TABLE profiles("
      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
      "petName TEXT, "
      "ownerName TEXT, "
      "selectedDogType TEXT, "
      "characteristics TEXT"
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
    if (oldVersion < 3) {
      await db.execute(
        "CREATE TABLE profiles("
        "id INTEGER PRIMARY KEY AUTOINCREMENT, "
        "petName TEXT, "
        "ownerName TEXT, "
        "selectedDogType TEXT, "
        "characteristics TEXT"
        ")",
      );
    }
  }

  Future<int> insertProfile(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('profiles', row);
  }

  Future<int> insertBooking(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('bookings', row);
  }

  Future<List<Map<String, dynamic>>> queryAllProfiles() async {
    Database db = await instance.database;
    return await db.query('profiles');
  }

  Future<List<Map<String, dynamic>>> queryAllBookings() async {
    Database db = await instance.database;
    return await db.query('bookings');
  }

  Future<int> updateProfile(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    return await db.update('profiles', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteProfile(int id) async {
    Database db = await instance.database;
    return await db.delete('profiles', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteBooking(int id) async {
    Database db = await instance.database;
    return await db.delete('bookings', where: 'id = ?', whereArgs: [id]);
  }

  static final DatabaseHelper instance = DatabaseHelper();
}
