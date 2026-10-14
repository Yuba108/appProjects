import 'dart:developer' as logger;

import 'package:exptracker/common/common_button.dart';
import 'package:exptracker/common/common_text_field.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/view/screens/homescreen.dart';
import 'package:exptracker/features/auth/view/screens/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordObscured = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 440),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 20,
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            color: Commoncolors.darkGreen,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Sign in to keep your spending in check.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Commoncolors.commonGrey),
                        ),
                        CommonTextField(
                          hinttext: 'Email address',
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                        ),
                        CommonTextField(
                          hinttext: 'Password',
                          controller: passwordController,
                          obscureText: isPasswordObscured,
                          prefixIcon: Icons.lock_outline,
                          onToggleVisibility: () {
                            setState(
                              () => isPasswordObscured = !isPasswordObscured,
                            );
                          },
                        ),
                        CommonButton(
                          text: "Sign in",
                          isLoading: isLoading,
                          onTap: () async {
                            if (emailController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("can't be empty"),
                                ),
                              );
                              return;
                            }

                            setState(() => isLoading = true);
                            try {
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  );
                              if (!context.mounted) return;
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Homescreen(),
                                ),
                              );
                            } catch (err) {
                              logger.log('Sign-in failed', error: err);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    err is FirebaseAuthException &&
                                            err.code == 'network-request-failed'
                                        ? "Couldn't sign in. Check your connection and try again."
                                        : "Couldn't sign in. Check your email and password and try again.",
                                  ),
                                ),
                              );
                            } finally {
                              if (mounted) setState(() => isLoading = false);
                            }
                          },
                        ),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              "New to Expense Tracker? ",
                              style: TextStyle(
                                color: Commoncolors.commonGrey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text("Create an account"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
