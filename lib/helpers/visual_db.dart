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

  Future<Database> _openDb() async {
    try {
      return await openDatabase(
        _path,
        version: 1,
        onCreate: (db, version) {
          db.execute('''
CREATE TABLE  $tableName ( 
      $columnId integer primary key autoincrement, 
      $columnTitle text not null,
      $columnDateCreated text not null,
      $columnPicture text not null,
      $columnStatus text not null,
      $columnDescription text not null,
      $columnLastUpdated text)
    ''');
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<VisualNote> insertNote(VisualNote note) async {
    var db = await dbInstance.database;
    note.id = await db.insert(tableName, note.toMap());
    return note;
  }

  Future<List<VisualNote>> getAllNotes() async {
    var db = await dbInstance.database;

    List<Map> noteMaps = await db.rawQuery("SELECT * from $tableName");
    List<VisualNote> notes = noteMaps
        .map((e) => VisualNote.fromMap(e as Map<String, dynamic>))
        .toList();
    return notes;
  }

  Future<int> deleteNote(int id) async {
    var db = await dbInstance.database;

    return await db.rawDelete("DELETE FROM $tableName where id = ?", [id]);
  }

  Future<void> updateNote(VisualNote note) async {
    var db = await dbInstance.database;

    await db.update(tableName, note.toMap(),
        where: '$columnId = ?', whereArgs: [note.id]);
  }

  Future close() async => await dbInstance.database
    ..close();
}
