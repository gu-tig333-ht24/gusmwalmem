import 'package:flutter/material.dart';
import 'package:uppgift_1/add_task_view.dart';

enum FilteringOptions { all, done, undone }

void main() {
  runApp(
    MaterialApp(
      title: "TIG333",
      home: MyHomePage(),
    ),
  );
}

class Task {
  String title;
  bool isCompleted;

  Task(this.title, {this.isCompleted = false});
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FilteringOptions? selectedOption = FilteringOptions.all;
  List<Task> todoItems = [];

  List<Task> getFilteredTasks() {
    if (selectedOption == FilteringOptions.done) {
      return todoItems.where((task) => task.isCompleted).toList();
    } else if (selectedOption == FilteringOptions.undone) {
      return todoItems.where((task) => !task.isCompleted).toList();
    }
    return todoItems;
  }

  @override
  Widget build(BuildContext context) {
    List<Task> filteredTasks = getFilteredTasks();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG333 TODO"),
        backgroundColor: Colors.grey,
        actions: [
          PopupMenuButton<FilteringOptions>(
            initialValue: selectedOption,
            onSelected: (FilteringOptions item) {
              setState(() {
                selectedOption = item;
              });
            },
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<FilteringOptions>>[
              const PopupMenuItem<FilteringOptions>(
                value: FilteringOptions.all,
                child: Text('All'),
              ),
              const PopupMenuItem<FilteringOptions>(
                value: FilteringOptions.done,
                child: Text('Done'),
              ),
              const PopupMenuItem<FilteringOptions>(
                value: FilteringOptions.undone,
                child: Text('Undone'),
              ),
            ],
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) => TaskItem(
          task: filteredTasks[index],
          onChanged: (newValue) {
            setState(() {
              filteredTasks[index].isCompleted = newValue;
            });
          },
          onDelete: () {
            setState(() {
              todoItems.remove(filteredTasks[index]);
            });
          },
        ),
        separatorBuilder: (context, index) => const Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskView(
                onAddTask: (taskTitle) {
                  setState(() {
                    todoItems.add(Task(taskTitle));
                  });
                },
              ),
            ),
          );
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add, size: 50, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

class TaskItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;

  const TaskItem({
    Key? key,
    required this.task,
    required this.onChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ObjectKey(task.title),
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (newValue) {
                    onChanged(newValue ?? false);
                  },
                ),
                Text(task.title,
                    style: TextStyle(
                        fontSize: 21,
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 13),
          child: GestureDetector(
            onTap: onDelete,
            child: Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}