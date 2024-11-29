import 'package:flutter/material.dart';
import 'package:master_plan/theme/theme.dart';

class DialogInputBrak extends StatelessWidget {
  const DialogInputBrak({super.key, required this.indexOper, required this.count});
  final int count;
  final int indexOper;
  @override
  Widget build(BuildContext context) {
    
    final TextEditingController brakController = TextEditingController(text: '$count');
    final TextEditingController commitController = TextEditingController();
    
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
                            ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                    controller: commitController,
                    decoration: const InputDecoration(labelText: 'Комментарий')),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(AppColors.redMaket)),
                      onPressed: () => Navigator.pop(context, '${brakController.text}_${commitController.text}'),
                      child: const Text('Отправить', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                
              ],
            );
}
}