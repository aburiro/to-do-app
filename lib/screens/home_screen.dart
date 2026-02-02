import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final taskController = TextEditingController();
  List<Map<String, dynamic>> tasks = [];

  Future<void> loadTasks() async {
    final db = await DBHelper.db;
    final data = await db.query('tasks');
    setState(() {
      tasks = data;
    });
  }

  Future<void> addTask() async {
    final db = await DBHelper.db;
    await db.insert('tasks', {'title': taskController.text});
    taskController.clear();
    loadTasks();
  }

  Future<void> deleteTask(int id) async {
    final db = await DBHelper.db;
    await db.delete('tasks', where: 'id=?', whereArgs: [id]);
    loadTasks();
  }

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Tasks')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(labelText: 'New Task'),
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: addTask),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(tasks[index]['title']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deleteTask(tasks[index]['id']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
