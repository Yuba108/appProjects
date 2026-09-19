import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/common_button.dart';
import 'package:exptracker/common/common_text_field.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

import 'package:provider/provider.dart';

class EditExpenseScreen extends StatefulWidget {
  String docId;
  new({super.key, required this.docId});

  @override
  State<EditExpenseScreen> createState() => EditExpenseScreenState();
}

class EditExpenseScreenState extends State<EditExpenseScreen> {
  TextEditingController? titleController;
  TextEditingController? amountController;
  TextEditingController? categoryController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // logger.log(widget.docId);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<Expenseprovider>().fetchExpenseWithDocId(widget.docId);

      titleController = TextEditingController(
        text:
            context.read<Expenseprovider>().expenseWithDocId!['title'] ??
            "unknown",
      );

      categoryController = TextEditingController(
        text:
            context
                .read<Expenseprovider>()
                .expenseWithDocId!['catergoryName'] ??
            "unknown",
      );

      amountController = TextEditingController(
        text:
            context
                .read<Expenseprovider>()
                .expenseWithDocId!['amount']
                .toString() ??
            "unknown",
      );
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Expense Screen")),
      body:
          (categoryController == null ||
              amountController == null ||
              titleController == null)
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsetsGeometry.all(8.0),
              child: Column(
                spacing: 10,
                children: [
                  CommonTextField(
                    hinttext: "category",
                    controller: categoryController!,
                  ),
                  CommonTextField(
                    type: .number,
                    hinttext: "amount",
                    controller: amountController!,
                  ),
                  CommonTextField(
                    hinttext: "title",
                    controller: titleController!,
                  ),
                  CommonButton(
                    text: "Edit",
                    onTap: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('Expense')
                            .doc(widget.docId)
                            .update({
                              'catergoryName': categoryController!.text,
                              'amount': int.parse(amountController!.text),
                              'title': titleController!.text,
                            });

                        await context.read<Expenseprovider>().fetchExpense();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Expense Edited Sucessfully"),
                            behavior: .floating,
                          ),
                        );
                      } catch (err) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(err.toString()),
                            behavior: .floating,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
