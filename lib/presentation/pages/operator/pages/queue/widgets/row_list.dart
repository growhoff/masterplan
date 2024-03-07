import 'package:flutter/material.dart';

class RowList extends StatelessWidget {
  const RowList({super.key, required this.text1, required this.text2, required this.text3});
  final String text1;
  final String text2;
  final String text3;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: Text(text1, textAlign: TextAlign.center)),
            Expanded(child: Text(text2, textAlign: TextAlign.center)),
            Expanded(child: Text(text3, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}