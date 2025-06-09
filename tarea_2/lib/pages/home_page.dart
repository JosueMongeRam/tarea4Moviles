import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/pages/body_home_page.dart';
import 'package:tarea_2/pages/new_task.dart';
import 'package:tarea_2/pages/search_task.dart';
import 'package:tarea_2/providers/task_provider.dart';
import 'package:tarea_2/providers/theme_provider.dart';
import 'package:tarea_2/providers/auth_provider.dart';
import 'package:tarea_2/pages/login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final isAutoMode = themeProvider.isAutoMode;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authProvider.currentUser != null) {
        taskProvider.syncTasksForUser(authProvider.currentUser!.userId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Manager',
          style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primary),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.account_circle,
              color: Theme.of(context).appBarTheme.foregroundColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => _buildAccountDialog(context, authProvider),
              );
            },
          ),
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

  Widget _buildAccountDialog(BuildContext context, AuthProvider authProvider) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.account_circle, color: Theme.of(context).colorScheme.primary),
          SizedBox(width: 8),
          Text('Gestión de Cuentas'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (authProvider.currentUser != null) ...[
              Text(
                'Usuario Activo:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.currentUser!.userName,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      authProvider.currentUser!.userEmail,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
            ],

            if (authProvider.loggedUsers.length > 1) ...[
              Text(
                'Cambiar a otra cuenta:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              SizedBox(height: 8),
              ...authProvider.loggedUsers.where((user) => user.userId != authProvider.currentUser?.userId).map(
                (user) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(user.userName[0].toUpperCase()),
                    ),
                    title: Text(user.userName),
                    subtitle: Text(user.userEmail),
                    trailing: IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () {
                        authProvider.logoutUser(user.userId);
                      },
                    ),
                    onTap: () async { 
                      authProvider.switchUser(user);
                      
                      await Provider.of<TaskProvider>(context, listen: false)
                          .syncTasksForUser(user.userId);
                      
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                icon: Icon(Icons.person_add),
                label: Text('Agregar Nueva Cuenta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),

            SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Cerrar todas las sesiones'),
                      content: Text('¿Estás seguro de que quieres cerrar todas las sesiones?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            authProvider.logoutAll();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => LoginPage()),
                              (route) => false,
                            );
                          },
                          child: Text('Cerrar Todo', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(Icons.logout),
                label: Text('Cerrar Todas las Sesiones'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cerrar'),
        ),
      ],
    );
  }
  
  Widget _buildThemeDialog(BuildContext context, ThemeProvider themeProvider) {
    return AlertDialog(
      title: Text('Opciones de Tema'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SwitchListTile(
            title: Text('Modo Automático'),
            subtitle: Text('Oscuro de 6pm a 6am'),
            value: themeProvider.isAutoMode,
            onChanged: (value) {
              themeProvider.setAutoMode(value);
              Navigator.pop(context);
            },
          ),
          
          Divider(),
          
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
