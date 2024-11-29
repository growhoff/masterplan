import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriorityCircle extends StatelessWidget {
  const PriorityCircle(this.priority, {this.size = 12, super.key});

  final int priority;
  final int size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: size.toDouble(),
          height: size.toDouble(),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: priorityToColor(priority),
          ),
          child: Center(
            child: Text(
              '$priority',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          )),
    );
  }
}

Color priorityToColor(int priority) {
  switch (priority) {
    case 1:
      return Colors.red;
    case 2:
      return Colors.yellow;
    case 3:
      return Colors.green;
    case 4:
      return Colors.grey;
    default:
      return Colors.grey;
  }
}
