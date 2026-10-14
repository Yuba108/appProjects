import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/bottom_navbar_provider.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/screens/addexpense_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  bool _sortByAmount = true;
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Expenseprovider>().fetchExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Overview")),
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
                    const Text(
                      "Couldn't load your expenses.",
                      style: TextStyle(
                        color: Commoncolors.darkGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
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
          final categoryTotals = provider.getSortedCategoryTotals(
            sortByAmount: _sortByAmount,
            ascending: _sortAscending,
          );
          return RefreshIndicator(
            onRefresh: provider.fetchExpense,
            child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.userChanges(),
              initialData: FirebaseAuth.instance.currentUser,
              builder: (context, userSnapshot) {
                final displayName = userSnapshot.data?.displayName;
                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                  children: [
                    if (displayName?.isNotEmpty == true) ...[
                      Text(
                        "Hello, $displayName",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Commoncolors.darkGreen,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],
                    Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Commoncolors.primaryColor,
                            Commoncolors.darkGreen,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.account_balance_wallet_outlined,
                                color: Colors.white70,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Total spending",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            provider.getTotalExpense().toStringAsFixed(2),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "${provider.expense.length} ${provider.expense.length == 1 ? 'expense' : 'expenses'} recorded",
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "By category",
                              style: TextStyle(
                                color: Commoncolors.darkGreen,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "See where your money goes",
                              style: TextStyle(color: Commoncolors.commonGrey),
                            ),
                          ],
                        ),
                        Text(
                          "${categoryTotals.length} categories",
                          style: const TextStyle(
                            color: Commoncolors.commonGrey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (provider.expense.isNotEmpty)
                      Row(
                        children: [
                          const Text(
                            "Sort by",
                            style: TextStyle(
                              color: Commoncolors.commonGrey,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: DropdownButtonFormField<bool>(
                              initialValue: _sortByAmount,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: true,
                                  child: Text("Expense amount"),
                                ),
                                DropdownMenuItem(
                                  value: false,
                                  child: Text("Category name"),
                                ),
                              ],
                              onChanged: (sortByAmount) {
                                if (sortByAmount == null) return;
                                setState(() => _sortByAmount = sortByAmount);
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            tooltip: _sortAscending
                                ? "Sort descending"
                                : "Sort ascending",
                            onPressed: () {
                              setState(() => _sortAscending = !_sortAscending);
                            },
                            icon: Icon(
                              _sortAscending
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                            ),
                          ),
                        ],
                      ),
                    if (provider.expense.isNotEmpty) const SizedBox(height: 14),
                    if (provider.expense.isEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 32,
                        ),
                        decoration: BoxDecoration(
                          color: Commoncolors.commonWhite,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Commoncolors.border),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 40,
                              color: Commoncolors.primaryColor,
                            ),
                            SizedBox(height: 12),
                            Text(
                              "Your spending will appear here",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Commoncolors.darkGreen,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Add your first expense to get started.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Commoncolors.commonGrey),
                            ),
                          ],
                        ),
                      )
                    else
                      ...categoryTotals.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Commoncolors.commonWhite,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Commoncolors.border),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(18),
                              onTap: () {
                                context
                                    .read<BottomNavbarProvider>()
                                    .showCategoryHistory(entry.key);
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: Commoncolors.softGreen,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: const Icon(
                                      Icons.local_offer_outlined,
                                      color: Commoncolors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: const TextStyle(
                                        color: Commoncolors.darkGreen,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    entry.value.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Commoncolors.darkGreen,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddexpenseScreen()),
          );
        },
        backgroundColor: Commoncolors.primaryColor,
        foregroundColor: Commoncolors.commonWhite,
        icon: const Icon(Icons.add),
        label: const Text("Add expense"),
      ),
    );
  }
}
