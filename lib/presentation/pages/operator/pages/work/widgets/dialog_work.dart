import 'package:flutter/material.dart';

class DialogWork extends StatelessWidget {
  const DialogWork({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Данный функционал в разработке!'),
                // content: const Text('Введите комментарий'),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ЗАКРЫТЬ'),
                ),
              ],
            );
}
}