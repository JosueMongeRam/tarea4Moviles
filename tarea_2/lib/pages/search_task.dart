import 'package:fancy_popups_new/fancy_popups_new.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_models.dart'; 
import '../providers/task_provider.dart';
import '../providers/auth_provider.dart'; 
import '../providers/theme_provider.dart';

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
    _loadUserTasks();
  }

  void _loadUserTasks() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.currentUser != null) {
      final userTasks = taskProvider.getTasksByUser(authProvider.currentUser!.userId);
      setState(() {
        filteredTasks = userTasks;
      });
    } else {
      setState(() {
        filteredTasks = [];
      });
    }
  }

  void _searchTasks() {
    final searchQuery = _searchController.text.toLowerCase().trim();
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (searchQuery.isEmpty) {
      _loadUserTasks(); 
      return;
    }

    List<Task> userTasks = [];
    if (authProvider.currentUser != null) {
      userTasks = taskProvider.getTasksByUser(authProvider.currentUser!.userId);
    }

    setState(() {
      filteredTasks = userTasks
          .where((task) => 
            task.taskTitle.toLowerCase().contains(searchQuery) ||
            task.taskDescription.toLowerCase().contains(searchQuery)
          )
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
                hintText: 'Enter task name or description',
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
              onSubmitted: (value) => _searchTasks(), 
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
          IconButton(
            icon: Icon(
              Icons.clear,
              color: theme.iconTheme.color,
            ),
            onPressed: () {
              _searchController.clear();
              _loadUserTasks(); 
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
            child: filteredTasks.isEmpty 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: theme.iconTheme.color?.withOpacity(0.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        _searchController.text.isEmpty 
                          ? 'No tasks available'
                          : 'No tasks found',
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
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
                          value: task.taskCompleted, 
                          onChanged: null, 
                        ),
                        title: Text(
                          task.taskTitle, 
                          style: TextStyle(
                            fontSize: 20, 
                            color: theme.textTheme.titleLarge?.color,
                          ),
                        ),
                        subtitle: Text(
                          '${task.taskDescription}\n${task.taskDate}', 
                          style: TextStyle(
                            fontSize: 16, 
                            color: theme.textTheme.bodyMedium?.color,
                          ),
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: task.taskCompleted 
                              ? Colors.green.withOpacity(0.2)
                              : Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            task.taskCompleted ? 'Completed' : 'Pending',
                            style: TextStyle(
                              fontSize: 12,
                              color: task.taskCompleted ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
