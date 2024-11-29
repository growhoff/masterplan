import 'package:flutter/material.dart';

class ButtonItem extends StatelessWidget {
  const ButtonItem(this.text, this.onpressed, this.active,{super.key});
  final String text;
  final VoidCallback onpressed;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(12))), onPressed: active ? onpressed : null, child: Text(text, style: TextStyle(color: active ? Colors.black : Colors.black38),));
  }
}