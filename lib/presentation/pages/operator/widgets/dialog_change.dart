import 'package:flutter/material.dart';
import 'package:master_plan/theme/theme.dart';

class DialogChange extends StatelessWidget {
  const DialogChange({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Завершить?'),
                // content: const Text('Пользователь не распределен на смену'),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.greenMaket)),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Да', style: TextStyle(color: Colors.black)),
                ),
                ElevatedButton(
                  style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.redMaket)),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Нет', style: TextStyle(color: Colors.black)),
                ),
              ],
            );
}
}