import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../classes/task.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    try {
      // Establecer el método de inicialización
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
      // Obtener la ubicación de la base de datos según la plataforma
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, filePath);
      print("Database path: $path");
      
      // Abrir o crear la base de datos
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
      // Crear la tabla usando una transacción
      await db.execute('''
        CREATE TABLE tasks(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          description TEXT NOT NULL,
          date TEXT NOT NULL,
          status TEXT NOT NULL
        )
      ''');
      print("Table created successfully");
    } catch (e) {
      print("Error creating table: $e");
      rethrow;
    }
  }

  // CRUD operations utilizando transacciones para operaciones críticas
  Future<int> insertTask(Task task) async {
    try {
      final db = await instance.database;
      return await db.insert('tasks', task.toMap());
    } catch (e) {
      print("Error inserting task: $e");
    rethrow;
    }
  }

  // Obtener todas las tareas
  Future<List<Task>> getAllTasks() async {
    try {
      final db = await instance.database;
      final List<Map<String, Object?>> result = await db.query('tasks');
      print("Retrieved ${result.length} tasks from database");
      return result.map((json) => Task.fromMap(json)).toList();
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
        where: 'id = ?',
        whereArgs: [task.id],
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
        where: 'id = ?',
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
      _database = null; // Limpiamos la referencia
      print("Database closed successfully");
    } catch (e) {
      print("Error closing database: $e");
    }
  }
}