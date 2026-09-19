import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class DropdownProvider extends ChangeNotifier {
  String? selectedValue;

  void changeValue(String? value) {
    selectedValue = value;
    notifyListeners();
  }

  void clearCategory() {
    selectedValue = null;
    notifyListeners();
  }

  List categories = [];

  Future fetchCategroy() async {
    try {
      categories = [];
      selectedValue = null;
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection("categories")
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get(); // documents type return grrxa

      // logger.log(snapshot.data().toString());

      for (var doc in snapshot.docs) {
        // logger.log(doc.data().toString());
        categories.add(doc.data());
      }
      notifyListeners();
      logger.log(categories.toString());
    } catch (err) {
      logger.log(err.toString());
    }
  }
}
