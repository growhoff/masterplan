import 'package:flutter/material.dart';

class LineTextSpawn extends StatelessWidget {
  const LineTextSpawn({super.key, required this.title, required this.text});
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: [TextSpan(text: '$title: '), TextSpan(text: text)]));
  }
}