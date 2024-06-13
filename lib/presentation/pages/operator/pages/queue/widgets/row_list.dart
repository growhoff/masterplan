import 'package:flutter/material.dart';

class RowList extends StatelessWidget {
  const RowList({super.key, required this.text1, required this.text2, required this.text3, required this.text4, required this.mod});
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final bool? mod;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: mod != null ? Colors.amberAccent : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(child: Text(text1, textAlign: TextAlign.center)),
            Expanded(child: Text(text2, textAlign: TextAlign.center)),
            Expanded(child: Text(text3, textAlign: TextAlign.center)),
            Expanded(child: Text(text4, textAlign: TextAlign.center)),
          ],
        ),
      ),
    );
  }
}