import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData theme = ThemeData.light();
  void switchTheme() {
    if (theme == ThemeData.dark()) {
      theme = ThemeData.light();
    } else {
      theme = ThemeData.dark();
    }
    notifyListeners();
  }
}
