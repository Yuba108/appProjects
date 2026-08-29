import 'package:flutter/cupertino.dart';

class CommonText extends StatelessWidget {
  final String text;

  const new({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontWeight: .bold, fontSize: 24));
  }
}
