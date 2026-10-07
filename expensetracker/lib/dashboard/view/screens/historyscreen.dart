import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/screens/edit_expensescreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Historyscreen extends StatefulWidget {
  const Historyscreen({super.key});

  @override
  State<Historyscreen> createState() => _HistoryscreenState();
}

class _HistoryscreenState extends State<Historyscreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Expenseprovider>().fetchExpense();
    });
  }

  Future<void> _deleteExpense(String docId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete expense?"),
        content: const Text("This expense will be permanently removed."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Commoncolors.commonRed,
            ),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (shouldDelete != true || !mounted) return;
    try {
      await FirebaseFirestore.instance.collection('Expense').doc(docId).delete();
      await context.read<Expenseprovider>().fetchExpense();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Expense deleted")),
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't delete expense: $error")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expense history")),
      body: Consumer<Expenseprovider>(
        builder: (context, provider, child) {
          if (provider.isLoading && provider.expense.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.loadError != null && provider.expense.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 40,
                      color: Commoncolors.commonGrey,
                    ),
                    const SizedBox(height: 12),
                    const Text("Couldn't load your expense history."),
                    TextButton.icon(
                      onPressed: provider.fetchExpense,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Try again"),
                    ),
                  ],
                ),
              ),
            );
          }
          if (provider.expense.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.fetchExpense,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: const [
                  SizedBox(height: 100),
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 52,
                    color: Commoncolors.primaryColor,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No expenses yet",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Commoncolors.darkGreen,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Expenses you add will show up here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Commoncolors.commonGrey),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: provider.fetchExpense,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: provider.expense.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final expense = provider.expense[index];
                final title = expense['title']?.toString() ?? "Expense";
                final category =
                    expense['catergoryName']?.toString() ?? "Uncategorized";
                final amount = expense['amount'];
                final docId = expense['docId'].toString();

                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
                  decoration: BoxDecoration(
                    color: Commoncolors.commonWhite,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Commoncolors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Commoncolors.softGreen,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.receipt_outlined,
                          color: Commoncolors.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Commoncolors.darkGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              category,
                              style: const TextStyle(
                                color: Commoncolors.commonGrey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            amount.toString(),
                            style: const TextStyle(
                              color: Commoncolors.darkGreen,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                tooltip: "Edit expense",
                                visualDensity: VisualDensity.compact,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EditExpenseScreen(docId: docId),
                                    ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Commoncolors.commonBlue,
                                ),
                              ),
                              IconButton(
                                tooltip: "Delete expense",
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _deleteExpense(docId),
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Commoncolors.commonRed,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
