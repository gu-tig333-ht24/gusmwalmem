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
  _AddTaskViewState({this.onAddTask});
  // const AddTaskView({super.key});
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
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "What are you going to do?",
              ),
              style: TextStyle(fontWeight: FontWeight.w200, color: Colors.grey),
              onChanged: (value) {
                setState(() {
                  newTaskTitle = value;
                });
              }),
        ),
        GestureDetector(
          onTap: () {
            if (onAddTask != null && newTaskTitle.isNotEmpty) {
              onAddTask!(newTaskTitle);
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
