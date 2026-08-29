import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/provider/theme_provider.dart';
import 'package:todoapp/provider/todo_provider.dart';
import 'package:todoapp/screens/todo_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TodoProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          theme: provider.theme,
          debugShowCheckedModeBanner: false,
          home: TodoScreen(),
        );
      },
    );
  }
}
