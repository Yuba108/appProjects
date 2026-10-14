import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/widgets/expensetextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditExpenseScreen extends StatefulWidget {
  const EditExpenseScreen({super.key, required this.docId});

  final String docId;

  @override
  State<EditExpenseScreen> createState() => _EditExpenseScreenState();
}

class _EditExpenseScreenState extends State<EditExpenseScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  List<String> categories = [];
  String? selectedCategory;
  bool isLoading = true;
  bool isCategoriesLoading = true;
  bool isSaving = false;
  String? loadError;
  String? categoriesLoadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExpense();
      _loadCategories();
    });
  }

  Future<void> _loadExpense() async {
    try {
      final expenseProvider = context.read<Expenseprovider>();
      await expenseProvider.fetchExpenseWithDocId(widget.docId);
      final expense = expenseProvider.expenseWithDocId;
      if (expense == null) {
        throw StateError("This expense could not be found.");
      }
      titleController.text = expense['title']?.toString() ?? "";
      selectedCategory = expense['catergoryName']?.toString();
      amountController.text = expense['amount']?.toString() ?? "";
    } catch (error) {
      loadError = error.toString();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      isCategoriesLoading = true;
      categoriesLoadError = null;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError("Please sign in again to continue.");

      final snapshot = await FirebaseFirestore.instance
          .collection('categories')
          .where('userId', isEqualTo: user.uid)
          .get();
      categories =
          snapshot.docs
              .map((doc) => doc.data()['categoryName']?.toString().trim() ?? '')
              .where((name) => name.isNotEmpty)
              .toSet()
              .toList()
            ..sort(
              (first, second) =>
                  first.toLowerCase().compareTo(second.toLowerCase()),
            );
    } catch (error) {
      categoriesLoadError = error.toString();
    } finally {
      if (mounted) setState(() => isCategoriesLoading = false);
    }
  }

  Future<void> _saveExpense() async {
    final title = titleController.text.trim();
    final category = selectedCategory;
    final amount = int.tryParse(amountController.text.trim());
    if (title.isEmpty ||
        title.length > 120 ||
        category == null ||
        category.length > 60 ||
        amount == null ||
        amount <= 0 ||
        amount > 1000000000) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Enter a title (up to 120 characters), choose a category, and enter an amount greater than zero.",
          ),
        ),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      final expenseProvider = context.read<Expenseprovider>();
      await FirebaseFirestore.instance
          .collection('Expense')
          .doc(widget.docId)
          .update({
            'catergoryName': category,
            'amount': amount,
            'title': title,
          });

      await expenseProvider.fetchExpense();
      if (!mounted) return;
      final navigator = Navigator.of(context);
      final messenger = ScaffoldMessenger.of(context);
      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text("Expense updated")),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't update expense: $error")),
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit expense")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Commoncolors.commonRed,
                      size: 40,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Couldn't load this expense.\n$loadError",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _loadExpense,
                      child: const Text("Try again"),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  "Update the details below.",
                  style: TextStyle(color: Commoncolors.commonGrey),
                ),
                const SizedBox(height: 20),
                Expensetextfield(
                  labeltext: "Title",
                  controller: titleController,
                  prefixIcon: Icons.edit_note,
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: categories.contains(selectedCategory)
                      ? selectedCategory
                      : null,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  hint: Text(
                    isCategoriesLoading
                        ? "Loading categories..."
                        : categories.isEmpty
                        ? "No categories available"
                        : "Choose a category",
                  ),
                  items: categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  onChanged: isSaving || isCategoriesLoading
                      ? null
                      : (category) =>
                            setState(() => selectedCategory = category),
                ),
                if (categoriesLoadError != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    "Couldn't load categories: $categoriesLoadError",
                    style: const TextStyle(color: Commoncolors.commonRed),
                  ),
                  TextButton.icon(
                    onPressed: isCategoriesLoading ? null : _loadCategories,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry loading categories"),
                  ),
                ] else if (!isCategoriesLoading && categories.isEmpty) ...[
                  const SizedBox(height: 6),
                  const Text(
                    "Add a category before editing this expense.",
                    style: TextStyle(color: Commoncolors.commonGrey),
                  ),
                ] else if (selectedCategory != null &&
                    !categories.contains(selectedCategory)) ...[
                  const SizedBox(height: 6),
                  Text(
                    '"$selectedCategory" is no longer available. Choose an existing category.',
                    style: const TextStyle(color: Commoncolors.commonGrey),
                  ),
                ],
                const SizedBox(height: 14),
                Expensetextfield(
                  inputType: TextInputType.number,
                  labeltext: "Amount",
                  controller: amountController,
                  prefixIcon: Icons.payments_outlined,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : _saveExpense,
                    child: isSaving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Save changes"),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    amountController.dispose();
    super.dispose();
  }
}
