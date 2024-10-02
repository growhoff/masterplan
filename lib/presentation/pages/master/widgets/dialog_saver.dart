import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

class DialogSaver extends StatelessWidget {
  const DialogSaver({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Инфо'),
                content: const Text('Сохранить порядок очереди?'),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 10,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () { 
                    context.read<CubitMain>().toggleSaverQuere(false); 
                    Navigator.pop(context, true);
                },
                  child: const Text('Сохранить'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Отменить'),
                ),
              ],
            );
}
}