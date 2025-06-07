import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_2/classes/task.dart';
import 'package:tarea_2/classes/task_provider.dart';
import 'package:tarea_2/providers/theme_provider.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({super.key});

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  final TextEditingController _searchController = TextEditingController();
  late List<Task> filteredTasks = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final tasks = Provider.of<TaskProvider>(context).tasks;
    setState(() {
        filteredTasks = tasks;
    });
  }

  void _searchTasks() {
    final searchQuery = _searchController.text.toLowerCase();
    setState(() {
      filteredTasks = Provider.of<TaskProvider>(context, listen: false)
          .tasks
          .where((task) => task.name?.toLowerCase().contains(searchQuery) ?? false)
          .toList();

      if (filteredTasks.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyFancyPopup(
              heading: "No Results!",
              body: "No tasks found for the query: \"$searchQuery\".",
              onClose: () {
                Navigator.pop(context);
              },
              type: Type.search,
              buttonText: "OK",
            );
          },
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // Obtener el tema actual
    final theme = Theme.of(context);
    
    return AlertDialog(
      backgroundColor: theme.colorScheme.surface,
      title: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Task',
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
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
            ),
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: Icon(
              Icons.search,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              _searchTasks();
            },
          ),
        ],
      ),
      content: Center(
        child: Container(
          width: 370,
          height: 750,
          decoration: BoxDecoration(
            color: theme.colorScheme.background,
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
                      onChanged: ((value) {
                        // Solo lectura en modo búsqueda
                      }),
                    ),
                    title: Text(
                      task.name ?? 'No Name', 
                      style: TextStyle(
                        fontSize: 20, 
                        color: theme.textTheme.titleLarge?.color,
                      ),
                    ),
                    subtitle: Text(
                      task.description ?? 'No Description', 
                      style: TextStyle(
                        fontSize: 16, 
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                    ),
                    trailing: Text(
                      task.date ?? 'No Date', 
                      style: TextStyle(
                        fontSize: 16, 
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
