import 'package:exptracker/common/commoncolors.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  final TextInputType? type;

  const CommonTextField({
    super.key,
    required this.hinttext,
    required this.controller,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type ?? .text,
      controller: controller,
      cursorColor: Commoncolors.primaryColor,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Commoncolors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(color: Commoncolors.commonBlue, width: 2),
        ),
        hintText: hinttext,
        hintStyle: TextStyle(
          color: Commoncolors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
