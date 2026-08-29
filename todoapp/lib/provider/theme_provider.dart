import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData theme = ThemeData.dark();

  void toogleTheme() {
    if (theme == ThemeData.dark()) {
      theme = ThemeData.light();
    } else if (theme == ThemeData.light()) {
      theme = ThemeData.dark();
    }
    notifyListeners();
  }
}
