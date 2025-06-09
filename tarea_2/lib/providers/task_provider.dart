import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_models.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = []; 
  
  List<Task> get tasks => _tasks;
    List<Task> getTasksByUser(int userId) {
    return _tasks.where((task) => task.taskUserId == userId).toList();
  }

  Future<void> loadTasksFromAPI(int userId) async {
    try {
      final taskResponses = await TaskService.getTasksByUser(userId);
      _tasks = taskResponses.map((response) => Task.fromTaskResponse(response)).toList();
      notifyListeners();
      await _saveToPreferences();    } catch (e) {
      await _loadFromPreferences();
    }
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    notifyListeners();
    await _saveToPreferences();  }

  Future<void> updateTask(Task updatedTask) async {
    try {
      if (updatedTask.taskId != null) {
        final updateRequest = updatedTask.toUpdateRequest();
        await TaskService.updateTask(updatedTask.taskId!, updateRequest);
      }
      
      final index = _tasks.indexWhere((task) => task.taskId == updatedTask.taskId);
      if (index >= 0) {
        _tasks[index] = updatedTask;
        notifyListeners();
        await _saveToPreferences();
      }
    } catch (e) {
      throw Exception('Error actualizando tarea: $e');
    }  }

  Future<void> deleteTask(int taskId) async {
    try {
      await TaskService.deleteTask(taskId);
      
      _tasks.removeWhere((task) => task.taskId == taskId);
      notifyListeners();
      await _saveToPreferences();
    } catch (e) {
      throw Exception('Error eliminando tarea: $e');
    }  }

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
    }  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks_cache', jsonEncode(tasksJson));
  }

  Future<void> _loadFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString('tasks_cache');
    
    if (tasksString != null) {
      final List<dynamic> tasksJson = jsonDecode(tasksString);
      _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
      notifyListeners();
    }  }

  Future<void> syncTasksForUser(int userId) async {
    await loadTasksFromAPI(userId);
  }
}