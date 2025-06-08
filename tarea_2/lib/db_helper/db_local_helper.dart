import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task_models.dart'; // CAMBIAR: usar nuevos modelos

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    try {
      _database = await _initDB('tasks.db');
      print("Database initialized successfully");
      return _database!;
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future<Database> _initDB(String filePath) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      print("Database path: $path");
      
      return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB,
        onOpen: (db) {
          print("Database opened successfully");
        },
      );
    } catch (e) {
      print("Error in _initDB: $e");
      rethrow;
    }
  }

  Future<void> _createDB(Database db, int version) async {
    try {
      // ACTUALIZAR: esquema para los nuevos modelos
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
      print("Table created successfully");
    } catch (e) {
      print("Error creating table: $e");
      rethrow;
    }
  }

  // CRUD operations - ACTUALIZADAS para nuevos modelos
  Future<int> insertTask(Task task) async {
    try {
      final db = await instance.database;
      return await db.insert('tasks', task.toMap()); // Usar toMap() de task_models.dart
    } catch (e) {
      print("Error inserting task: $e");
      rethrow;
    }
  }

  Future<List<Task>> getAllTasks() async {
    try {
      final db = await instance.database;
      final List<Map<String, Object?>> result = await db.query('tasks');
      print("Retrieved ${result.length} tasks from database");
      return result.map((json) => Task.fromMap(json)).toList(); // Usar fromMap() de task_models.dart
    } catch (e) {
      print("Error getting all tasks: $e");
      return [];
    }
  }

  // Actualizar una tarea existente
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
      print("Error updating task: $e");
      return 0;
    }
  }

  // Eliminar una tarea por ID
  Future<int> deleteTask(int id) async {
    try {
      final db = await instance.database;
      return await db.delete(
        'tasks',
        where: 'taskId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      print("Error deleting task: $e");
      return 0;
    }
  }

  // Método para insertar múltiples tareas en una sola transacción (batch)
  Future<List<dynamic>> insertMultipleTasks(List<Task> tasks) async {
    final db = await instance.database;
    final batch = db.batch();
    
    for (final task in tasks) {
      batch.insert('tasks', task.toMap());
    }
    
    return await batch.commit();
  }

  // Cerrar la base de datos cuando sea necesario
  Future<void> close() async {
    try {
      final db = await instance.database;
      await db.close();
      _database = null;
      print("Database closed successfully");
    } catch (e) {
      print("Error closing database: $e");
    }
  }
}