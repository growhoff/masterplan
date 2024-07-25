import 'package:flutter/material.dart';

class DialogInputComment extends StatelessWidget {
  const DialogInputComment({super.key});
  @override
  Widget build(BuildContext context) {
    
    final TextEditingController commitController = TextEditingController();
    
    return AlertDialog(
                title: const Text('Сохранение статуса'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Введите комментарий'),
                    const SizedBox(height: 8),
                    TextFormField(
                    controller: commitController,
                    decoration: const InputDecoration(labelText: 'Комментарий')),
                const SizedBox(height: 8),                
                  ],
                ),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () {
                    String text = commitController.text;
                    if (text == '') text = '-';
                   Navigator.pop(context, text);
                  },
                  child: const Text('СОХРАНИТЬ'),
                ),
                ElevatedButton(
                  onPressed: () {Navigator.pop(context, '');},
                  child: const Text('ЗАКРЫТЬ'),
                ),
              ],
            );
}
}