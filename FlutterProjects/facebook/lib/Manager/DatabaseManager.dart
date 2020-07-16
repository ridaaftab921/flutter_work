import 'dart:async';
import 'package:facebook/Data/Profile.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseManager {

  DatabaseManager._privateConstructor();
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }
  _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(path,
        version: 1,
        onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE users (
            id INTEGER PRIMARY KEY,
            name TEXT,
            email TEXT,
            url TEXT,
            expiry TEXT
          )
          ''');
  }
  Future<void> insertUser(Profile user) async {
    final Database db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  getUserWithId(String userId) async {
    final Database db = await database;
    List<dynamic> whereArguments = [userId];

    final List<Map<String, dynamic>> maps = await db.query('users',
        where: 'id',
        whereArgs: whereArguments,
    );

    List users = List.generate(maps.length, (i) {
      return Profile(
        name: maps[i]['name'],
        email: maps[i]['email'],
        url: maps[i]['url'],
        id: maps[i]['id'],
        expiry: maps[i]['expiry'],
      );
    });

    print(users);
    if(!users.isEmpty) {
      Profile user = users.first;
      if (user.name == null && user.email == null && user.url == null) {
        deleteUser(user.id);
        return null;
      }
      return users.first;
    }
  }
  Future<List<Profile>> users() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return Profile(
        name: maps[i]['name'],
        email: maps[i]['email'],
        url: maps[i]['url'],
        id: maps[i]['id'],
        expiry: maps[i]['expiry'],
      );
    });
  }
  Future<void> updateUser(Profile user) async {
    // Get a reference to the database.
    final db = await database;

    print("print user id $user.id  ");
    
    // Update the given Dog.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.id],
    );
  }
  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete(
      'users',
      where: "id = ?",
      whereArgs: [id],
    );
  }
  DateTime concertToDateTime(String date) {
    return DateTime.parse(date);
  }
  bool isValid(DateTime expiryDate) {
    DateTime now = DateTime.now();
    return now.isBefore(expiryDate);
  }
}
