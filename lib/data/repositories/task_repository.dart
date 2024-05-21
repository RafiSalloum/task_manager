import 'dart:convert' as convert;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_manager/data/model/task.dart';


class TaskRepository {
  final String apiUrl = 'https://dummyjson.com/todos';
  final String apiUrlPost = 'https://dummyjson.com/todos/add';

  TaskRepository();

  // GET
  Future<List<Task>> fetchTasks() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      var jsonData =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      final List<dynamic> taskJsonList = jsonData['todos'];
      final tasks = (taskJsonList)
          .map((taskJson) => Task.fromJson(taskJson))
          .toList();
      return tasks;
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  // POST
  Future<void> saveTask(Task task) async {
    final response = await http.post(
      Uri.parse(apiUrlPost),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),

    );
    if (response.statusCode != 201) {
      throw Exception('Failed to save task');
    }
  }


  // PUT
  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('https://dummyjson.com/todos/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),

    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  // DELETE
  Future<void> deleteTask(Task task) async {
    final response = await http.delete(
      Uri.parse('https://dummyjson.com/todos/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toJson()),

    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}