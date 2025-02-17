import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const dateType = 'TEXT NOT NULL'; 

    await db.execute('''
      CREATE TABLE notes (
        id $idType,
        content $textType,
        createdAt $dateType
      )
    ''');
  }

  // Ajout de la gestion de la date lors de la création d'une note
  Future<int> createNote(String content) async {
    final db = await instance.database;
    return await db.insert('notes', {
      'content': content,
      'createdAt': DateTime.now().toIso8601String() // Stocker la date actuelle
    });
  }

  Future<List<Map<String, dynamic>>> readAllNotes() async {
    final db = await instance.database;
    return await db.query('notes', orderBy: 'createdAt DESC'); // Trier par date
  }

  Future<int> updateNote(int id, String content) async {
    final db = await instance.database;
    return await db.update(
      'notes',
      {
        'content': content,
        'createdAt': DateTime.now().toIso8601String() // Mise à jour de la date
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteNote(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
