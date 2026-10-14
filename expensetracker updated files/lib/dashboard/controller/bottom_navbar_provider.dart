import 'package:flutter/material.dart';

class BottomNavbarProvider extends ChangeNotifier {
  int selectedIndex = 0;
  String? historyCategoryFilter;

  void updateSelectedIndex(int index) {
    if (index != 1) historyCategoryFilter = null;
    selectedIndex = index;
    notifyListeners();
  }

  void showCategoryHistory(String category) {
    historyCategoryFilter = category;
    selectedIndex = 1;
    notifyListeners();
  }

  void clearHistoryCategoryFilter() {
    historyCategoryFilter = null;
    notifyListeners();
  }
}
