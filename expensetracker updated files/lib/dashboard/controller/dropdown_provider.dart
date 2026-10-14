import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class DropdownProvider extends ChangeNotifier {
  String? selectedValue;
  bool isLoading = false;
  String? loadError;

  void changeValue(String? value) {
    selectedValue = value;
    notifyListeners();
  }

  void clearCategory() {
    selectedValue = null;
    notifyListeners();
  }

  List<Map<String, dynamic>> categories = [];

  Future<void> fetchCategroy() async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("categories")
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      categories = snapshot.docs.map((doc) => doc.data()).toList();
      if (!categories.any(
        (category) => category['categoryName'] == selectedValue,
      )) {
        selectedValue = null;
      }
    } catch (err) {
      logger.log(err.toString());
      loadError = err.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
