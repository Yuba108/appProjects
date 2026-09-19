import 'dart:developer' as logger;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/view/widgets/expensetextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Addcategoryscreen extends StatefulWidget {
  const Addcategoryscreen({super.key});

  @override
  State<Addcategoryscreen> createState() => _AddcategoryscreenState();
}

class _AddcategoryscreenState extends State<Addcategoryscreen> {
  final TextEditingController categoryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          children: [
            Expensetextfield(
              hinttext: "category here",
              controller: categoryController,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Commoncolors.primaryColor,
                  padding: const EdgeInsets.all(15),
                  foregroundColor: Commoncolors.commonWhite,
                ),
                onPressed: () async {
                  if (categoryController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("category can't be empty"),
                        behavior: .floating,
                      ),
                    );
                    return;
                  }
                  try {
                    await FirebaseFirestore.instance
                        .collection('categories')
                        .add({
                          'categoryName': categoryController.text,
                          'userId': FirebaseAuth.instance.currentUser!.uid,
                        });
                    categoryController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Category added sucessfully"),
                        behavior: .floating,
                      ),
                    );
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(err.toString()),
                        behavior: .floating,
                      ),
                    );
                  }
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }
}
