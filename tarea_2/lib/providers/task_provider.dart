import 'package:flutter/foundation.dart';
import 'package:tarea_2/classes/task.dart';
import 'package:tarea_2/db_helper/db_local_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  bool _initialized = false;

  List<Task> get tasks => _tasks;
  bool get isInitialized => _initialized;

  TaskProvider() {
    // No llamar a _loadTasks aquí, dejarlo para initialize
  }

  // Método explícito de inicialización
  Future<void> initialize() async {
    if (!_initialized) {
      await _loadTasks();
      _initialized = true;
    }
  }

  Future<void> _loadTasks() async {
    try {
      _tasks = await DatabaseHelper.instance.getAllTasks();
      notifyListeners();
    } catch (e) {
      print("Error loading tasks: $e");
      _tasks = []; // Usar lista vacía en caso de error
    }
  }

  Future<void> addTask(Task task) async {
    int id = await DatabaseHelper.instance.insertTask(task);
    
    task.id = id;
    _tasks.add(task);
    
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    await DatabaseHelper.instance.updateTask(task);
    
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index >= 0) {
      _tasks[index] = task;
      notifyListeners();
    }
  }

  Future<void> deleteTask(int taskId) async {
    await DatabaseHelper.instance.deleteTask(taskId);
    
    _tasks.removeWhere((task) => task.id == taskId);
    notifyListeners();
  }
}