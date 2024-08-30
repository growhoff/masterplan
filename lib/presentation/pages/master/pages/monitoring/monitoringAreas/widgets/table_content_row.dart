import 'package:flutter/material.dart';

class TableContentRow extends StatelessWidget {
  const TableContentRow(this.text,{super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
