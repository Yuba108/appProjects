import 'package:exptracker/common/commoncolors.dart';
import 'package:flutter/material.dart';

class Expensetextfield extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  final TextInputType? inputType;

  const Expensetextfield({
    super.key,
    required this.hinttext,
    required this.controller,
    this.inputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType ?? TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        hintText: hinttext,
        fillColor: Commoncolors.commonWhite,
        filled: true,
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Commoncolors.primaryColor),
        ),
      ),
    );
  }
}
