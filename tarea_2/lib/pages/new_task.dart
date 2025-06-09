import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_models.dart';
import '../services/task_service.dart'; 
import '../providers/auth_provider.dart'; 
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';

class NewTask extends StatefulWidget {
  const NewTask({ super.key });

  @override
  State<NewTask> createState() => _NewTaskState();
}

class _NewTaskState extends State<NewTask> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  String _taskDateController = '';
  bool _isLoading = false; 

    Future<void> _createTask() async {
      String taskName = _taskNameController.text.trim();
      String taskDescription = _taskDescriptionController.text.trim();
      String taskDate = _taskDateController;

      if (taskName.isEmpty || taskDescription.isEmpty || taskDate.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor completa todos los campos'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.currentUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No hay usuario activo'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final createTaskRequest = CreateTaskRequest(
          taskName: taskName,
          taskDescription: taskDescription,
          taskDate: taskDate,
          taskStatus: '0', // '0' = pendiente, '1' = completada
          taskUserId: authProvider.currentUser!.userId,
        );

        final taskResponse = await TaskService.createTask(createTaskRequest);

        final newTask = Task.fromTaskResponse(taskResponse);

        final taskProvider = Provider.of<TaskProvider>(context, listen: false);
        await taskProvider.addTask(newTask);

        setState(() {
          _isLoading = false;
        });

        Navigator.of(context).pop();

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

      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creando tarea: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

  @override
  void dispose() {
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              enabled: !_isLoading,
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
              enabled: !_isLoading,
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
              enabled: !_isLoading,
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
              onPressed: _isLoading ? null : _createTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: _isLoading 
                ? CircularProgressIndicator(color: Colors.white)
                : Text('Create Task', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}