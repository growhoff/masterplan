import 'package:flutter/material.dart';

class TableContentRow extends StatelessWidget {
  const TableContentRow(this.text, this.index, this.indexActive,{super.key});
  final String text;
  final int indexActive;
  final int index;
  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      child: Container(
        color: index == indexActive ? Colors.amberAccent : index > indexActive ? Colors.white : Colors.green,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
