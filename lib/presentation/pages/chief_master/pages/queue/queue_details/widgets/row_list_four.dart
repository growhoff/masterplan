import 'package:flutter/material.dart';

class RowListFour extends StatelessWidget {
  const RowListFour({super.key, required this.text0, required this.text1, required this.text2, required this.text3, required this.text4, required this.text5});
  final String text0;
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  final String text5;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Expanded(flex: 2, child: Text(text0, textAlign: TextAlign.center)),
        Expanded(flex: 4, child: Text(text1, textAlign: TextAlign.center)),
        Expanded(flex: 4, child: Text(text2, textAlign: TextAlign.center)),
        Expanded(flex: 3, child: Text(text3, textAlign: TextAlign.center)),
        Expanded(flex: 2, child: Text(text4, textAlign: TextAlign.center)),
        Expanded(flex: 2, child: Text(text5, textAlign: TextAlign.center)),
        const Spacer(),
        const Spacer(),
        const Spacer()
      ],
    );
  }
}