import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/machine.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_oper.dart';
import '../bloc/cubit.dart';
import 'reorder_widget.dart';

class ContetnQueue extends StatelessWidget {
  const ContetnQueue({super.key, required this.batchListQueue, required this.machine, required this.timeWorking});
  final List<ItemOper> batchListQueue;
  final Machine machine;
  final int timeWorking;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Время работы станка: $timeWorking минут', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/addOperationPage'),
                  child: const Text('Добавить операцию', textAlign: TextAlign.center),
                ),
              ),
              const Spacer(),
              Expanded(
                flex: 6,
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
                  ),
                  onPressed: () => context.read<CubitQueueMaster>().saveDate(),
                  child: const Text('Сохранить изменения', textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        Reorder(batchListQueue)
      ],
    );
  }
}