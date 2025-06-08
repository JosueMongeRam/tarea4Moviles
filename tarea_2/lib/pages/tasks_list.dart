import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/classes/task.dart';
import 'package:tarea_2/providers/task_provider.dart';
import 'package:tarea_2/pages/edit_task.dart';
import 'package:tarea_2/providers/theme_provider.dart';

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
    final tasks = Provider.of<TaskProvider>(context).tasks;
    if(widget.tasksCategory == 'all') {
      setState(() {
        filteredTasks = tasks;
      });
    } else {
      setState(() {
        filteredTasks = tasks.where((task) => 
          task.status?.toLowerCase() == widget.tasksCategory.toLowerCase()
        ).toList();
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
                    value: task.status == 'completed',
                    onChanged: ((value) async {
                      // Update status
                      task.status = task.status == 'completed' ? 'pending' : 'completed';
                      
                      // Update in database
                      await Provider.of<TaskProvider>(context, listen: false).updateTask(task);
                      
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
                      
                      setState(() {
                        filteredTasks.removeAt(index);
                      });
                    }),
                  ),
                  title: Text(
                    task.name ?? '', 
                    style: TextStyle(
                      fontSize: 20, 
                      color: theme.textTheme.titleLarge?.color,
                    ),
                  ),
                  subtitle: Text(
                    '${task.description ?? ''}\n${task.date ?? ''}',
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
                          // La lista ya debería estar actualizada por el Provider
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
                                // Delete from database using task ID
                                if (task.id != null) {
                                  await Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id!);
                                }
                                
                                setState(() {
                                  filteredTasks.removeAt(index);
                                });

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