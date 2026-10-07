import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/widgets/expensetextfield.dart';
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
  final TextEditingController categoryController = TextEditingController();
  bool isLoading = true;
  bool isSaving = false;
  String? loadError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadExpense());
  }

  Future<void> _loadExpense() async {
    try {
      await context.read<Expenseprovider>().fetchExpenseWithDocId(widget.docId);
      final expense = context.read<Expenseprovider>().expenseWithDocId;
      if (expense == null) {
        throw StateError("This expense could not be found.");
      }
      titleController.text = expense['title']?.toString() ?? "";
      categoryController.text = expense['catergoryName']?.toString() ?? "";
      amountController.text = expense['amount']?.toString() ?? "";
    } catch (error) {
      loadError = error.toString();
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _saveExpense() async {
    final title = titleController.text.trim();
    final category = categoryController.text.trim();
    final amount = int.tryParse(amountController.text.trim());
    if (title.isEmpty || category.isEmpty || amount == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter a title, category, and valid whole amount."),
        ),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      await FirebaseFirestore.instance
          .collection('Expense')
          .doc(widget.docId)
          .update({
            'catergoryName': category,
            'amount': amount,
            'title': title,
          });

      await context.read<Expenseprovider>().fetchExpense();
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
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
                  hinttext: "Title",
                  controller: titleController,
                  prefixIcon: Icons.edit_note,
                ),
                const SizedBox(height: 14),
                Expensetextfield(
                  hinttext: "Category",
                  controller: categoryController,
                  prefixIcon: Icons.category_outlined,
                ),
                const SizedBox(height: 14),
                Expensetextfield(
                  inputType: TextInputType.number,
                  hinttext: "Amount",
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
    categoryController.dispose();
    super.dispose();
  }
}
