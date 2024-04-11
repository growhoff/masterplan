import 'package:flutter/material.dart';

class ButtonCircleIcon extends StatelessWidget {
  const ButtonCircleIcon(
      {super.key, required this.onPressed, required this.icon});
  final VoidCallback? onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: const ShapeDecoration(
        color: Colors.blue,
        shape: CircleBorder(),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}
