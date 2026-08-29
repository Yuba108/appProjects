import 'package:flutter/material.dart';
import 'package:todoapp/models/todo_model.dart';

class TodoProvider extends ChangeNotifier {
  List todoList = [
    // TodoModel(title: "hello", isDone: false),
    // TodoModel(title: hi, isDone: false),
  ];

  void addTask(TodoModel todo) {
    todoList.add(todo);
    notifyListeners();
  }

  void removeTask(int index) {
    todoList.removeAt(index);
    notifyListeners();
  }

  void checkboxToogle(TodoModel todo) {
    todo.isDone = !todo.isDone;
    notifyListeners();
  }
}
