import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/bottom_navbar_provider.dart';
import 'package:exptracker/dashboard/controller/dropdown_provider.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/features/auth/view/screens/loginscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BottomNavbarProvider()),
        ChangeNotifierProvider(create: (context) => DropdownProvider()),
        ChangeNotifierProvider(create: (context) => Expenseprovider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Commoncolors.primaryColor,
          foregroundColor: Commoncolors.commonWhite,
        ),
        scaffoldBackgroundColor: Commoncolors.lightBlue,
      ),
      home: const LoginScreen(),
    );
  }
}
