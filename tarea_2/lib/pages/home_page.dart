import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/pages/body_home_page.dart';
import 'package:tarea_2/pages/new_task.dart';
import 'package:tarea_2/pages/search_task.dart';
import 'package:tarea_2/providers/theme_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ThemeProvider para conocer el tema actual
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final isAutoMode = themeProvider.isAutoMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          // Botón para abrir las opciones de tema
          IconButton(
            icon: Icon(
              Icons.settings_brightness,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildThemeDialog(context, themeProvider),
              );
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: SingleChildScrollView(child: BodyHomePage()),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).bottomAppBarTheme.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SearchTask();
                    },
                  );
                },
                icon: const Icon(Icons.search),
                label: const Text('Search Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const NewTask();
                    },
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Task'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Diálogo para opciones de tema
  Widget _buildThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    return AlertDialog(
      title: Text('Opciones de Tema'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Opción de modo automático
          SwitchListTile(
            title: Text('Modo Automático'),
            subtitle: Text('Oscuro de 6pm a 6am'),
            value: themeProvider.isAutoMode,
            onChanged: (value) {
              themeProvider.setAutoMode(value);
              Navigator.pop(context);
            },
          ),
          
          // Separador
          Divider(),
          
          // Opción manual (solo disponible si no está en modo automático)
          ListTile(
            title: Text('Modo Oscuro'),
            trailing: Switch(
              value: themeProvider.isDarkMode,
              onChanged: themeProvider.isAutoMode ? null : (_) {
                themeProvider.toggleTheme();
                Navigator.pop(context);
              },
            ),
            enabled: !themeProvider.isAutoMode,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
}
