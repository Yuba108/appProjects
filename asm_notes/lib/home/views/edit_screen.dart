import 'package:asm_notes/common/commo_text_field.dart';
import 'package:asm_notes/common/common_button.dart';
import 'package:asm_notes/home/controller/note_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditScreen extends StatelessWidget {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  final int index;
  new({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true,
        title: Text("Edit Note"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Consumer<NoteProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                spacing: 10,
                children: [
                  CommoTextField(
                    hint: "title",
                    controller: titleController = TextEditingController(
                      text: provider.notes[index]['title'],
                    ),
                  ),
                  CommoTextField(
                    minLines: 5,
                    maxLines: 10,
                    hint: "description",
                    controller: descController = TextEditingController(
                      text: provider.notes[index]["desc"],
                    ),
                  ),
                  CommonButton(
                    text: "UPDATE",
                    onTap: () {
                      FirebaseFirestore.instance
                          .collection('notes')
                          .doc(provider.notes[index]['docId'])
                          .update({
                            'title': titleController.text.trim(),
                            'description': descController.text.trim(),
                            'date': DateTime.now().toString().substring(0, 10),
                          });
                      Navigator.pushReplacementNamed(context, "/");
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
