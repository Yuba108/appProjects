import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/screens/edit_expensescreen.dart';
import 'package:firebase_core/firebase_core.dart';
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
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<Expenseprovider>().fetchExpense();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Expense History",
          style: TextStyle(color: Commoncolors.commonWhite),
        ),
        centerTitle: true,
        backgroundColor: Commoncolors.primaryColor,
      ),
      body: Center(
        child: Consumer<Expenseprovider>(
          builder: (context, provider, child) {
            return provider.expense.isEmpty
                ? Center(child: Text("No expense history"))
                : ListView.builder(
                    itemCount: provider.expense.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Commoncolors.commonWhite,
                            border: Border(
                              left: BorderSide(
                                width: 4,
                                color: Commoncolors.commonRed,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              spacing: 5,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Category: ${provider.expense[index]['catergoryName']}",
                                    ),
                                    Text(
                                      "Amount: ${provider.expense[index]['amount']}",
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "title: ${provider.expense[index]['title']}",
                                    ),
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EditExpenseScreen(
                                                      docId: provider
                                                          .expense[index]['docId'],
                                                    ),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Commoncolors.commonBlue,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            await FirebaseFirestore.instance
                                                .collection('Expense')
                                                .doc(
                                                  provider
                                                      .expense[index]['docId'],
                                                )
                                                .delete();

                                            await context
                                                .read<Expenseprovider>()
                                                .fetchExpense();
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "Expense history deleted sucessfullly",
                                                ),
                                                behavior: .floating,
                                                backgroundColor:
                                                    Commoncolors.primaryColor,
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete_outlined,
                                            color: Commoncolors.commonRed,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
