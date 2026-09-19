import 'dart:developer' as logger;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/controller/dropdown_provider.dart';
import 'package:exptracker/dashboard/controller/expenseprovider.dart';
import 'package:exptracker/dashboard/view/widgets/expensetextfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddexpenseScreen extends StatefulWidget {
  const AddexpenseScreen({super.key});

  @override
  State<AddexpenseScreen> createState() => _AddexpenseScreenState();
}

class _AddexpenseScreenState extends State<AddexpenseScreen> {
  final TextEditingController amountcontroller = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DropdownProvider>().fetchCategroy();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Expense")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 20,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Commoncolors.commonWhite,
                borderRadius: BorderRadius.circular(20),
              ),
              width: double.infinity,
              child: Consumer<DropdownProvider>(
                builder: (context, provider, child) {
                  return DropdownButton<String>(
                    isExpanded: true,
                    underline: const SizedBox(),
                    hint: const Text("choose a category"),
                    value: provider.selectedValue,

                    // items: const [
                    //   DropdownMenuItem(value: "foo", child: Text("food")),
                    //   DropdownMenuItem(value: "clo", child: Text("Clothes")),
                    //   DropdownMenuItem(value: "gro", child: Text("Grocery")),
                    //   DropdownMenuItem(
                    //     value: "trp",
                    //     child: Text("transportation"),
                    //   ),
                    // ],
                    items: List.generate(provider.categories.length, (index) {
                      return DropdownMenuItem(
                        value: "${provider.categories[index]['categoryName']}",
                        child: Text(provider.categories[index]['categoryName']),
                      );
                    }),
                    onChanged: (value) {
                      logger.log(value.toString());
                      provider.changeValue(value);
                    },
                  );
                },
              ),
            ),
            Expensetextfield(
              inputType: TextInputType.number,
              hinttext: "amount",
              controller: amountcontroller,
            ),
            Expensetextfield(hinttext: "title", controller: titleController),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Commoncolors.primaryColor,
                  padding: const EdgeInsets.all(15),
                  foregroundColor: Commoncolors.commonWhite,
                ),
                onPressed: () async {
                  String? category = context
                      .read<DropdownProvider>()
                      .selectedValue;
                  String amount = amountcontroller.text;
                  String title = titleController.text;

                  if (category == null ||
                      amount.trim().isEmpty ||
                      title.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("All fields must be provided"),
                        behavior: .floating,
                      ),
                    );
                    return;
                  }
                  try {
                    FirebaseFirestore.instance.collection('Expense').add({
                      'catergoryName': category,
                      'userId': FirebaseAuth.instance.currentUser!.uid,
                      'amount': int.parse(amount),
                      'title': title,
                    });
                    await context.read<Expenseprovider>().fetchExpense();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("expense added sucessfully"),
                        behavior: .floating,
                      ),
                    );
                    context.read<DropdownProvider>().clearCategory();
                    amountcontroller.clear();
                    titleController.clear();
                  } catch (err) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(err.toString()),
                        behavior: .floating,
                      ),
                    );
                  }
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    amountcontroller.dispose();
    titleController.dispose();
    super.dispose();
  }
}
