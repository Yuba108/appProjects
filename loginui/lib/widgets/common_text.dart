import 'package:flutter/material.dart';

class CommonText extends StatelessWidget {
  final String text;
  final Color textcolor;
  final double fontsize;
  final FontWeight fontWeight;
  final TextAlign textalign;
  const CommonText({
    super.key,
    required this.text,
    required this.textcolor,
    required this.fontWeight,
    required this.fontsize,
    required this.textalign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textalign,
      style: TextStyle(
        color: textcolor,
        fontSize: fontsize,
        fontWeight: fontWeight,
      ),
    );
  }
}
