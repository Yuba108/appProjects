import 'package:asm_notes/common/commo_text_field.dart';
import 'package:asm_notes/common/common_button.dart';
import 'package:asm_notes/common/common_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class Loginscreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController displayName = TextEditingController();
  new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            spacing: 30,
            mainAxisAlignment: .center,
            children: [
              CommoTextField(hint: "name", controller: displayName),
              CommoTextField(hint: "Email", controller: emailController),
              CommoTextField(hint: "Password", controller: passwordController),
              CommonButton(
                text: "Login",
                onTap: () async {
                  try {
                    if (passwordController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty ||
                        displayName.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Empty field"),
                          behavior: .floating,
                        ),
                      );
                      return;
                    }
                    String email = emailController.text.trim();
                    String pass = passwordController.text.trim();

                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: pass,
                    );

                    User? currentUser = FirebaseAuth.instance.currentUser;
                    if (currentUser != null) {
                      currentUser.updateDisplayName(displayName.text.trim());
                    }

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Login sucessful : ${FirebaseAuth.instance.currentUser}",
                        ),
                        behavior: .floating,
                      ),
                    );
                    Navigator.pushReplacementNamed(context, "/");
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
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/signUp");
                },
                child: Text(
                  "Create a new Account ?",
                  style: TextStyle(
                    color: CommonColors.primaryColor,
                    fontWeight: .bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
