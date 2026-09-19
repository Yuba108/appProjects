import 'package:exptracker/common/commoncolors.dart';
import 'package:exptracker/dashboard/view/screens/addcategoryscreen.dart';
import 'package:exptracker/features/auth/view/screens/loginscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Settingsscreen extends StatelessWidget {
  const Settingsscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: Commoncolors.commonWhite),
        ),
        centerTitle: true,
        backgroundColor: Commoncolors.primaryColor,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Commoncolors.commonGrey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border(
                    left: BorderSide(width: 4, color: Commoncolors.commonRed),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Logout"),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 20,
                                children: [
                                  const Text("Are you sure ?"),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      spacing: 40,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
                                            if (!context.mounted) return;
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                              (route) => false,
                                            );
                                          },
                                          child: const Text("Yes"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("No"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Addcategoryscreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Commoncolors.commonGrey,
                    borderRadius: BorderRadius.circular(10),
                    border: Border(
                      left: BorderSide(width: 4, color: Commoncolors.commonRed),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Add Category"),
                      GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.category_outlined),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
