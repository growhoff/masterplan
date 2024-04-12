import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/model/item_operation.dart';
import 'widgets/line_text_spawn.dart';
import 'widgets/row_list.dart';
import 'widgets/table_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class QueuePage extends StatelessWidget {
  const QueuePage(this.operList, {super.key});
  final List<ZOperatorOperations> operList;
  @override
  Widget build(BuildContext context) {

    List<ItemOperation> listNotWork = [];
    List<ItemOperation> listWork = [];

    for (var batch in operList) {
      for (var stage in batch.batch.stageList) {
        for (var operat in stage.operationList) {
          int time = 0;
          for (var transfer in operat.transferList) {
            time += transfer.timepz;
          }
          //в работе
          if (batch.status.id == 1) listWork.add(ItemOperation(detailNumber: batch.batch.number, operationName: operat.name, timeFact: time));
          //не в работе
          if (batch.status.id == 5) listNotWork.add(ItemOperation(detailNumber: batch.batch.number, operationName: operat.name, timeFact: time));
        }
      }
    }
    int timeMachine = 0;
    for (var element in listWork) {
      timeMachine += element.timeFact;
    }
    for (var element in listNotWork) {
      timeMachine += element.timeFact;
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
                  TableCard(color: Colors.amber ,list: listWork, heder: const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',)),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.black12 ,list: listNotWork, heder: const RowList(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки',))
                ],
              )
        ),
      ),
    ),
      ),
    );
  }
}