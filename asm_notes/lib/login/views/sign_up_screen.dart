import 'package:asm_notes/common/commo_text_field.dart';
import 'package:asm_notes/common/common_button.dart';
import 'package:asm_notes/common/common_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
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
              CommoTextField(hint: "Email", controller: emailController),
              CommoTextField(hint: "Password", controller: passwordController),
              CommoTextField(
                hint: "Confirm Password",
                controller: confirmPasswordController,
              ),
              CommonButton(
                text: "SIGN UP",
                onTap: () async {
                  try {
                    if (passwordController.text.trim().isEmpty ||
                        confirmPasswordController.text.trim().isEmpty ||
                        emailController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Empty field"),
                          behavior: .floating,
                        ),
                      );
                      return;
                    }
                    if (passwordController.text.trim() !=
                        confirmPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Password doesn't match"),
                          behavior: .floating,
                        ),
                      );
                      return;
                    }
                    String email = emailController.text.trim();
                    String pass = passwordController.text.trim();
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email,
                      password: pass,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Sign up sucessful"),
                        behavior: .floating,
                      ),
                    );
                    Navigator.pushReplacementNamed(context, "/login");
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
                  Navigator.pushReplacementNamed(context, "/login");
                },
                child: Text(
                  "Already have an account ?",
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
    ;
  }
}
