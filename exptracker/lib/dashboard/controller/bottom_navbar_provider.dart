import 'package:flutter/material.dart';

class BottomNavbarProvider extends ChangeNotifier {
  int selectedIndex = 0;

  void updateSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
