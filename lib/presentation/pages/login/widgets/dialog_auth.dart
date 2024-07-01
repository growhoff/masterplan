import 'package:flutter/material.dart';

class DialogAuth extends StatelessWidget {
  const DialogAuth(this.isError, {super.key});
  final int isError;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Ошибка авторизации'),
                content: Text(isError == 1 ? 'Не найден пользователь. Обратитесь к администратору.' : 'Неверный логин или пароль'),
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