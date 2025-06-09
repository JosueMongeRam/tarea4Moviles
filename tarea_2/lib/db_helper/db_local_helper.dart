import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_models.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    try {
      _database = await _initDB('tasks.db');
      return _database!;
    } catch (e) {
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE tasks(
          taskId INTEGER PRIMARY KEY AUTOINCREMENT,
          taskTitle TEXT NOT NULL,
          taskDescription TEXT NOT NULL,
          taskDate TEXT NOT NULL,
          taskCompleted INTEGER NOT NULL DEFAULT 0,
          taskUserId INTEGER NOT NULL
        )
      ''');
    } catch (e) {
      rethrow;
    }
  }

  Future<int> insertTask(Task task) async {
    try {
      final db = await instance.database;
      return await db.insert('tasks', task.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Task>> getAllTasks() async {
    try {
      final db = await instance.database;
      final List<Map<String, Object?>> result = await db.query('tasks');
      return result.map((json) => Task.fromMap(json)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<int> updateTask(Task task) async {
    try {
      final db = await instance.database;
      return await db.update(
        'tasks',
        task.toMap(),
        where: 'taskId = ?',
        whereArgs: [task.taskId],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<int> deleteTask(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'tasks',
        where: 'taskId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }

  Future<List<dynamic>> insertMultipleTasks(List<Task> tasks) async {
    final db = await instance.database;
    final batch = db.batch();
    
    for (final task in tasks) {
      batch.insert('tasks', task.toMap());
    }
    
    return await batch.commit();
  }

  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
      _database = null;    } catch (e) {
    }
  }
}