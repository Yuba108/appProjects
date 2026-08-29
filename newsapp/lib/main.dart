import 'package:flutter/material.dart';
import 'package:newsapp/features/home/controller/category_news_provider.dart';
import 'package:newsapp/features/home/controller/news_provider.dart';
import 'package:newsapp/features/home/controller/theme_provider.dart';
import 'package:newsapp/features/onBoarding/view/screens/onboarding_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context) => CategoryNewsProvider()),
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
          debugShowCheckedModeBanner: false,
          home: OnboardingScreen(),
          theme: provider.theme,
        );
      },
    );
  }
}
