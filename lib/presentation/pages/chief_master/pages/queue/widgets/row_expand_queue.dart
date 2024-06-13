import 'package:flutter/material.dart';

class RowExpandQueue extends StatelessWidget {
  const RowExpandQueue({super.key, required this.text1, required this.text2, required this.text3});
  final String text1;
  final String text2;
  final String text3;
  @override
  Widget build(BuildContext context) {
    return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 2, child: Text(text1, textAlign: TextAlign.start)),
                Expanded(flex: 2, child: Text(text2, textAlign: TextAlign.center)),
                Expanded(flex: 2, child: Text(text3, textAlign: TextAlign.center)),
              ],
            );
  }
}