import 'package:exptracker/common/commoncolors.dart';
import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final String hinttext;
  final TextEditingController controller;
  final TextInputType? type;
  final bool obscureText;
  final IconData? prefixIcon;

  const CommonTextField({
    super.key,
    required this.hinttext,
    required this.controller,
    this.type,
    this.obscureText = false,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type ?? TextInputType.text,
      controller: controller,
      obscureText: obscureText,
      textCapitalization:
          obscureText || type == TextInputType.emailAddress
              ? TextCapitalization.none
              : TextCapitalization.sentences,
      cursorColor: Commoncolors.primaryColor,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: hinttext,
        prefixIcon: prefixIcon == null ? null : Icon(prefixIcon),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Commoncolors.commonRed, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Commoncolors.commonRed, width: 2),
        ),
        suffixIcon: obscureText ? const Icon(Icons.lock_outline) : null,
      ),
    );
  }
}
