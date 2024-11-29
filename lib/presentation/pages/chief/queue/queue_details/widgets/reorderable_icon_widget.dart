import 'package:flutter/material.dart';

class ReorderableIconWidget extends StatelessWidget {
  const ReorderableIconWidget(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    return ReorderableDragStartListener(
      index: index,
      child: const Icon(Icons.reorder),
    );
  }
}