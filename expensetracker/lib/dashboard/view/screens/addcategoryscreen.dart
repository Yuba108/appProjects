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
  bool isSaving = false;

  Future<void> _saveCategory() async {
    final category = categoryController.text.trim();
    if (category.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter a category name to continue.")),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError("Please sign in again to continue.");

      await FirebaseFirestore.instance.collection('categories').add({
        'categoryName': category,
        'userId': user.uid,
      });
      if (!mounted) return;
      categoryController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Category added")),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't add category: $error")),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add category")),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Commoncolors.softGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "Organize expenses with categories that make sense to you.",
              style: TextStyle(
                color: Commoncolors.darkGreen,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expensetextfield(
            hinttext: "Category name",
            controller: categoryController,
            prefixIcon: Icons.category_outlined,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isSaving ? null : _saveCategory,
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Save category"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }
}
