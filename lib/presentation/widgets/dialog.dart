import 'package:flutter/material.dart';

class Dialog extends StatelessWidget {
  const Dialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ошибка'),
      content: Text('Неверный номер или пароль'),
      actions: [
        TextButton(
          onPressed: (){}, 
          // Navigator.pop(alertDialogContext),
          child: Text('Ok'),
        ),
      ],
    );
  }
}
