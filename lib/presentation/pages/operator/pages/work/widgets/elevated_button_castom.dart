import 'package:flutter/material.dart';

class ElevatedButtonCastom extends StatelessWidget {
  const ElevatedButtonCastom({super.key, required this.color, required this.onPressed, required this.text, required this.isActive, required this.icon});
  final String text;
  final VoidCallback? onPressed;
  final Color color; 
  final bool isActive;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(backgroundColor: WidgetStateProperty.all(isActive ? color: Colors.black26), padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 16, horizontal: 5))), 
      onPressed: isActive ? onPressed : null, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon != null ? Icon(icon, color: Colors.black54,) : Container(),
          Text(text, style: const TextStyle(color: Colors.black))
        ],
      ));
  }
}

class ElevatedButtonCastomGradient extends StatelessWidget {
  const ElevatedButtonCastomGradient({super.key, required this.color, required this.onPressed, required this.text, required this.isActive, required this.icon});
  final String text;
  final VoidCallback? onPressed;
  final Color color; 
  final bool isActive;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return
    ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: GestureDetector(
        onTap: isActive ? onPressed : null,
        child: Container(
        padding: const EdgeInsets.all(12),
         decoration: isActive ?
          BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.5, 1],
                colors: [
                    color,
                    Colors.white,
                    color
                ],
                tileMode: TileMode.repeated,
                // transform: GradientRotation(0.1)
            ),
        )
        : const BoxDecoration(color: Colors.black26),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
            icon != null ? Icon(icon, color: Colors.black54,) : Container(),
            Text(text, style: const TextStyle(color: Colors.black))
          ] ),
        ),
      ),
    ); 
  }
}