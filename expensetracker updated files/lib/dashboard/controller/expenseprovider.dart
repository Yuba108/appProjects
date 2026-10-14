import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class Expenseprovider extends ChangeNotifier {
  List<Map<String, dynamic>> expense = [];
  bool isLoading = false;
  String? loadError;

  Future<void> fetchExpense() async {
    isLoading = true;
    loadError = null;
    notifyListeners();
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError("Please sign in again to continue.");

      final snapshot = await FirebaseFirestore.instance
          .collection("Expense")
          .where('userId', isEqualTo: user.uid)
          .get();
      expense = snapshot.docs.map((doc) {
        final data = doc.data();
        return <String, dynamic>{
          'amount': data['amount'] is num ? data['amount'] as num : 0,
          'title': data['title'] is String ? data['title'] as String : 'Expense',
          'userId': data['userId'] is String
              ? data['userId'] as String
              : user.uid,
          'catergoryName': data['catergoryName'] is String
              ? data['catergoryName'] as String
              : 'Uncategorized',
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

    for (final item in expense) {
      final amount = item['amount'];
      if (amount is num) total += amount.toDouble();
    }
    return total;
  }

  Map<String, dynamic>? expenseWithDocId;

  Future<void> fetchExpenseWithDocId(String docID) async {
    expenseWithDocId = null;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError("Please sign in again to continue.");

      final snapshot = await FirebaseFirestore.instance
          .collection("Expense")
          .doc(docID)
          .get();

      final data = snapshot.data();
      if (!snapshot.exists || data == null || data['userId'] != user.uid) {
        throw StateError("This expense could not be found.");
      }
      expenseWithDocId = data;
    } catch (err) {
      logger.log(err.toString());
      rethrow;
    }
  }

  Map<String, num> getCategoryTotal() {
    final categoryAmount = <String, num>{};
    for (final item in expense) {
      final categoryValue = item['catergoryName'];
      final amount = item['amount'];
      if (categoryValue is! String || amount is! num) continue;
      final category = categoryValue.trim();
      if (category.isEmpty) continue;
      categoryAmount.update(
        category,
        (total) => total + amount,
        ifAbsent: () => amount,
      );
    }

    return categoryAmount;
  }

  List<MapEntry<String, num>> getSortedCategoryTotals({
    required bool sortByAmount,
    required bool ascending,
  }) {
    final totals = getCategoryTotal().entries.toList();
    totals.sort((first, second) {
      final comparison = sortByAmount
          ? first.value.compareTo(second.value)
          : first.key.toLowerCase().compareTo(second.key.toLowerCase());
      if (comparison != 0) return ascending ? comparison : -comparison;
      return first.key.toLowerCase().compareTo(second.key.toLowerCase());
    });
    return totals;
  }
}
