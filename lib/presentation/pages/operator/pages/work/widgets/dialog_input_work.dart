import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
// import 'package:provider/provider.dart';

class DialogInputWork extends StatelessWidget {
  const DialogInputWork({super.key, required this.indexOper, required this.count});
  final int count;
  final int indexOper;
  @override
  Widget build(BuildContext context) {
    
    final TextEditingController brakController = TextEditingController(text: '$count');
    // final FocusNode brakFocusNode = FocusNode();

    final TextEditingController commitController = TextEditingController();
    // final FocusNode commitFocusNode = FocusNode();
    
    return AlertDialog(
                title: const Text('Брак. Отправить мастеру?'),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(),
                    Text('Передать максимум: $count'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(flex: 2, child: Text('Количество')),
                        Expanded(
                          child: TextFormField(
                            controller: brakController,
                            // focusNode: brakFocusNode,
                            // decoration: const InputDecoration(labelText: 'Количество')
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                    controller: commitController,
                    // focusNode: commitController,
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
                  //  context.read<CubitWork>().toggleBrak(brakController.text);
                   Navigator.pop(context, '${brakController.text ?? 0}_${commitController.text ?? ''}');
                  },
                  child: const Text('Отправить'),
                ),
                // ElevatedButton(
                //   onPressed: () {Navigator.pop(context);},
                //   child: const Text('ЗАКРЫТЬ'),
                // ),
              ],
            );
}
}