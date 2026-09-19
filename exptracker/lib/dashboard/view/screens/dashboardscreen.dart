import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/screens/addexpense_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as logger;

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<Expenseprovider>().fetchExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(color: Commoncolors.commonWhite),
        ),
        centerTitle: false,
        backgroundColor: Commoncolors.primaryColor,
        actions: [
          Consumer<Expenseprovider>(
            builder: (context, provider, child) {
              return Text(
                "Total: ${provider.getTotalExpense()}",
                style: TextStyle(color: Commoncolors.commonWhite),
              );
            },
          ),
        ],
        actionsPadding: const EdgeInsets.all(10),
      ),
      body: Consumer<Expenseprovider>(
        builder: (context, provider, child) {
          return provider.expense.isEmpty
              ? Center(child: Text("No Expense"))
              : ListView.builder(
                  itemCount: provider.getCategoryTotal().length,
                  itemBuilder: (context, index) {
                    Map categoryAmount = provider.getCategoryTotal();
                    String category = categoryAmount.keys.elementAt(index);
                    num amount = categoryAmount[category];

                    return Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Commoncolors.commonWhite,
                          border: Border(
                            bottom: BorderSide(
                              width: 4,
                              color: Commoncolors.commonRed,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Category: $category"),
                            Text("Amount: $amount"),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddexpenseScreen()),
          );
        },
        backgroundColor: Commoncolors.primaryColor,
        foregroundColor: Commoncolors.commonWhite,
        shape: const CircleBorder(),
        child: const Text("add"),
      ),
    );
  }
}
