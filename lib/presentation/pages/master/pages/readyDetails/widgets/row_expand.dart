import 'package:flutter/material.dart';

class RowExpand extends StatelessWidget {
  const RowExpand({super.key, required this.text1, required this.text2, required this.text3, required this.text4});
  final String text1;
  final String text2;
  final String text3;
  final String text4;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(flex: 4, child: Text(text1, textAlign: TextAlign.start)),
                  Expanded(flex: 4, child: Text(text2, textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text(text3, textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text(text4, textAlign: TextAlign.center)),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
    );
  }
}