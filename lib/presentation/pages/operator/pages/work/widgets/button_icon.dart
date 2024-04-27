import 'package:flutter/material.dart';

class ButtonCircleIcon extends StatelessWidget {
  const ButtonCircleIcon({super.key, required this.onPressed, required this.icon, required this.isActive});
  final bool isActive;
  final VoidCallback? onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration:  ShapeDecoration(
        color: isActive ? Colors.blue : Colors.black26,
        shape: const CircleBorder(),
      ),
      child: IconButton(
        onPressed: isActive ? onPressed : null,
        icon: Icon(icon),
      ),
    );
  }
}
