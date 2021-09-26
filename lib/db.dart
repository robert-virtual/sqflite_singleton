import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_singleton/models/note.dart';

class DB {
  static Future<Database> _openDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'my_notes.db');
    return openDatabase(path, onCreate: _oncreate, version: 1);
  }

  static _oncreate(Database db, int version) {
    return db.execute("""
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY,
        title TEXT,
        content TEXT,
        date TEXT
      )
    """);
  }

  static Future<int> createNote(Note note) async {
    final db = await _openDB();
    return db.insert('notes', note.toMap());
  }

  static Future<Note> findOneNote(int id) async {
    final db = await _openDB();
    final map = await db.query('notes', where: "id = ?", whereArgs: [id]);
    return Note.fromMap(map.first);
  }

  static Future<List<Note>> findNotes() async {
    final db = await _openDB();
    final data = await db.query('notes',orderBy: "id DESC");
    return data.map((e) => Note.fromMap(e)).toList();
  }

  static Future<int> updateNote(Note note) async {
    final db = await _openDB();
    return db.update('notes', note.toMap(),where: "id = ?",whereArgs: [note.id]);
  }

  static Future<int> deleteNote(int id) async {
    final db = await _openDB();
    return db.delete('notes', where: "id = ?", whereArgs: [id]);
  }
}
