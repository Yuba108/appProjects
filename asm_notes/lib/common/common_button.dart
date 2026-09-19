import 'package:asm_notes/common/common_colors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  VoidCallback onTap;
  new({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: CommonColors.primaryColor,
        foregroundColor: CommonColors.whiteColor,
      ),
      child: Text(text),
    );
  }
}
