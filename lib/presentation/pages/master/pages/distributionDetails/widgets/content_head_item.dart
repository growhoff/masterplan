import 'package:flutter/material.dart';

class ContentHeadItem extends StatelessWidget {
  const ContentHeadItem(this.text, {this.color ,super.key});
  final Color? color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white70,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ContentHeadItemRotait extends StatelessWidget {
  const ContentHeadItemRotait(this.text, {this.color ,super.key});
  final Color? color;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: RotatedBox(
            quarterTurns: 3,
            child: Text(
              text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}