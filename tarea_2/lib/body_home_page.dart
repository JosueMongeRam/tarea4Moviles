import 'package:flutter/material.dart';
import 'package:tarea_2/tasks_list.dart';

class BodyHomePage extends StatefulWidget {
  const BodyHomePage({ super.key });

  @override
  State<BodyHomePage> createState() => _BodyHomePageState();
}

class _BodyHomePageState extends State<BodyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                const Text('Pending Tasks', style: TextStyle(fontSize: 30, color: Colors.yellow),),
                const SizedBox(height: 10),
                TasksList(tasksCategory: 'pending'),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              children: [
                const SizedBox(height: 10),
                const Text('Completed Tasks', style: TextStyle(fontSize: 30, color: Colors.green),),
                const SizedBox(height: 10),
                TasksList(tasksCategory: 'completed'),
              ],
            ),
          ],
        ),
      )
    );
  }
}