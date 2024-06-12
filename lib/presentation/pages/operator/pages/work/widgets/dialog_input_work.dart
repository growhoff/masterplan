import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:provider/provider.dart';

class DialogInputWork extends StatelessWidget {
  const DialogInputWork({super.key, required this.indexOper, required this.count});
  final int count;
  final int indexOper;
  @override
  Widget build(BuildContext context) {
    
    final TextEditingController brakController = TextEditingController();
    final FocusNode brakFocusNode = FocusNode();

    // final TextEditingController commitController = TextEditingController();
    // final FocusNode commitFocusNode = FocusNode();
    
    return AlertDialog(
                title: const Text('Передача операций на брак'),
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
                   context.read<CubitWork>().toggleBrak(brakController.text);
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