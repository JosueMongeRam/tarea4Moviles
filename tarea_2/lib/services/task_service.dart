import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_models.dart';

class TaskService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/Tasks';
  static const String usersBaseUrl = 'http://10.0.2.2:5000/api/Users';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  static Future<List<TaskResponse>> getTasksByUser(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$usersBaseUrl/$userId/tasks'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((task) => TaskResponse.fromJson(task)).toList();
      } else {
        throw Exception(
          'Error obteniendo tareas del usuario: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error de conexión obteniendo tareas: $e');
    }
  }

  static Future<TaskResponse> createTask(
    CreateTaskRequest createTaskRequest,
  ) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(createTaskRequest.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TaskResponse.fromJson(data);
      } else {
        throw Exception('Error creando tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión creando tarea: $e');
    }
  }

  static Future<TaskResponse> updateTask(
    int taskId,
    UpdateTaskRequest updateTaskRequest,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$taskId'),
        headers: headers,
        body: jsonEncode(updateTaskRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return TaskResponse.fromJson(data);
      } else {
        throw Exception('Error actualizando tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión actualizando tarea: $e');
    }
  }

  static Future<bool> deleteTask(int taskId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$taskId'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error eliminando tarea: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión eliminando tarea: $e');
    }
  }
}
