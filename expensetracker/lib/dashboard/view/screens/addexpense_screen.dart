import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/dropdown_provider.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/screens/addcategoryscreen.dart';
import 'package:exptracker/dashboard/view/widgets/expensetextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddexpenseScreen extends StatefulWidget {
  const AddexpenseScreen({super.key});

  @override
  State<AddexpenseScreen> createState() => _AddexpenseScreenState();
}

class _AddexpenseScreenState extends State<AddexpenseScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DropdownProvider>().fetchCategroy();
    });
  }

  Future<void> _addExpense() async {
    final category = context.read<DropdownProvider>().selectedValue;
    final amount = int.tryParse(amountController.text.trim());
    final title = titleController.text.trim();

    if (category == null || amount == null || title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Choose a category and enter a valid amount and title.",
          ),
        ),
      );
      return;
    }

    setState(() => isSaving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw StateError("Please sign in again to continue.");

      await FirebaseFirestore.instance.collection('Expense').add({
        'catergoryName': category,
        'userId': user.uid,
        'amount': amount,
        'title': title,
      });
      await context.read<Expenseprovider>().fetchExpense();
      if (!mounted) return;

      context.read<DropdownProvider>().clearCategory();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Expense added")));
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Couldn't add expense: $error")));
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add expense")),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Commoncolors.softGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.add_card_outlined,
                  size: 30,
                  color: Commoncolors.primaryColor,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Capture a purchase while it's fresh.",
                    style: TextStyle(
                      color: Commoncolors.darkGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Expense details",
            style: TextStyle(
              color: Commoncolors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Consumer<DropdownProvider>(
            builder: (context, provider, child) {
              return DropdownButtonFormField<String>(
                initialValue: provider.selectedValue,
                decoration: const InputDecoration(
                  labelText: "Category",
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                hint: const Text("Choose a category"),
                items: provider.categories
                    .map<DropdownMenuItem<String>>(
                      (category) => DropdownMenuItem<String>(
                        value: category['categoryName'].toString(),
                        child: Text(category['categoryName'].toString()),
                      ),
                    )
                    .toList(),
                onChanged: provider.changeValue,
              );
            },
          ),
          Consumer<DropdownProvider>(
            builder: (context, provider, child) {
              if (provider.categories.isNotEmpty) {
                return const SizedBox(height: 16);
              }
              if (provider.isLoading) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (provider.loadError != null) {
                return Column(
                  children: [
                    Text(
                      "Couldn't load categories: ${provider.loadError}",
                      style: const TextStyle(color: Commoncolors.commonRed),
                    ),
                    TextButton.icon(
                      onPressed: provider.fetchCategroy,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try again"),
                    ),
                  ],
                );
              }
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Addcategoryscreen(),
                      ),
                    );
                    if (context.mounted) {
                      context.read<DropdownProvider>().fetchCategroy();
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add your first category"),
                ),
              );
            },
          ),
          Expensetextfield(
            inputType: TextInputType.number,
            hinttext: "Amount",
            controller: amountController,
            prefixIcon: Icons.payments_outlined,
          ),
          const SizedBox(height: 16),
          Expensetextfield(
            hinttext: "What was it for?",
            controller: titleController,
            prefixIcon: Icons.edit_note,
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: isSaving ? null : _addExpense,
              child: isSaving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Save expense"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    amountController.dispose();
    titleController.dispose();
    super.dispose();
  }
}
