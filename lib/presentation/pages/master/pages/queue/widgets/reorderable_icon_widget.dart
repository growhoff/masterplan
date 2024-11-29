import 'package:flutter/material.dart';

class ReorderableIconWidget extends StatelessWidget {
  const ReorderableIconWidget(this.index, this.isGroup, {super.key});
  final int index;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: Icon(Icons.reorder, color: isGroup ? Colors.blue : Colors.black),
    );
  }
}