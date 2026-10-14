import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/bottom_navbar_provider.dart';
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
      final expenseProvider = context.read<Expenseprovider>();
      await FirebaseFirestore.instance
          .collection('Expense')
          .doc(docId)
          .delete();
      await expenseProvider.fetchExpense();
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Expense deleted")));
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Couldn't delete expense: $error")),
      );
    }
  }

  Widget _buildExpenseCard(
    BuildContext context,
    Map<String, dynamic> expense,
  ) {
    final title = expense['title']?.toString() ?? "Expense";
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
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Commoncolors.darkGreen,
                fontWeight: FontWeight.w700,
              ),
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
                          builder: (context) => EditExpenseScreen(docId: docId),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<BottomNavbarProvider>(
          builder: (context, navigation, child) => Text(
            navigation.historyCategoryFilter == null
                ? "Expense history"
                : "${navigation.historyCategoryFilter} history",
          ),
        ),
        actions: [
          Consumer<BottomNavbarProvider>(
            builder: (context, navigation, child) {
              if (navigation.historyCategoryFilter == null) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: navigation.clearHistoryCategoryFilter,
                child: const Text("Show all"),
              );
            },
          ),
        ],
      ),
      body: Consumer<Expenseprovider>(
        builder: (context, provider, child) {
          final categoryFilter = context
              .watch<BottomNavbarProvider>()
              .historyCategoryFilter;
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
          if (provider.expense.isEmpty && categoryFilter == null) {
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

          final visibleExpenses = categoryFilter == null
              ? provider.expense
              : provider.expense.where((expense) {
                  final category =
                      expense['catergoryName']?.toString().trim().isNotEmpty ==
                          true
                      ? expense['catergoryName'].toString().trim()
                      : "Uncategorized";
                  return category == categoryFilter;
                }).toList();
          if (visibleExpenses.isEmpty) {
            return RefreshIndicator(
              onRefresh: provider.fetchExpense,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  const SizedBox(height: 100),
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 52,
                    color: Commoncolors.primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "No expenses in $categoryFilter",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Commoncolors.darkGreen,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Pull down to refresh or show all expenses.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Commoncolors.commonGrey),
                  ),
                ],
              ),
            );
          }

          final expensesByCategory = <String, List<Map<String, dynamic>>>{};
          for (final expense in visibleExpenses) {
            final category =
                expense['catergoryName']?.toString().trim().isNotEmpty == true
                ? expense['catergoryName'].toString().trim()
                : "Uncategorized";
            expensesByCategory.putIfAbsent(category, () => []).add(expense);
          }
          final categories = expensesByCategory.keys.toList()
            ..sort(
              (first, second) =>
                  first.toLowerCase().compareTo(second.toLowerCase()),
            );
          final rows =
              <
                ({
                  String? category,
                  Map<String, dynamic>? expense,
                  int expenseCount,
                })
              >[];
          for (final category in categories) {
            final expenses = expensesByCategory[category]!;
            rows.add((
              category: category,
              expense: null,
              expenseCount: expenses.length,
            ));
            for (final expense in expenses) {
              rows.add((
                category: null,
                expense: expense,
                expenseCount: 0,
              ));
            }
          }

          return RefreshIndicator(
            onRefresh: provider.fetchExpense,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: rows.length,
              itemBuilder: (context, index) {
                final row = rows[index];
                final category = row.category;
                if (category != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            category,
                            style: const TextStyle(
                              color: Commoncolors.darkGreen,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          "${row.expenseCount} ${row.expenseCount == 1 ? 'expense' : 'expenses'}",
                          style: const TextStyle(
                            color: Commoncolors.commonGrey,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                final expense = row.expense;
                if (expense == null) {
                  throw StateError("History row has no category or expense.");
                }
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _buildExpenseCard(context, expense),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
