import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class NoteProvider extends ChangeNotifier {
  List notes = [];

  void fetchNote() async {
    try {
      logger.log("before empty : $notes");
      notes = [];
      logger.log("after empty : $notes");
      notifyListeners();
      final snapshot = await FirebaseFirestore.instance
          .collection('notes')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (var doc in snapshot.docs) {
        notes.add({
          'title': doc.data()['title'],
          'desc': doc.data()['description'],
          'date': doc.data()['date'],
          'userId': doc.data()['userId'],
          'docId': doc.id,
        });
      }
      notifyListeners();
    } catch (err) {
      logger.log(err.toString());
    }
  }
}
