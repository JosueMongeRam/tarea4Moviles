import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/classes/task.dart';
import 'package:tarea_2/providers/task_provider.dart';

class EditTask extends StatefulWidget {
  final Task task;

  const EditTask({super.key, required this.task});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  late TextEditingController _taskNameController;
  late TextEditingController _taskDescriptionController;
  late String _taskDateController;

  @override
  void initState() {
    super.initState();
    // Inicializar los controladores con los valores actuales de la tarea
    _taskNameController = TextEditingController(text: widget.task.name);
    _taskDescriptionController = TextEditingController(text: widget.task.description);
    _taskDateController = widget.task.date!;
  }

  @override
  void dispose() {
    // Liberar recursos
    _taskNameController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ThemeData.dark().colorScheme.surface,
      title: Center(
        child: Text(
          'Edit Task',
          style: TextStyle(fontSize: 30, color: Colors.white),
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
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              controller: _taskNameController,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Description',
                border: OutlineInputBorder(),
                hintText: 'Enter task description',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              controller: _taskDescriptionController,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Task Date',
                border: OutlineInputBorder(),
                hintText: 'Enter task date',
                hintStyle: TextStyle(color: Colors.grey),
                labelStyle: TextStyle(color: Colors.white),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                ),
              ),
              controller: TextEditingController(text: _taskDateController),
              style: TextStyle(color: Colors.white),
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
                  // Actualizar los valores de la tarea
                  widget.task.name = taskName;
                  widget.task.description = taskDescription;
                  widget.task.date = taskDate;

                  // Actualizar en la base de datos
                  await Provider.of<TaskProvider>(context, listen: false)
                      .updateTask(widget.task);
                  
                  // Cerrar el diálogo
                  Navigator.of(context).pop(true);
                  
                  // Mostrar mensaje de éxito
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
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 20, color: Colors.white),
              ),
              child: Text('Update Task', style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}