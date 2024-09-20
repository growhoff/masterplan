import 'package:flutter/material.dart';

class ElevatedButtonCastom extends StatelessWidget {
  const ElevatedButtonCastom({super.key, required this.color, required this.onPressed, required this.text, required this.isActive, required this.assets});
  final String text;
  final VoidCallback? onPressed;
  final Color color; 
  final bool isActive;
  final String assets;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? onPressed : null,
      child: Card(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(child: Image.asset(assets, height: 70, width: 70, fit: BoxFit.contain)),
            Card(
              color: isActive ? color: Colors.black26,
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(8.0),
                child: Text(text, textAlign: TextAlign.center),
              ),
            )
          ],
        ),
      ),
    );
  }
}