import 'package:flutter/material.dart';
import 'package:uppgift_1/add_task_view.dart';
import 'package:uppgift_1/api/todo_api.dart';
import 'package:uppgift_1/models/todo_item.dart';

enum FilteringOptions { all, done, undone }

var todoApi = TodoApi("https://todoapp-api.apps.k8s.gu.se",
    "9503fb55-490f-4e3b-a878-c3d9337138ff");

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
  late Future<List<TodoItem>> futureTodoItem;

  @override
  void initState() {
    super.initState();
    futureTodoItem = todoApi.fetchTodoItem();
  }

  List<TodoItem> getFilteredTasksFuture(List<TodoItem> list) {
    if (selectedOption == FilteringOptions.done) {
      return list.where((task) => task.done).toList();
    } else if (selectedOption == FilteringOptions.undone) {
      return list.where((task) => !task.done).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder<List<TodoItem>>(
          future: futureTodoItem,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var filteredTasks = getFilteredTasksFuture(snapshot.requireData);
              return _buildDataView(filteredTasks);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            // By default, show a loading spinner.
            return const CircularProgressIndicator();
          }),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTaskView(
                onAddTask: (taskTitle) {
                  setState(() {
                    futureTodoItem = todoApi.addTaskToServer(taskTitle);
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

  ListView _buildDataView(List<TodoItem> filteredTasks) {
    return ListView.separated(
      itemCount: filteredTasks.length,
      itemBuilder: (context, index) => TaskItemWidget(
        task: filteredTasks[index],
        onChanged: (newValue) {
          setState(() {
            futureTodoItem = todoApi.updateTaskOnServer(
                filteredTasks[index].id, newValue, filteredTasks[index].title);
          });
        },
        onDelete: () async {
          setState(() {
            futureTodoItem =
                todoApi.deleteTaskFromServer(filteredTasks[index].id);
          });
        },
      ),
      separatorBuilder: (context, index) => const Divider(),
    );
  }
}

class TaskItemWidget extends StatelessWidget {
  final TodoItem task;
  final ValueChanged<bool> onChanged;
  final VoidCallback onDelete;

  const TaskItemWidget({
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
                  value: task.done,
                  onChanged: (newValue) async {
                    onChanged(newValue!);
                  },
                ),
                Text(task.title,
                    style: TextStyle(
                        fontSize: 21,
                        decoration: task.done
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
