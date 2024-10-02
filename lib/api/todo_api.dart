import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uppgift_1/api/api_token_client.dart';
import 'package:uppgift_1/models/todo_item.dart';

class TodoApi {
  final String host;
  final ApiTokenClient client;
  TodoApi(this.host, String apiKey)
      : client = ApiTokenClient(apiKey, http.Client());
      
  Future<List<TodoItem>> fetchTodoItem() async {
    final response = await client.get(Uri.parse('$host/todos'));

    if (response.statusCode == 200) {
      return fromListJson(jsonDecode(response.body) as List);
    } else {
      throw Exception("Failed to load todo item");
    }
  }

  Future<List<TodoItem>> addTaskToServer(String taskTitle) async {
    final response = await client.post(
      Uri.parse('$host/todos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': taskTitle,
        'done': false,
      }),
    );
    if (response.statusCode == 200) {
      return fromListJson(jsonDecode(response.body) as List);
    } else {
      throw Exception("Failed to add task");
    }
  }

  Future<List<TodoItem>> updateTaskOnServer(
      String id, bool isCompleted, String taskTitle) async {
    final response = await client.put(
      Uri.parse('$host/todos/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'title': taskTitle,
        'done': isCompleted,
      }),
    );
    if (response.statusCode == 200) {
      return fromListJson(jsonDecode(response.body) as List);
    } else {
      throw Exception("Failed to update task");
    }
  }

  Future<List<TodoItem>> deleteTaskFromServer(String id) async {
    final response = await client.delete(
      Uri.parse('$host/todos/$id'),
    );
    if (response.statusCode == 200) {
      return fromListJson(jsonDecode(response.body) as List);
    } else {
      throw Exception("Failed to delete task");
    }
  }
}
