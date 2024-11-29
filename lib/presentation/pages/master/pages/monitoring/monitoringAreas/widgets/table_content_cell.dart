import 'package:flutter/material.dart';

class TableContentCell extends StatelessWidget {
  const TableContentCell(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Text(
            text,
            softWrap: true,
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ));
  }
}
