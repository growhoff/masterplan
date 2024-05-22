import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

class DialogVersion extends StatelessWidget {
  const DialogVersion({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Ошибка версий'),
                content: const Text('На данный момент есть более актуальная версия'),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 10,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () => context.read<CubitMain>().goToLink(),
                  child: const Text('СКАЧАТЬ'),
                ),
                ElevatedButton(
                  onPressed: () {Navigator.pop(context);},
                  child: const Text('ОТМЕНА'),
                ),
              ],
            );
}
}