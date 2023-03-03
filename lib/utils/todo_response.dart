import 'package:flutter_todo_api/models/todo.dart';

class TodoResponse {
  final List<Todo>? todos;
  final String? apiMore;
  TodoResponse(this.todos, this.apiMore);
}
