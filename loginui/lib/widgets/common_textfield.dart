import 'package:flutter/material.dart';

class CommonTextfield extends StatelessWidget {
  final String hinttext;
  final String labeltext;
  final String helpertext;
  final bool obscuretext;
  const CommonTextfield({
    super.key,
    required this.hinttext,
    required this.labeltext,
    required this.obscuretext,
    required this.helpertext,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscuretext,

      decoration: InputDecoration(
        fillColor: Colors.orangeAccent,

        hintText: hinttext,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
          gapPadding: 10,
          borderRadius: BorderRadius.circular(20),
        ),
        labelText: labeltext,
        helperText: helpertext,
      ),
    );
  }
}
