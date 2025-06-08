import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/classes/task.dart';
import 'package:tarea_2/providers/task_provider.dart';
import 'package:tarea_2/providers/theme_provider.dart';

class NewTask extends StatefulWidget {
  const NewTask({ super.key });

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  String _taskDateController = '';

  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final theme = Theme.of(context);
    
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: Center(
        child: Text(
          'Add New Task',
          style: TextStyle(fontSize: 30, color: theme.textTheme.titleLarge?.color),
        ),
      ),
      content: Container(
        width: 400,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Name',
                border: OutlineInputBorder(),
                hintText: 'Enter task name',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: theme.textTheme.labelLarge?.color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ),
              controller: _taskNameController,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
                hintText: 'Enter task description',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: theme.textTheme.labelLarge?.color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ),
              controller: _taskDescriptionController,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Date',
                border: OutlineInputBorder(),
                hintText: 'Enter task date',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: theme.textTheme.labelLarge?.color),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.6)),
                ),
              ),
              controller: TextEditingController(text: _taskDateController),
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null) {
                  setState(() {
                    _taskDateController = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  });
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String taskName = _taskNameController.text;
                String taskDescription = _taskDescriptionController.text;
                String taskDate = _taskDateController;

                if (taskName.isNotEmpty && taskDescription.isNotEmpty && taskDate.isNotEmpty) {
                  Task newTask = Task(
                    name: taskName,
                    description: taskDescription,
                    date: taskDate,
                    status: 'pending', // Nota: cambiado a minúsculas para ser consistente
                  );

                  await Provider.of<TaskProvider>(context, listen: false).addTask(newTask);
                  
                  Navigator.of(context).pop();
                  
                  // Mostrar mensaje de éxito
                  if (context.mounted) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return MyFancyPopup(
                          heading: "Success!",
                          body: "Task created successfully!",
                          onClose: () {
                            Navigator.pop(context);
                          },
                          type: Type.success,
                          buttonText: "Continue",
                        );
                      },
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text('Create Task', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}