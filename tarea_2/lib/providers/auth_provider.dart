import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_models.dart';

class AuthProvider with ChangeNotifier {
  List<User> _loggedUsers = []; // Lista de usuarios logueados
  User? _currentUser; // Usuario actualmente activo
  
  // Getters
  List<User> get loggedUsers => _loggedUsers;
  User? get currentUser => _currentUser;
  bool get hasLoggedUsers => _loggedUsers.isNotEmpty;
  bool get isLoggedIn => _currentUser != null;

  // Agregar usuario tras login exitoso
  Future<void> addUser(User user) async {
    // Verificar si el usuario ya está logueado
    final existingIndex = _loggedUsers.indexWhere((u) => u.userId == user.userId);
    
    if (existingIndex >= 0) {
      // Usuario ya existe, actualizarlo y hacerlo activo
      _loggedUsers[existingIndex] = user;
    } else {
      // Nuevo usuario, agregarlo a la lista
      _loggedUsers.add(user);
    }
    
    // Hacer este usuario el activo
    _currentUser = user;
    
    await _saveToPreferences();
    notifyListeners();
  }

  // Cambiar usuario activo
  void switchUser(User user) {
    if (_loggedUsers.any((u) => u.userId == user.userId)) {
      _currentUser = user;
      notifyListeners();
      _saveToPreferences();
    }
  }

  // Cerrar sesión de un usuario específico
  Future<void> logoutUser(int userId) async {
    _loggedUsers.removeWhere((user) => user.userId == userId);
    
    // Si el usuario cerrado era el activo, cambiar al primero disponible
    if (_currentUser?.userId == userId) {
      _currentUser = _loggedUsers.isNotEmpty ? _loggedUsers.first : null;
    }
    
    await _saveToPreferences();
    notifyListeners();
  }

  // Cerrar todas las sesiones
  Future<void> logoutAll() async {
    _loggedUsers.clear();
    _currentUser = null;
    await _saveToPreferences();
    notifyListeners();
  }

  // Guardar en SharedPreferences
  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Guardar lista de usuarios
    final usersJson = _loggedUsers.map((user) => user.toJson()).toList();
    await prefs.setString('logged_users', jsonEncode(usersJson));
    
    // Guardar usuario actual
    if (_currentUser != null) {
      await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    } else {
      await prefs.remove('current_user');
    }
  }

  // Cargar desde SharedPreferences
  Future<void> loadFromPreferences() async {
    try {
      print('🔍 Cargando preferencias...'); // Debug
      final prefs = await SharedPreferences.getInstance();
      
      // Cargar usuarios logueados
      final usersString = prefs.getString('logged_users');
      print('📱 Usuarios guardados: $usersString'); // Debug
      
      if (usersString != null) {
        final List<dynamic> usersJson = jsonDecode(usersString);
        _loggedUsers = usersJson.map((json) => User.fromJson(json)).toList();
      }
      
      // Cargar usuario actual
      final currentUserString = prefs.getString('current_user');
      print('👤 Usuario actual: $currentUserString'); // Debug
      
      if (currentUserString != null) {
        final Map<String, dynamic> userJson = jsonDecode(currentUserString);
        _currentUser = User.fromJson(userJson);
      }
      
      print('✅ Preferencias cargadas. Usuarios: ${_loggedUsers.length}, Activo: ${_currentUser?.userName}'); // Debug
      notifyListeners();
      
    } catch (e) {
      print('❌ Error cargando preferencias: $e'); // Debug
      // Si hay error, inicializar vacío
      _loggedUsers = [];
      _currentUser = null;
      notifyListeners();
    }
  }
}