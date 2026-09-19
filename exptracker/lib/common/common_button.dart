import 'package:exptracker/common/commoncolors.dart';
import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CommonButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: Commoncolors.primaryColor,
          foregroundColor: Commoncolors.commonWhite,
        ),
        onPressed: onTap,
        child: Text(text),
      ),
    );
  }
}
