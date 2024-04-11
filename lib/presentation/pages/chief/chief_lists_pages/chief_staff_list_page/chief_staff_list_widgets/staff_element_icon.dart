
import 'package:flutter/material.dart';

class StaffElementIcon extends StatelessWidget {
  const StaffElementIcon({required this.position, super.key});

  final String position;

  @override
  Widget build(BuildContext context) {
    switch (position) {
      case 'Начальник':
        return const Icon(Icons.hail_rounded);
      case 'Мастер':
        return const Icon(Icons.man);
      default:
        return const Icon(Icons.emoji_people_rounded);
    }
  }
}
