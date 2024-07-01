import 'package:flutter/material.dart';

class DialogChange extends StatelessWidget {
  const DialogChange({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Информация'),
                content: const Text('Пользователь не распределен на смену'),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () {Navigator.pop(context);},
                  child: const Text('ЗАКРЫТЬ'),
                ),
              ],
            );
}
}