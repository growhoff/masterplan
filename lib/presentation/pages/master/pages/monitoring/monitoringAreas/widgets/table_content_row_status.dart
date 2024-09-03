import 'package:flutter/material.dart';

class TableContentRowStatus extends StatelessWidget {
  const TableContentRowStatus(this.text, this.color, {super.key});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      child: Container(
        margin: const EdgeInsets.all(10),
        color: color,
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
