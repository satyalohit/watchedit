import 'package:flutter/scheduler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBHelper {
  static Future<Database> database() async {
    final dbpath = await getDatabasesPath();
    return openDatabase(path.join(dbpath, 'movies.db'),
        onCreate: (db, version) {
      Batch batch = db.batch();

      batch.execute(
          'CREATE TABLE movies(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,name VARCHAR(100) NOT NULL,director VARCHAR(100) NOT NULL,posterurl LONGTEXT NULL,email VARCHAR(100) NOT NULL)');
      return batch.commit();
    }, version: 1);
  }

  static Future<int> insert(
    String table,
    Map<String, Object> data,
  ) async {
    final db = await DBHelper.database();
    db
        .insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      return value;
    });
    return 0;
  }

  static Future<List<Map<String, dynamic>>> getData(
      String table, String email) async {
    final db = await DBHelper.database();
    return db.query(table, where: "email=?", whereArgs: [email]);
  }

  static Future<void> truncate(table) async {
    final db = await DBHelper.database();
    db.execute('delete from $table');
  }

  static Future<void> delete(
    String table,
    String id,
  ) async {
    final db = await DBHelper.database();
    db.delete(table, where: 'id=?', whereArgs: [id]);
  }

  static Future<void> update(
    String table,
    String id,
    Map<String, Object> data,
  ) async {
    final db = await DBHelper.database();
    db.update(table, data, where: 'id=?', whereArgs: [id]);
  }
}
