import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:visual_notes/visual_note_model.dart';

String tableName = "visualnotes";
String columnId = "id";
String columnTitle = "title";
String columnStatus = "status";
String columnDescription = "description";
String columnPicture = "picture";
String columnDateCreated = "dateCreated";
String columnLastUpdated = "lastUpdated";

class VisualDBHelper {
  VisualDBHelper._internal();

  static final VisualDBHelper dbInstance = VisualDBHelper._internal();

  static Database? _database;
  final _path = "visual_notes.db";

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _openDb();
    return _database!;
  }

  Future _openDb() async {
    try {
      _database = await openDatabase(_path, version: 1,
          onCreate: (Database db, int version) async {
        await _createTable(db);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _createTable(Database db) async {
    if (!await databaseExists(_path)) {
      await db.execute('''
CREATE TABLE  $tableName ( 
      $columnId integer primary key autoincrement, 
      $columnTitle text not null,
      $columnDateCreated text not null,
      $columnPicture text not null,
      $columnStatus text not null,
      $columnDescription text not null,
      $columnLastUpdated text)
    ''');
    }
  }

  Future<VisualNote> insertNote(VisualNote note) async {
    note.id = await _database!.insert(tableName, note.toMap());
    return note;
  }

  Future<List<VisualNote>> getAllNotes() async {
    List<Map> noteMaps = await _database!.rawQuery("SELECT * from $tableName");
    List<VisualNote> notes = noteMaps
        .map((e) => VisualNote.fromMap(e as Map<String, dynamic>))
        .toList();
    return notes;
  }

  Future<int> deleteNote(int id) async {
    return await _database!
        .rawDelete("DELETE FROM $tableName where id = ?", [id]);
  }

  Future<void> updateNote(VisualNote note) async {
    await _database!.update(tableName, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future close() async => dbInstance.close();
}
