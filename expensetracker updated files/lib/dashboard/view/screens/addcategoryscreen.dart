import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/widgets/expensetextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _CategoryRemovalChoice { keepHistory, deleteHistory }

class Addcategoryscreen extends StatefulWidget {
  const Addcategoryscreen({super.key});

  @override
  State<Addcategoryscreen> createState() => _AddcategoryscreenState();
}

class _AddcategoryscreenState extends State<Addcategoryscreen> {
  final TextEditingController categoryController = TextEditingController();
  Stream<QuerySnapshot<Map<String, dynamic>>>? categoriesStream;
  bool isSaving = false;
  String? removingCategoryId;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      categoriesStream = FirebaseFirestore.instance
          .collection('categories')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
  }

  Future<void> _saveCategory() async {
    final category = categoryController.text.trim();
    if (category.isEmpty || category.length > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a category name of 60 characters or fewer."),
        ),
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
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Category added")));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Couldn't add category: $error")));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> _removeCategory(
    QueryDocumentSnapshot<Map<String, dynamic>> category,
  ) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError("Please sign in again to continue.");

      final categoryReference = category.reference;
      final categorySnapshot = await categoryReference.get();
      if (!categorySnapshot.exists ||
          categorySnapshot.data()?['userId'] != user.uid) {
        throw StateError("This category is no longer available.");
      }

      final categoryName =
          categorySnapshot.data()?['categoryName']?.toString() ?? "";
      if (categoryName.isEmpty) {
        throw StateError("This category has no name and cannot be removed.");
      }

      final database = FirebaseFirestore.instance;
      final expensesQuery = database
          .collection('Expense')
          .where('userId', isEqualTo: user.uid)
          .where('catergoryName', isEqualTo: categoryName);
      final expenseCount = (await expensesQuery.count().get()).count;
      if (expenseCount == null) {
        throw StateError("Couldn't count expenses for this category.");
      }

      if (!mounted) return;
      final choice = await showDialog<_CategoryRemovalChoice>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: Text('Remove "$categoryName"?'),
          content: Text(
            expenseCount == 0
                ? 'This category has no saved expenses.'
                : '$expenseCount saved ${expenseCount == 1 ? 'expense uses' : 'expenses use'} this category. Keep the history, or permanently delete it too?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            if (expenseCount == 0)
              FilledButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  _CategoryRemovalChoice.keepHistory,
                ),
                child: const Text("Remove category"),
              )
            else ...[
              TextButton(
                onPressed: () => Navigator.pop(
                  dialogContext,
                  _CategoryRemovalChoice.keepHistory,
                ),
                child: const Text("Keep expense history"),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Commoncolors.commonRed,
                ),
                onPressed: () => Navigator.pop(
                  dialogContext,
                  _CategoryRemovalChoice.deleteHistory,
                ),
                child: const Text("Delete history"),
              ),
            ],
          ],
        ),
      );

      if (choice == null || !mounted) return;
      setState(() => removingCategoryId = category.id);

      if (choice == _CategoryRemovalChoice.deleteHistory) {
        while (true) {
          final expenses = await expensesQuery.limit(450).get();
          if (expenses.docs.isEmpty) break;

          final batch = database.batch();
          for (final expense in expenses.docs) {
            batch.delete(expense.reference);
          }
          await batch.commit();
        }
      }

      await categoryReference.delete();
      if (choice == _CategoryRemovalChoice.deleteHistory && mounted) {
        await context.read<Expenseprovider>().fetchExpense();
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            choice == _CategoryRemovalChoice.deleteHistory && expenseCount > 0
                ? 'Category and expense history removed'
                : 'Category removed',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't remove category: $error")),
      );
    } finally {
      if (mounted) setState(() => removingCategoryId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Manage categories")),
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
          const SizedBox(height: 28),
          const Text(
            "YOUR CATEGORIES",
            style: TextStyle(
              color: Commoncolors.commonGrey,
              fontSize: 12,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          if (categoriesStream == null)
            const Text("Please sign in to manage your categories.")
          else
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: categoriesStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text(
                    "Couldn't load categories: ${snapshot.error}",
                    style: const TextStyle(color: Commoncolors.commonRed),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final categories = snapshot.data!.docs;
                if (categories.isEmpty) {
                  return const Text("No categories yet. Add one above.");
                }

                return Column(
                  children: categories.map((category) {
                    final categoryName =
                        category.data()['categoryName']?.toString() ??
                        "Unnamed category";
                    final isRemoving = removingCategoryId == category.id;

                    return Card(
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Commoncolors.softGreen,
                          child: Icon(
                            Icons.category_outlined,
                            color: Commoncolors.primaryColor,
                          ),
                        ),
                        title: Text(categoryName),
                        trailing: isRemoving
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : IconButton(
                                tooltip: 'Remove $categoryName',
                                onPressed: removingCategoryId == null
                                    ? () => _removeCategory(category)
                                    : null,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Commoncolors.commonRed,
                                ),
                              ),
                      ),
                    );
                  }).toList(),
                );
              },
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
