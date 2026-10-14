import 'dart:developer' as logger;

import 'package:exptracker/common/common_button.dart';
import 'package:exptracker/common/common_text_field.dart';
import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/view/screens/homescreen.dart';
import 'package:exptracker/features/auth/view/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;
  bool isPasswordObscured = true;
  bool isConfirmPasswordObscured = true;

  @override
  void dispose() {
    emailController.dispose();
    displayNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                      spacing: 30,
                      children: [
                        Text(
                          "Create your account",
                          style: TextStyle(
                            color: Commoncolors.darkGreen,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "A clearer view of your everyday spending starts here.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Commoncolors.commonGrey),
                        ),
                        CommonTextField(
                          hinttext: "Display name",
                          controller: displayNameController,
                          prefixIcon: Icons.person_outline,
                        ),
                        CommonTextField(
                          hinttext: "Email address",
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          prefixIcon: Icons.mail_outline,
                        ),
                        CommonTextField(
                          hinttext: "Password",
                          controller: passwordController,
                          obscureText: isPasswordObscured,
                          prefixIcon: Icons.lock_outline,
                          onToggleVisibility: () {
                            setState(
                              () => isPasswordObscured = !isPasswordObscured,
                            );
                          },
                        ),
                        CommonTextField(
                          hinttext: "Confirm Password",
                          controller: confirmPasswordController,
                          obscureText: isConfirmPasswordObscured,
                          prefixIcon: Icons.lock_outline,
                          visibilityToggleTooltip: 'confirm password',
                          onToggleVisibility: () {
                            setState(
                              () => isConfirmPasswordObscured =
                                  !isConfirmPasswordObscured,
                            );
                          },
                        ),
                        CommonButton(
                          text: "Create account",
                          isLoading: isLoading,
                          onTap: () async {
                            final displayName = displayNameController.text
                                .trim();
                            try {
                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();
                              String confirmPassword = confirmPasswordController
                                  .text
                                  .trim();
                              if (displayName.isEmpty ||
                                  email.isEmpty ||
                                  password.isEmpty ||
                                  confirmPassword.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Commoncolors.primaryColor,
                                    content: Text(
                                      "Please complete all fields.",
                                    ),
                                  ),
                                );
                                return;
                              } else {
                                if (password != confirmPassword) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                          Commoncolors.primaryColor,
                                      content: Text(
                                        "Password and confirmpassword must match!",
                                      ),
                                    ),
                                  );
                                  return;
                                } else {
                                  setState(() => isLoading = true);
                                  final credential = await FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );
                                  await credential.user!.updateDisplayName(
                                    displayName,
                                  );
                                  await credential.user!.reload();
                                  if (!context.mounted) return;
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Homescreen(),
                                    ),
                                  );
                                }
                              }
                            } catch (e) {
                              logger.log('Account creation failed', error: e);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Commoncolors.primaryColor,
                                  content: Text(
                                    e is FirebaseAuthException &&
                                            e.code == 'email-already-in-use'
                                        ? "An account already exists for this email."
                                        : e is FirebaseAuthException &&
                                              e.code == 'weak-password'
                                        ? "Choose a stronger password and try again."
                                        : e is FirebaseAuthException &&
                                              e.code == 'network-request-failed'
                                        ? "Couldn't create your account. Check your connection and try again."
                                        : "Couldn't create your account. Check your details and try again.",
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
                              "Already have an account? ",
                              style: TextStyle(color: Commoncolors.commonGrey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: const Text("Sign in"),
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
