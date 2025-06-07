import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  bool _isAutoMode = false;
  Timer? _timer;
  
  static const String _themeKey = 'theme_preference';
  static const String _autoModeKey = 'auto_mode_preference';

  // Getters
  bool get isDarkMode => _isDarkMode;
  bool get isAutoMode => _isAutoMode;

  ThemeProvider() {
    _loadThemeFromPrefs();
    if (_isAutoMode) {
      _startAutoModeTimer();
    }
  }

  // Cargar las preferencias guardadas
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

  // Guardar preferencias
  Future<void> _saveThemeToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_themeKey, _isDarkMode);
    prefs.setBool(_autoModeKey, _isAutoMode);
  }

  // Actualizar tema según hora
  void _updateThemeByTime() {
    final now = DateTime.now();
    final hour = now.hour;
    
    // Modo oscuro entre 6pm (18:00) y 6am (6:00)
    _isDarkMode = hour >= 18 || hour < 6;
  }

  // Iniciar temporizador para actualización automática
  void _startAutoModeTimer() {
    // Cancelar timer existente si hay uno
    _timer?.cancel();
    
    _updateThemeByTime();
    
    // Calcular próxima actualización (a las 6am o 6pm)
    DateTime now = DateTime.now();
    DateTime nextUpdate;
    
    if (now.hour < 6) {
      // Próxima actualización a las 6am
      nextUpdate = DateTime(now.year, now.month, now.day, 6, 0);
    } else if (now.hour < 18) {
      // Próxima actualización a las 6pm
      nextUpdate = DateTime(now.year, now.month, now.day, 18, 0);
    } else {
      // Próxima actualización a las 6am del día siguiente
      nextUpdate = DateTime(now.year, now.month, now.day + 1, 6, 0);
    }
    
    Duration timeUntilUpdate = nextUpdate.difference(now);
    
    // Crear un timer para la próxima actualización
    _timer = Timer(timeUntilUpdate, () {
      _updateThemeByTime();
      notifyListeners();
      _startAutoModeTimer(); // Configurar el próximo timer
    });
  }

  // Cambiar entre modo manual y automático
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

  // Cambiar manualmente el tema (solo cuando no está en modo automático)
  void toggleTheme() {
    if (!_isAutoMode) {
      _isDarkMode = !_isDarkMode;
      _saveThemeToPrefs();
      notifyListeners();
    }
  }

  // Temas definidos
  ThemeData get themeData => _isDarkMode ? darkTheme : lightTheme;

  // Tema oscuro
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

  // Tema claro
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