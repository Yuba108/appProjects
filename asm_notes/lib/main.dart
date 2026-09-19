import 'package:asm_notes/common/common_colors.dart';
import 'package:asm_notes/home/controller/note_provider.dart';
import 'package:asm_notes/home/controller/theme_provider.dart';
import 'package:asm_notes/home/views/add_notes_screen.dart';
import 'package:asm_notes/home/views/edit_screen.dart';
import 'package:asm_notes/home/views/homescreen.dart';
import 'package:asm_notes/login/views/loginScreen.dart';
import 'package:asm_notes/login/views/sign_up_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NoteProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, child) {
        return MaterialApp(
          theme: provider.theme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/signUp',
          routes: {
            "/": (context) => Homescreen(),
            "/login": (context) => Loginscreen(),
            "/signUp": (context) => SignUpScreen(),
            "/addNote": (context) => AddNotesScreen(),
          },
        );
      },
    );
  }
}
