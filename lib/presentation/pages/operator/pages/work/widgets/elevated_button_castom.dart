import 'package:flutter/material.dart';

class ElevatedButtonCastom extends StatelessWidget {
  const ElevatedButtonCastom({super.key, required this.color, required this.onPressed, required this.text, required this.isActive});
  final String text;
  final VoidCallback? onPressed;
  final Color color; 
  final bool isActive;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(isActive ? color: Colors.black26), padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 5))), 
      onPressed: isActive ? onPressed : null, 
      child: Text(text, style: const TextStyle(color: Colors.black),));
  }
}