import 'package:flutter/material.dart';

class AddTaskView extends StatelessWidget {
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
              style:
                  TextStyle(fontWeight: FontWeight.w200, color: Colors.grey)),
        ),
        GestureDetector(
          onTap: () {},
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
