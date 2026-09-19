import 'package:asm_notes/common/common_colors.dart';
import 'package:asm_notes/home/controller/note_provider.dart';
import 'package:asm_notes/home/controller/theme_provider.dart';
import 'package:asm_notes/home/views/edit_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NoteProvider>().fetchNote();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            return GestureDetector(
              onTap: () {
                provider.changeTheme();
              },
              child: Icon(
                provider.theme == ThemeData.light()
                    ? Icons.light_mode_outlined
                    : Icons.dark_mode_outlined,
              ),
            );
          },
        ),
        actionsPadding: EdgeInsets.all(10),
        centerTitle: true,
        title: Text(
          " Welcome ${FirebaseAuth.instance.currentUser!.displayName ?? "Unkonwn"}",
          style: TextStyle(fontWeight: .bold),
        ),
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Logout sucessful"),
                  behavior: .floating,
                ),
              );
              Navigator.pushReplacementNamed(context, "/login");
            },
            child: Icon(Icons.logout_outlined, size: 24),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 20,
            children: [
              Text(
                "Your notes",
                style: TextStyle(fontSize: 24, fontWeight: .bold),
              ),

              Consumer<NoteProvider>(
                builder: (context, provider, child) {
                  return SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height - 200,
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: provider.notes.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Container(
                              color: Colors.grey,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: .spaceBetween,
                                  children: [
                                    Text(
                                      provider.notes[index]['title'],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: .bold,
                                      ),
                                    ),
                                    ClipRect(
                                      clipBehavior: .hardEdge,
                                      child: Text(
                                        provider.notes[index]['desc'],
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        Text(
                                          provider.notes[index]['date'],
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditScreen(
                                                          index: index,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                size: 20,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                try {
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection('notes')
                                                      .doc(
                                                        provider
                                                            .notes[index]['docId'],
                                                      )
                                                      .delete();
                                                  provider.fetchNote();
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            "note deleted sucessfully",
                                                          ),
                                                          behavior: .floating,
                                                        ),
                                                      );
                                                } catch (err) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            err.toString(),
                                                          ),
                                                          behavior: .floating,
                                                        ),
                                                      );
                                                }
                                              },
                                              child: Icon(
                                                Icons.delete_outline,
                                                size: 20,
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
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/addNote");
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
