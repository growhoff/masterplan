import 'package:flutter/material.dart';

class DialogPay extends StatelessWidget {
  const DialogPay({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
              title: const Text('Приложение не оплачено'),
              contentPadding: const EdgeInsets.all(5),
              actions: [
                MaterialButton(
                    child: const Text('ОК',style: TextStyle(fontSize: 18)),
                    onPressed: () =>
                        Navigator.pop(context, false))
              ],
            );
}
}