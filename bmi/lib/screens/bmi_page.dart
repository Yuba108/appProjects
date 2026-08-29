import 'package:bmi/constants/appColors.dart';
import 'package:bmi/controllers/bmi_controller.dart';
import 'package:bmi/screens/resultpage.dart';
import 'package:bmi/widgets/bmiButton.dart';
import 'package:bmi/widgets/roundButton.dart';
import 'package:bmi/widgets/shadowContainer.dart';
import 'package:flutter/material.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';

class BmiPage extends StatefulWidget {
  const BmiPage({super.key});

  @override
  State<BmiPage> createState() => _BmiPageState();
}

class _BmiPageState extends State<BmiPage> {
  int age = 1;
  int height = 30;
  double weight = 4;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        shadowColor: Colors.grey,
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            'BMI Calculator',
            style: TextStyle(fontWeight: FontWeight(700), fontSize: 32),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            12,
          ), // purai column lai padding dinxa tara bhitra ka elements lai haina
          child: Column(
            children: [
              //Age and Gender
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          // Age
                          Expanded(
                            child: ShadowContainer(
                              shadowColor: BmiColor.themeColor,
                              containerChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Age',
                                    style: TextStyle(
                                      fontWeight: FontWeight(600),
                                      fontSize: 24,
                                    ),
                                  ),
                                  Text(
                                    '$age',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight(700),
                                    ),
                                  ),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RoundButton(
                                        ic: Icon(Icons.remove),
                                        onTap: () {
                                          if (age > 1) {
                                            age--;
                                          }
                                          // age>2?age--:age=1;
                                          setState(() {});
                                        },
                                      ),
                                      RoundButton(
                                        ic: Icon(Icons.add),
                                        onTap: () {
                                          if (age < 120) {
                                            age++;
                                          }
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 10,
                          ), // to separete row bhitra ko widgets
                          // Gender
                          Expanded(
                            child: ShadowContainer(
                              shadowColor: BmiColor.themeColor,
                              containerChild: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Gender",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight(700),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.man, size: 45),
                                      Icon(Icons.woman, size: 45),
                                    ],
                                  ),
                                  LiteRollingSwitch(
                                    onTap: () {
                                      // print("Tapped");
                                    },
                                    onDoubleTap: () {
                                      // print("Double Tapped");
                                    },
                                    onSwipe: () {
                                      // print("Swiped");
                                    },
                                    onChanged: (b) {
                                      // print("Value: $b");
                                    },

                                    value: false, //initial value
                                    textOn: "Male",
                                    textOff: "Female",
                                    colorOn: Colors.blue.shade300,
                                    colorOff: Colors.pink.shade400,
                                    iconOff: Icons.check,
                                    iconOn: Icons.check,
                                  ),
                                  SizedBox(height: 2),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              //height
              SizedBox(height: 10),
              Expanded(
                flex: 2,
                child: ShadowContainer(
                  shadowColor: BmiColor.themeColor,
                  containerChild: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Height",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight(700),
                              ),
                            ),
                            SizedBox(width: 5),
                            Text(
                              "cm",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight(700),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: Image.asset("assets/scale.jpeg"),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade300,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: ListWheelScrollView.useDelegate(
                              physics: FixedExtentScrollPhysics(),
                              useMagnifier: true,
                              magnification: 1.3,
                              itemExtent: 50,
                              onSelectedItemChanged: (index) {
                                height = index + 50;
                                // print(height);
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 251,
                                builder: (context, index) {
                                  return RotatedBox(
                                    quarterTurns: 1,
                                    child: Text(
                                      "${index + 50}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight(700),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              // weight
              Expanded(
                flex: 2,
                child: ShadowContainer(
                  shadowColor: BmiColor.themeColor,
                  containerChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Weight",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight(700),
                                color: Colors.black,
                              ),
                            ),
                            WidgetSpan(child: SizedBox(width: 5)),
                            TextSpan(
                              text: "kg",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight(700),
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Text(
                        weight.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight(700),
                        ),
                      ),

                      Slider.adaptive(
                        value: weight, //not initial value
                        min: 1,
                        max: 200,
                        onChanged: (newWeight) {
                          weight = newWeight;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: BmiButton(
                  onTap: () {
                    final BmiController bmic = BmiController(
                      height: height,
                      weight: weight,
                    );

                    double bmiResult = bmic.calculateBmi();
                    Color bmiColor = bmic.getColor();
                    String bmiRating = bmic.getRating();
                    String healthAdvice = bmic.getHealthAdvice();
                    // print(bmic.prnt());

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ResultPage(
                            bmiResult: bmiResult,
                            bmiColor: bmiColor,
                            bmiRating: bmiRating,
                            bmiHealthAdvice: healthAdvice,
                          );
                        },
                      ),
                    );
                  },
                  bmiChild: Text(
                    "Calculate",
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
