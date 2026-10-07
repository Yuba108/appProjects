import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class Expenseprovider extends ChangeNotifier {
  List expense = [];
  bool isLoading = false;
  String? loadError;

  Future<void> fetchExpense() async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Expense")
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      expense = snapshot.docs.map((doc) {
        return {
          'amount': doc.data()['amount'],
          'title': doc.data()['title'],
          'userId': doc.data()['userId'],
          'catergoryName': doc.data()['catergoryName'],
          'docId': doc.id,
        };
      }).toList();
    } catch (err) {
      logger.log(err.toString());
      loadError = err.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  double getTotalExpense() {
    double total = 0;

    for (var exp in expense) {
      total = total + exp['amount'];
    }
    return total;
  }

  Map? expenseWithDocId;

  Future fetchExpenseWithDocId(String docID) async {
    expenseWithDocId = null;
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Expense")
          .doc(docID)
          .get();

      if (!snapshot.exists) {
        throw StateError("This expense could not be found.");
      }
      expenseWithDocId = snapshot.data();
    } catch (err) {
      logger.log(err.toString());
      rethrow;
    }
  }

  Map<String, num> getCategoryTotal() {
    // map that contains category key(String) and amount as value(int).
    // num bitra int and double prrxan
    Map<String, num> categoryAmount = {};
    for (var exp in expense) {
      String category = exp['catergoryName'];
      num amount = exp['amount'];
      if (categoryAmount.containsKey(category)) {
        categoryAmount[category] = categoryAmount[category]! + amount;
      } else {
        categoryAmount[category] = amount;
      }
    }

    return categoryAmount;
  }
}
