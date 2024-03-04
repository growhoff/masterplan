import 'package:flutter/material.dart';

class RowExpand extends StatelessWidget {
  const RowExpand({super.key, required this.text1, required this.text2, required this.text3});
  final String text1;
  final String text2;
  final String text3;
  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(text1, textAlign: TextAlign.start)),
                Expanded(child: Text(text2, textAlign: TextAlign.center)),
                Expanded(child: Text(text3, textAlign: TextAlign.end))
              ],
            );
  }
}