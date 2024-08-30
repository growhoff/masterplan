import 'package:flutter/material.dart';

class TableContentRowStatus extends StatelessWidget {
  const TableContentRowStatus(this.text, this.color, {super.key});
  final String text;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      child: Container(
        margin: EdgeInsets.all(10),
        color: color,
        // padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Text(
          text,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
