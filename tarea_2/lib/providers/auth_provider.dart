import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_models.dart';

class AuthProvider with ChangeNotifier {
  List<User> _loggedUsers = [];
  User? _currentUser;

  List<User> get loggedUsers => _loggedUsers;
  User? get currentUser => _currentUser;
  bool get hasLoggedUsers => _loggedUsers.isNotEmpty;
  bool get isLoggedIn => _currentUser != null;

  Future<void> addUser(User user) async {
    final existingIndex = _loggedUsers.indexWhere(
      (u) => u.userId == user.userId,
    );
    if (existingIndex >= 0) {
      _loggedUsers[existingIndex] = user;
    } else {
      _loggedUsers.add(user);
    }

    _currentUser = user;

    await _saveToPreferences();
    notifyListeners();
  }

  void switchUser(User user) {
    if (_loggedUsers.any((u) => u.userId == user.userId)) {
      _currentUser = user;
      notifyListeners();
      _saveToPreferences();
    }
  }

  Future<void> logoutUser(int userId) async {
    _loggedUsers.removeWhere((user) => user.userId == userId);

    if (_currentUser?.userId == userId) {
      _currentUser = _loggedUsers.isNotEmpty ? _loggedUsers.first : null;
    }

    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> logoutAll() async {
    _loggedUsers.clear();
    _currentUser = null;
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final usersJson = _loggedUsers.map((user) => user.toJson()).toList();
    await prefs.setString('logged_users', jsonEncode(usersJson));

    if (_currentUser != null) {
      await prefs.setString('current_user', jsonEncode(_currentUser!.toJson()));
    } else {
      await prefs.remove('current_user');
    }
  }

  Future<void> loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final usersString = prefs.getString('logged_users');

      if (usersString != null) {
        final List<dynamic> usersJson = jsonDecode(usersString);
        _loggedUsers = usersJson.map((json) => User.fromJson(json)).toList();
      }

      final currentUserString = prefs.getString('current_user');

      if (currentUserString != null) {
        final Map<String, dynamic> userJson = jsonDecode(currentUserString);
        _currentUser = User.fromJson(userJson);
      }

      notifyListeners();
    } catch (e) {
      _loggedUsers = [];
      _currentUser = null;
      notifyListeners();
    }
  }
}
