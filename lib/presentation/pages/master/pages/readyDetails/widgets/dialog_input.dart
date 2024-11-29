import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
import 'package:provider/provider.dart';

class DialogInput extends StatelessWidget {
  const DialogInput({super.key, required this.oper, required this.count, required this.status});
  final int count;
  final ItemOperReady oper;
  final bool status;
  @override
  Widget build(BuildContext context) {
    
    final TextEditingController brakController = TextEditingController();
    final FocusNode brakFocusNode = FocusNode();

    final TextEditingController commitController = TextEditingController();
    final FocusNode commitFocusNode = FocusNode();
    
    return AlertDialog(
                title: Text('Передача операций на ${status ? 'брак' : 'доработку'}'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Введите количество операций. Максимум: $count'),
                    const SizedBox(height: 8),
                    TextFormField(
                    controller: brakController,
                    focusNode: brakFocusNode,
                    decoration: const InputDecoration(labelText: 'Количество')),
                const SizedBox(height: 8),
                TextFormField(
                    controller: commitController,
                    focusNode: commitFocusNode,
                    decoration: const InputDecoration(labelText: 'Комментарий')),
                
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
                    status ? context.read<CubitReadyDetails>().toggleBrak(oper, brakController.text, commitController.text) : context.read<CubitReadyDetails>().toggleModific(oper, brakController.text, commitController.text);
                    Navigator.pop(context);
                  },
                  child: const Text('СОХРАНИТЬ'),
                ),
                ElevatedButton(
                  onPressed: () {Navigator.pop(context);},
                  child: const Text('ЗАКРЫТЬ'),
                ),
              ],
            );
}
}