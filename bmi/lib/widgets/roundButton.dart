import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final Icon ic;
  final void Function() onTap;
  const RoundButton({required this.ic, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: 3,
      shape: CircleBorder(),
      minWidth: 0,
      color: Colors.white,
      child: ic,
    );
  }
}
