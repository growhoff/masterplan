import 'package:flutter/material.dart';

class ElevatedButtonCastom extends StatelessWidget {
  const ElevatedButtonCastom({super.key, required this.color, required this.onPressed, required this.text});
  final String text;
  final VoidCallback? onPressed;
  final Color color; 
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(color)), 
      onPressed: onPressed, 
      child: Text(text));
  }
}