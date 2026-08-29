import 'package:bmi/constants/appColors.dart';
import 'package:bmi/widgets/bmiButton.dart';
import 'package:bmi/widgets/shadowContainer.dart';

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final double bmiResult;
  final Color bmiColor;
  final String bmiRating;
  final String bmiHealthAdvice;
  const ResultPage({
    required this.bmiResult,
    required this.bmiColor,
    required this.bmiRating,
    required this.bmiHealthAdvice,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // print(MediaQuery.of(context).size.width);  // width of the screen
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyActions: true, // for back button
        elevation: 3,
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'BMI Calculator',
            style: TextStyle(fontWeight: FontWeight(700), fontSize: 32),
          ),
        ),

        actions: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.1),
        ], // to center the title
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              SizedBox(width: double.infinity),

              Text(
                "Result",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight(700)),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 6,
                child: ShadowContainer(
                  boxColor: Colors.white,
                  shadowColor: BmiColor.themeColor,
                  containerChild: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(width: double.infinity),
                        Expanded(
                          child: Text(
                            bmiRating,
                            style: TextStyle(
                              color: bmiColor,
                              fontSize: 36,
                              fontWeight: FontWeight(500),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            bmiResult.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight(700),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            bmiHealthAdvice,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight(500),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: BmiButton(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  bmiChild: Text(
                    "Re-Calculate",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight(700),
                      fontSize: 30,
                    ),
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
