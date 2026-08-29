import 'package:flutter/material.dart';
import 'package:loginui/colors/my_colors.dart';
import 'package:loginui/widgets/common_elevated_button.dart';
import 'package:loginui/widgets/common_text.dart';
import 'package:loginui/widgets/common_textfield.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: MyColors.backgroundColor),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                mainAxisAlignment: .spaceEvenly,

                children: [
                  CommonText(
                    text: "Login here",
                    textcolor: MyColors.redColor,
                    fontWeight: .bold,
                    fontsize: 20,
                    textalign: .center,
                  ),
                  CommonText(
                    text: "Welcome Back where you've been missed",
                    textcolor: Colors.black,
                    fontWeight: .bold,
                    fontsize: 18,
                    textalign: .center,
                  ),
                  CommonTextfield(
                    hinttext: "Email",
                    labeltext: "Email",
                    helpertext: "",
                    obscuretext: false,
                  ),
                  CommonTextfield(
                    hinttext: "Password",
                    labeltext: "Password",
                    helpertext: "",
                    obscuretext: true,
                  ),
                  CommonText(
                    text: "Forgot your Password?",
                    textcolor: MyColors.redColor,
                    fontWeight: .bold,
                    fontsize: 10,
                    textalign: .left,
                  ),
                  SizedBox(
                    width: 250,
                    child: CommonElevatedButton(
                      bgclr: MyColors.redColor,
                      text: "Login",
                      elevation: 5,
                      textcolor: Colors.white,
                    ),
                  ),
                  CommonText(
                    text: "Create a new account",
                    textcolor: MyColors.blackColor,
                    fontWeight: .w400,
                    fontsize: 16,
                    textalign: .center,
                  ),
                  Row(
                    mainAxisAlignment: .center,
                    spacing: 10,
                    children: [
                      Icon(Icons.g_mobiledata_rounded),
                      Icon(Icons.facebook),
                      Icon(Icons.apple),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
