import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_models.dart'; // CAMBIAR: usar nuevos modelos
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart'; // AGREGAR: para filtrar por usuario
import '../pages/edit_task.dart';
import '../providers/theme_provider.dart';

class TasksList extends StatefulWidget {
  final String tasksCategory;

  const TasksList({
    super.key,
    required this.tasksCategory,
  });

  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  late List<Task> filteredTasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateFilteredTasks();
  }
  
  void _updateFilteredTasks() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false); // AGREGAR listen: false
    final authProvider = Provider.of<AuthProvider>(context, listen: false); // AGREGAR listen: false
    
    // Obtener solo las tareas del usuario activo
    if (authProvider.currentUser != null) {
      final userTasks = taskProvider.getTasksByUser(authProvider.currentUser!.userId);
      
      if (widget.tasksCategory == 'all') {
        setState(() {
          filteredTasks = userTasks;
        });
      } else if (widget.tasksCategory == 'completed') {
        setState(() {
          filteredTasks = userTasks.where((task) => task.taskCompleted).toList();
        });
      } else if (widget.tasksCategory == 'pending') {
        setState(() {
          filteredTasks = userTasks.where((task) => !task.taskCompleted).toList();
        });
      }
    } else {
      setState(() {
        filteredTasks = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Always refresh the list when building
    _updateFilteredTasks();
    
    // Obtener el tema actual
    final theme = Theme.of(context);
    
    if (filteredTasks.isEmpty) {
      return Center(
        child: Container(
          width: 370,
          height: 750,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'No ${widget.tasksCategory} tasks',
              style: TextStyle(
                fontSize: 20, 
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      );
    }

    return Center(
      child: Container(
        width: 370,
        height: 750,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              Task task = filteredTasks[index];
              return Card(
                color: theme.cardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Checkbox(
                    checkColor: Colors.green,
                    fillColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return theme.disabledColor;
                      }
                      return theme.primaryColor;
                    }),
                    value: task.taskCompleted, // CAMBIAR: usar taskCompleted
                    onChanged: ((value) async {
                      try {
                        // Actualizar en API y localmente
                        await Provider.of<TaskProvider>(context, listen: false)
                            .toggleTaskCompleted(task.taskId!);
                        
                        // Show success message
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyFancyPopup(
                                heading: "Success!",
                                body: "Task updated successfully!",
                                onClose: () {
                                  Navigator.pop(context);
                                },
                                type: Type.success,
                                buttonText: "Continue",
                              );
                            },
                          );
                        }
                        
                        // Actualizar lista
                        _updateFilteredTasks();
                        
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Error updating task: ${e.toString()}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }),
                  ),
                  title: Text(
                    task.taskTitle, // CAMBIAR: usar taskTitle
                    style: TextStyle(
                      fontSize: 20, 
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  subtitle: Text(
                    '${task.taskDescription}\n${task.taskDate}', // CAMBIAR: usar nuevos nombres
                    style: TextStyle(
                      fontSize: 16, 
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      final result = await showDialog<bool>(
                        context: context,
                        builder: (context) => EditTask(task: task),
                      );
                      
                      // Si el resultado es true, la actualización fue exitosa
                      if (result == true) {
                        // Actualizar la UI si es necesario
                        setState(() {
                          _updateFilteredTasks();
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit, 
                      color: theme.iconTheme.color, 
                      size: 30
                    ),
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Task"),
                          content: const Text("Are you sure you want to delete this task?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                try {
                                  // Delete from API and database using task ID
                                  if (task.taskId != null) {
                                    await Provider.of<TaskProvider>(context, listen: false)
                                        .deleteTask(task.taskId!);
                                  }
                                  
                                  Navigator.pop(context);

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return MyFancyPopup(
                                        heading: "Success!",
                                        body: "Task deleted successfully!",
                                        onClose: () {
                                          Navigator.pop(context);
                                        },
                                        type: Type.success,
                                        buttonText: "Continue",
                                      );
                                    },
                                  );

                                  // Actualizar lista
                                  _updateFilteredTasks();

                                } catch (e) {
                                  Navigator.pop(context);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Error deleting task: ${e.toString()}'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          )
        ),
      ),
    );
  }
}