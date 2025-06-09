import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  bool _isAutoMode = false;
  Timer? _timer;
  
  static const String _themeKey = 'theme_preference';
  static const String _autoModeKey = 'auto_mode_preference';

  bool get isDarkMode => _isDarkMode;
  bool get isAutoMode => _isAutoMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
    if (_isAutoMode) {
      _startAutoModeTimer();
    }
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isAutoMode = prefs.getBool(_autoModeKey) ?? false;
    
    if (_isAutoMode) {
      _updateThemeByTime();
    } else {
      _isDarkMode = prefs.getBool(_themeKey) ?? true;
    }
    notifyListeners();
  }

  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkMode);
    prefs.setBool(_autoModeKey, _isAutoMode);
  }

  void _updateThemeByTime() {
    final now = DateTime.now();
    final hour = now.hour;
    
    _isDarkMode = hour >= 18 || hour < 6;
  }

  void _startAutoModeTimer() {
    _timer?.cancel();
    
    _updateThemeByTime();
    
    DateTime now = DateTime.now();
    DateTime nextUpdate;
    
    if (now.hour < 6) {
      nextUpdate = DateTime(now.year, now.month, now.day, 6, 0);
    } else if (now.hour < 18) {
      nextUpdate = DateTime(now.year, now.month, now.day, 18, 0);
    } else {
      nextUpdate = DateTime(now.year, now.month, now.day + 1, 6, 0);
    }
    
    Duration timeUntilUpdate = nextUpdate.difference(now);
    
    _timer = Timer(timeUntilUpdate, () {
      _updateThemeByTime();
      notifyListeners();
      _startAutoModeTimer(); 
    });
  }

  void setAutoMode(bool value) {
    _isAutoMode = value;
    
    if (_isAutoMode) {
      _startAutoModeTimer();
    } else {
      _timer?.cancel();
    }
    
    _saveThemeToPrefs();
    notifyListeners();
  }

  void toggleTheme() {
    if (!_isAutoMode) {
      _isDarkMode = !_isDarkMode;
      _saveThemeToPrefs();
      notifyListeners();
    }
  }

  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  ThemeData get darkTheme => ThemeData.dark().copyWith(
    colorScheme: ColorScheme.dark(
      primary: Colors.blue,
      surface: Colors.grey[900]!,
      surfaceBright: Colors.grey[800]!,
      background: Colors.black,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.grey[900],
    ),
  );

  ThemeData get lightTheme => ThemeData.light().copyWith(
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      surface: Colors.white,
      surfaceBright: Colors.grey[200]!,
      background: Colors.grey[100],
    ),
    scaffoldBackgroundColor: Colors.grey[100],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
    ),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Colors.white,
    ),
  );
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}