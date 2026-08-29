import 'package:bmi/constants/appColors.dart';
import 'package:flutter/material.dart';

class BmiButton extends StatelessWidget {
  final void Function() onTap;
  final Widget bmiChild;
  const BmiButton({required this.onTap, required this.bmiChild, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: BmiColor.themeColor,
      splashColor: BmiColor.themeColor,
      onPressed: onTap,
      minWidth: double.infinity,
      color: BmiColor.themeColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: bmiChild,
    );
  }
}
