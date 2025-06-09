import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_models.dart';

class UserService {
  static const String baseUrl = 'http://10.0.2.2:5000/api/Users';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',  };

  static Future<LoginResponse> login(LoginRequest loginRequest) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: headers,
        body: jsonEncode(loginRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return LoginResponse.fromJson(data);
      } else {
        throw Exception('Error en login: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión en login: $e');
    }  }

  static Future<UserResponse> register(CreateUserRequest createUserRequest) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: headers,
        body: jsonEncode(createUserRequest.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserResponse.fromJson(data);
      } else {
        throw Exception('Error en registro: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión en registro: $e');
    }  }

  static Future<UserResponse> getUserById(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserResponse.fromJson(data);
      } else {
        throw Exception('Error obteniendo usuario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión obteniendo usuario: $e');
    }  }

  static Future<List<UserResponse>> getAllUsers() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((user) => UserResponse.fromJson(user)).toList();
      } else {
        throw Exception('Error obteniendo usuarios: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión obteniendo usuarios: $e');
    }
  }

  static Future<UserResponse> updateUser(int userId, CreateUserRequest updateUserRequest) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$userId'),
        headers: headers,
        body: jsonEncode(updateUserRequest.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return UserResponse.fromJson(data);
      } else {
        throw Exception('Error actualizando usuario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión actualizando usuario: $e');
    }  }

  static Future<bool> deleteUser(int userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$userId'),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Error eliminando usuario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión eliminando usuario: $e');
    }  }

  static Future<List<dynamic>> getUserTasks(int userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$userId/tasks'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Error obteniendo tareas del usuario: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión obteniendo tareas: $e');
    }
  }
}