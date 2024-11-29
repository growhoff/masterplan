import 'package:flutter/material.dart';

class DialogButtonGroup extends StatelessWidget {
  const DialogButtonGroup({super.key});
  @override
  Widget build(BuildContext context) {   
    return AlertDialog(
                title: const Text('Выбор группировки'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(onPressed: ()=> Navigator.pop(context, 1), child: const Text('Группировка по номеру детали')),
                    const SizedBox(height: 8),
                    ElevatedButton(onPressed: ()=> Navigator.pop(context, 2), child: const Text('Группировка по номеру этапа')),            
                  ],
                ),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () {Navigator.pop(context, 0);},
                  child: const Text('ЗАКРЫТЬ'),
                ),
              ],
            );
}
}