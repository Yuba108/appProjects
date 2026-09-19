import 'package:asm_notes/common/commo_text_field.dart';
import 'package:asm_notes/common/common_button.dart';
import 'package:asm_notes/home/controller/note_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:developer' as logger;

class AddNotesScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  AddNotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true,
        title: Text("Add Notes Screen"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 20,
            children: [
              CommoTextField(hint: "title", controller: titleController),
              CommoTextField(
                minLines: 5,
                maxLines: 10,
                hint: "description",
                controller: descController,
              ),
              CommonButton(
                text: "ADD",
                onTap: () async {
                  if (titleController.text.trim() == '' ||
                      descController.text.trim() == '') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Fields can't be empty"),
                        behavior: .floating,
                      ),
                    );
                    return;
                  }
                  try {
                    FirebaseFirestore.instance.collection("notes").add({
                      "title": titleController.text.trim(),
                      "description": descController.text.trim(),
                      "userId": FirebaseAuth.instance.currentUser!.uid,
                      "date": DateTime.now().toString().substring(0, 10),
                    });
                  } catch (err) {
                    logger.log(err.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(err.toString()),
                        behavior: .floating,
                      ),
                    );
                  }
                  Navigator.pushReplacementNamed(context, "/");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
