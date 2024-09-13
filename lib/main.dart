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

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? value = false;
  FilteringOptions? selectedOption;

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
      body: ListView(
        children: [
          TaskItem("Handla mjölk"),
          Divider(),
          TaskItem("Klippa gräset"),
          Divider(),
          TaskItem("Tvätta"),
          Divider(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddTaskView()));
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add, size: 50, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Row TaskItem(String taskTitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 10),
            child: Row(
              children: [
                Checkbox(
                    value: value,
                    onChanged: (bool? newValue) => {
                          setState(() {
                            value = newValue;
                          })
                        }),
                Text(taskTitle,
                    style: TextStyle(
                        fontSize: 21,
                        decoration: value == true
                            ? TextDecoration.lineThrough
                            : TextDecoration.none)),
              ],
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 13),
          child: Icon(Icons.close),
        ),
      ],
    );
  }
}
