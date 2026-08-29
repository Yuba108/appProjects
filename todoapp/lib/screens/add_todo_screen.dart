import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo_model.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/todo_provider.dart';

class AddTodoScreen extends StatelessWidget {
  AddTodoScreen({super.key});
  TextEditingController textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Consumer<TodoProvider>(
          builder: (context, provider, child) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hint: Text("Type your task here"),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 2,
                          color:
                              context.read<ThemeProvider>().theme ==
                                  ThemeData.dark()
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          width: 2,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (textController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("task can't be empty")),
                      );
                    } else {
                      provider.addTask(
                        TodoModel(title: textController.text, isDone: false),
                      );
                      textController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add Task"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
