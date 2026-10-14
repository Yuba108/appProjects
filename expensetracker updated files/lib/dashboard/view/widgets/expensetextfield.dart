import 'package:exptracker/common/commoncolors.dart';
import 'package:flutter/material.dart';

class Expensetextfield extends StatelessWidget {
  final String? hinttext;
  final String? labeltext;
  final TextEditingController controller;
  final TextInputType? inputType;
  final IconData? prefixIcon;

  const Expensetextfield({
    super.key,
    this.hinttext,
    required this.controller,
    this.inputType,
    this.prefixIcon,
    this.labeltext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: inputType ?? TextInputType.text,
      controller: controller,
      cursorColor: Commoncolors.primaryColor,
      textCapitalization: inputType == TextInputType.number
          ? TextCapitalization.none
          : TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: labeltext,
        hintText: hinttext,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
      ),
    );
  }
}
