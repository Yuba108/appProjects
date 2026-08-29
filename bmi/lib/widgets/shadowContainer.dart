import 'package:flutter/material.dart';

class ShadowContainer extends StatelessWidget {
  final Color shadowColor;
  final Widget? containerChild;
  final Color? boxColor;

  const ShadowContainer({
    required this.shadowColor,
    this.boxColor,
    this.containerChild,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 150,
      decoration: BoxDecoration(
        color: boxColor ?? Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [
          BoxShadow(color: shadowColor, blurRadius: 5, offset: Offset(3, 3)),
          // BoxShadow(
          //   color: Colors.black,
          //   blurRadius: 12,
          //   offset: Offset(-5, -5),
          // ),
        ],
      ),
      child: containerChild,
    );
  }
}
