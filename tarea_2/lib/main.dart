import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/pages/login.dart';
import 'package:tarea_2/providers/task_provider.dart';
import 'package:tarea_2/pages/home_page.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:tarea_2/providers/theme_provider.dart';

void main() async {
  // Esta línea es CRÍTICA - debe ir antes de cualquier operación nativa
  WidgetsFlutterBinding.ensureInitialized();
  
  // Verificar que la base de datos es accesible
  try {
    final path = await getDatabasesPath();
    print("SQLite Path: $path");
  } catch (e) {
    print("Error con SQLite: $e");
  }
  
  // Crear e inicializar los providers
  final taskProvider = TaskProvider();
  await taskProvider.initialize();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: taskProvider,
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Usar el ThemeProvider para obtener el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeProvider.lightTheme, // Tema claro
      darkTheme: themeProvider.darkTheme, // Tema oscuro
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Modo de tema actual
      home: const LoginPage(),
    );
  }
}
