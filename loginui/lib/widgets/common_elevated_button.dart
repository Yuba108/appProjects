import 'package:flutter/material.dart';
import 'package:loginui/widgets/common_text.dart';

class CommonElevatedButton extends StatelessWidget {
  final Color bgclr;
  final String text;
  final Color textcolor;
  final double elevation;
  const CommonElevatedButton({
    super.key,
    required this.bgclr,
    required this.text,
    required this.textcolor,
    required this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: bgclr,
        elevation: elevation,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      child: CommonText(
        text: text,
        textcolor: textcolor,
        fontWeight: .bold,
        fontsize: 20,
        textalign: .center,
      ),
    );
  }
}
