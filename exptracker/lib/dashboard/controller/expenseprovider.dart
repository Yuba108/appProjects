import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class Expenseprovider extends ChangeNotifier {
  List expense = [];

  Future fetchExpense() async {
    try {
      expense = [];
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection("Expense")
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get(); // documents type return grrxa

      // logger.log(snapshot.data().toString());

      for (var doc in snapshot.docs) {
        // logger.log(doc.data().toString());
        expense.add({
          'amount': doc.data()['amount'],
          'title': doc.data()['title'],
          'userId': doc.data()['userId'],
          'catergoryName': doc.data()['catergoryName'],
          'docId': doc.id,
        });
      }
      notifyListeners();
      logger.log(expense.toString());
    } catch (err) {
      logger.log(err.toString());
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
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("Expense")
          .doc(docID)
          .get();

      expenseWithDocId = snapshot.data();

      logger.log(expenseWithDocId.toString());
    } catch (err) {
      logger.log(err.toString());
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
