import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ошибка'),
      content: const Text('Неверный номер или пароль'),
      actions: [
        TextButton(
          onPressed: (){}, 
          // Navigator.pop(alertDialogContext),
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
