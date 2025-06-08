import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_models.dart'; // CAMBIAR: usar nuevos modelos
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = []; // Ahora usa Task de task_models.dart
  
  List<Task> get tasks => _tasks;
  
  // Obtener tareas filtradas por usuario activo
  List<Task> getTasksByUser(int userId) {
    return _tasks.where((task) => task.taskUserId == userId).toList();
  }

  Future<void> loadTasksFromAPI(int userId) async {
    try {
      final taskResponses = await TaskService.getTasksByUser(userId);
      _tasks = taskResponses.map((response) => Task.fromTaskResponse(response)).toList();
      notifyListeners();
      await _saveToPreferences();
    } catch (e) {
      print('Error cargando tareas desde API: $e');
      // Si falla, cargar desde caché local
      await _loadFromPreferences();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    await _saveToPreferences();
  }

  // Actualizar tarea
  Future<void> updateTask(Task updatedTask) async {
    try {
      if (updatedTask.taskId != null) {
        // Actualizar en API
        final updateRequest = updatedTask.toUpdateRequest();
        await TaskService.updateTask(updatedTask.taskId!, updateRequest);
      }
      
      // Actualizar localmente
      final index = _tasks.indexWhere((task) => task.taskId == updatedTask.taskId);
      if (index >= 0) {
        _tasks[index] = updatedTask;
        notifyListeners();
        await _saveToPreferences();
      }
    } catch (e) {
      throw Exception('Error actualizando tarea: $e');
    }
  }

  // Eliminar tarea
  Future<void> deleteTask(int taskId) async {
    try {
      // Eliminar en API
      await TaskService.deleteTask(taskId);
      
      // Eliminar localmente
      _tasks.removeWhere((task) => task.taskId == taskId);
      notifyListeners();
      await _saveToPreferences();
    } catch (e) {
      throw Exception('Error eliminando tarea: $e');
    }
  }

  // Alternar estado completado
  Future<void> toggleTaskCompleted(int taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.taskId == taskId);
    if (taskIndex >= 0) {
      final task = _tasks[taskIndex];
      final updatedTask = Task(
        taskId: task.taskId,
        taskTitle: task.taskTitle,
        taskDescription: task.taskDescription,
        taskDate: task.taskDate,
        taskCompleted: !task.taskCompleted,
        taskUserId: task.taskUserId,
      );
      
      await updateTask(updatedTask);
    }
  }

  // Guardar en SharedPreferences
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks_cache', jsonEncode(tasksJson));
  }

  // Cargar desde SharedPreferences
  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks_cache');
    
    if (tasksString != null) {
      final List<dynamic> tasksJson = jsonDecode(tasksString);
      _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }
  }

  // Sincronizar tareas cuando cambie el usuario activo
  Future<void> syncTasksForUser(int userId) async {
    await loadTasksFromAPI(userId);
  }
}