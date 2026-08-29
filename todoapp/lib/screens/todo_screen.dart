import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/todo_provider.dart';
import 'package:todoapp/screens/add_todo_screen.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TODOS", style: TextStyle(fontSize: 24, fontWeight: .bold)),
        actionsPadding: EdgeInsets.all(10),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, provider, child) {
              return GestureDetector(
                onTap: () {
                  provider.toogleTheme();
                },
                child: Row(
                  spacing: 10,
                  children: [
                    Text(
                      provider.theme == ThemeData.dark()
                          ? "switch to light"
                          : "switch to dark",
                      style: TextStyle(fontSize: 14, fontWeight: .bold),
                    ),
                    Icon(
                      provider.theme == ThemeData.dark()
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      size: 24,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Consumer<TodoProvider>(
          builder: (context, provider, child) {
            return provider.todoList.isEmpty
                ? Center(child: Text("No Tasks"))
                : Padding(
                    padding: const EdgeInsets.all(25),
                    child: ListView.builder(
                      itemCount: provider.todoList.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.todoList[index].title,
                                style: TextStyle(
                                  fontSize: 20,
                                  decoration: provider.todoList[index].isDone
                                      ? TextDecoration.lineThrough
                                      : .none,
                                ),
                              ),
                            ),
                            Checkbox(
                              value: provider.todoList[index].isDone,
                              onChanged: (value) {
                                provider.checkboxToogle(
                                  provider.todoList[index],
                                );
                              },
                            ),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "deleted task ${provider.todoList[index].title}",
                                    ),
                                  ),
                                );
                                provider.removeTask(index);
                              },
                              child: Icon(Icons.delete_outline),
                            ),
                          ],
                        );
                      },
                    ),
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTodoScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
