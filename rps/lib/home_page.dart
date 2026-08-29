import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // image chnage logic
  List<String> images = ['assets/p.png', 'assets/r.png', 'assets/s.png'];
  int palyerOneImageNumber = 0;
  int palyerTwoImageNumber = 0;

  //player turn logic
  int playerOneTurn = 0;
  int playerTwoTurn = 0;

  void showSnackBar({required String message, bool forPlayerOne = true}) {
    double screenHeight = MediaQuery.of(context).size.height; // height of scrn
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.up,
        margin: forPlayerOne
            ? EdgeInsets.only(bottom: screenHeight - 100, left: 20, right: 20)
            : null,
        content: forPlayerOne
            ? RotatedBox(quarterTurns: 2, child: Text(message))
            : Text(message),
      ),
    );
  }

  void changePlayerOneTurn() {
    if (playerOneTurn <= playerTwoTurn) {
      palyerOneImageNumber = Random().nextInt(3);
      playerOneTurn++;
      setState(() {});
    } else {
      showSnackBar(message: "Player two turn!");
    }
  }

  void changePlayerTwoTurn() {
    if (playerTwoTurn <= playerOneTurn) {
      palyerTwoImageNumber = Random().nextInt(3);
      playerTwoTurn++;
      setState(() {});
    } else {
      showSnackBar(message: "Player one turn!", forPlayerOne: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // expanded and spacer concepts

            // Expanded(
            // flex:1, // default value is 1
            //child: Container(color: Colors.blue, height: 100)),
            // Spacer(flex: 1 // default value is 1),
            // Divider(color: Colors.white, thickness: 2, height: 0),
            // Spacer(),
            // Expanded(child: Container(color: Colors.red, height: 100)),
            Expanded(
              // flex: 1;  //default value is 1
              child: GestureDetector(
                onTap: () {
                  changePlayerOneTurn();
                },
                child: RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(images[palyerOneImageNumber]),
                ),
              ),
            ),
            // Spacer(),
            Divider(color: Colors.white, thickness: 2),
            // Spacer(),
            Expanded(
              // flex : 1; //default value is 1
              child: GestureDetector(
                onTap: () {
                  changePlayerTwoTurn();
                },
                child: Image.asset(images[palyerTwoImageNumber]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
