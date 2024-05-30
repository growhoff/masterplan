import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/widgets/active_item.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'widgets/line_text_spawn.dart';
import 'widgets/row_list.dart';
import 'widgets/table_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key, required this.dataPage});
  final PageItem dataPage;
  
  @override
  Widget build(BuildContext context) {
    int timeMachine = 0;
    for (var element in dataPage.operQueueList) {
      timeMachine += element.timeplan;
    }

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
            final user = state.user!;
            return Column(
            children: [
              const Text('Список деталей'),
              Text('${user.fio} / ${user.position.name}', style: const TextStyle(fontSize: 12)),
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
                  ActiveOperationCard(operJob: dataPage.operActive),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Готовые операции'),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.greenAccent ,list: dataPage.operReadyList, heder: const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',)),
                  const SizedBox(height: 8),
                  const Divider(),
                  const SizedBox(height: 8),
                  const Text('Операции в очереди'),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.amberAccent ,list: dataPage.operQueueList, heder: const RowList(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки',))
                ],
              )
        ),
      ),
    ),
      ),
    );
  }
}

