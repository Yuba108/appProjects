import 'package:asm_notes/common/common_colors.dart';
import 'package:flutter/material.dart';

class CommoTextField extends StatelessWidget {
  final String hint;
  final int? minLines;
  final int? maxLines;
  TextEditingController controller;
  new({
    super.key,
    required this.hint,
    required this.controller,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      minLines: minLines ?? 1,
      maxLines: maxLines ?? 1,
      decoration: InputDecoration(
        hintText: hint,
        enabled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CommonColors.primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: CommonColors.primaryColor, width: 2),
        ),
      ),
    );
  }
}
