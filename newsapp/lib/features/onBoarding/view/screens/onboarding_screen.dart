import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newsapp/common/common_colors.dart';
import 'package:newsapp/features/home/view/screens/homescreen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                Expanded(
                  flex: 3,
                  child: Lottie.asset(
                    "assets/lottie/onBoarding_animation.json",
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    "Bring the worlds news to your fingerprint",
                    textAlign: .center,
                    style: TextStyle(fontSize: 30, fontWeight: .bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "let's get started",
                    textAlign: .center,
                    style: TextStyle(fontSize: 20, fontWeight: .w500),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Homescreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: commonColors.white,
                      backgroundColor: commonColors.primaryColor,
                    ),
                    child: Text("get started"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
