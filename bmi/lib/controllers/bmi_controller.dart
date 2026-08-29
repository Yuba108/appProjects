import 'dart:math';

import 'package:flutter/material.dart';

class BmiController {
  final int height;
  final double weight;
  BmiController({required this.height, required this.weight});

  double bmi = 0;

  // prnt() {
  //   print("Height: $height cm, Weight: $weight kg");
  // }

  double calculateBmi() {
    bmi = weight / pow((height / 100), 2);
    return bmi;
  }

  String getRating() {
    return bmi < 18.5
        ? "Underweight"
        : bmi < 25
        ? "Normal"
        : "Overweight";
  }

  Color getColor() {
    return bmi < 18.5
        ? Colors.red
        : bmi < 25
        ? Colors.green
        : Colors.red;
  }

  String getHealthAdvice() {
    return bmi < 18.5
        ? "You are underweight! Consider eating more nutritious food."
        : bmi < 25
        ? "You are healthy! Keep it up."
        : "You are overweight! Consider a balanced diet and regular exercise.";
  }
}
