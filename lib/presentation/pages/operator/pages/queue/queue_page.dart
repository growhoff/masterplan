import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'widgets/line_text_spawn.dart';
import 'widgets/row_list.dart';
import 'widgets/table_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key, required this.operListReady, required this.operListQueue});
  final List<OperatorOperations> operListReady;
  final List<OperatorOperations> operListQueue;
  @override
  Widget build(BuildContext context) {
    OperatorOperations? operJob;
    //удаление первого элемента
    if (operListQueue.isNotEmpty) {
      operJob = operListQueue.first;
      operListQueue.removeAt(0);
      }

    int timeMachine = 0;
    for (var element in operListQueue) {
      timeMachine += element.timeplan;
    }

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
            final user = state.user!;
            return Column(
            children: [
              const Text('Оператор'),
              Text('${user.id} / ${user.fio} / ${user.position.name}', style: const TextStyle(fontSize: 12)),// ${user.area!.name}
            ]);
          }),
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:  Column(
                children: [
                  LineTextSpawn(title: 'Загрузка станка', text: '$timeMachine'),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Операция в работе'),
                  ActiveOperationCard(operJob: operJob),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Готовые операции'),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.greenAccent ,list: operListReady, heder: const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',)),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Операции в очереди'),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.amberAccent ,list: operListQueue, heder: const RowList(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки',))
                ],
              )
        ),
      ),
    ),
      ),
    );
  }
}

class ActiveOperationCard extends StatelessWidget {
  const ActiveOperationCard({super.key, required this.operJob});
  final OperatorOperations? operJob;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: Column(
        children: [
          const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',),
          const SizedBox(height: 8),
          RowList(text1: operJob != null ? operJob!.batch.name : 'none', text2: operJob != null ? operJob!.operation.name : 'none', text3: '${operJob != null ? operJob!.timeplan : 'none'}',),
        ],
      ),
    );
  }
}