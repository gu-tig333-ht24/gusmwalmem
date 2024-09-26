import 'package:flutter/material.dart';

class AddTaskView extends StatefulWidget {
  final Function(String taskTitle)? onAddTask;
  AddTaskView({this.onAddTask});

  @override
  State<AddTaskView> createState() => _AddTaskViewState(onAddTask: onAddTask);
}

class _AddTaskViewState extends State<AddTaskView> {
  String newTaskTitle = "";
  final Function(String taskTitle)? onAddTask;
  final TextEditingController _controller = TextEditingController();
  _AddTaskViewState({this.onAddTask});
  // const AddTaskView({super.key});

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("TIG333 TODO"),
        backgroundColor: Colors.grey,
      ),
      body: Column(children: [
        Padding(
          padding: EdgeInsets.all(30.0),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "What are you going to do?",
            ),
            style: TextStyle(fontWeight: FontWeight.w200, color: Colors.grey),
            onChanged: (text) {
              newTaskTitle = text;
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            String taskTitle = _controller.text;
            if (newTaskTitle.isNotEmpty) {
              if (onAddTask != null) {
                onAddTask!(taskTitle);
              }
              Navigator.pop(context);
            }
          },
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.add, size: 21),
            Text(
              "ADD",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ]),
        ),
      ]),
    );
  }
}
