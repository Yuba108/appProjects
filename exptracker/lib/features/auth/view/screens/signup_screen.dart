import 'package:exptracker/common/common_button.dart';
import 'package:exptracker/common/common_text_field.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/view/screens/homescreen.dart';
import 'package:exptracker/features/auth/view/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:developer' as logger;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: .center,
              spacing: 30,
              children: [
                Text(
                  "Signup",
                  style: TextStyle(
                    color: Commoncolors.primaryColor,
                    fontSize: 30,
                    fontWeight: .bold,
                  ),
                ),
                CommonTextField(hinttext: "Email", controller: emailController),
                CommonTextField(
                  hinttext: "Password",
                  controller: passwordController,
                ),
                CommonTextField(
                  hinttext: "Confirm Password",
                  controller: confirmPasswordController,
                ),
                CommonButton(
                  text: "SIGN UP",
                  onTap: () async {
                    try {
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      String confirmPassword = confirmPasswordController.text
                          .trim();
                      if (email.isEmpty ||
                          password.isEmpty ||
                          confirmPassword.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Commoncolors.primaryColor,
                            content: Text("Empty fields not allowed"),
                          ),
                        );
                        return;
                      } else {
                        if (password != confirmPassword) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Commoncolors.primaryColor,
                              content: Text(
                                "Password and confirmpassword must match!",
                              ),
                            ),
                          );
                          return;
                        } else {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Homescreen(),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Commoncolors.primaryColor,
                          content: Text(e.toString()),
                        ),
                      );
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: .center,
                  spacing: 3,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Commoncolors.primaryColor),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Commoncolors.primaryColor,
                          fontWeight: .w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
