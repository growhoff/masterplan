import 'package:flutter/material.dart';

class ButtonIconItem extends StatelessWidget {
  const ButtonIconItem({super.key, required this.onPressed, required this.icon, required this.isActive});
  final bool isActive;
  final VoidCallback? onPressed;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
          onTap: isActive ? onPressed : null,
          child: Icon(icon, color: isActive ? const Color.fromARGB(255, 49, 49, 49) : const Color.fromARGB(255, 218, 218, 218))),
    );
  }
}
