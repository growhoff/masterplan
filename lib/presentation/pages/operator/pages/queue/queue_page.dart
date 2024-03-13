import 'package:flutter/material.dart';
import 'model/operation.dart';
import 'widgets/line_text_spawn.dart';
import 'widgets/row_list.dart';
import 'widgets/table_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentQueue();
  }
}

class ContentQueue extends StatelessWidget {
  const ContentQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) => Column(
            children: [
              const Text('Очередь'),
              Text('${state.user!.id} / ${state.user!.fio} / ${state.user!.position} / ${state.user!.region}', style: const TextStyle(fontSize: 12)),
            ])),
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:  BlocBuilder<CubitMain, StateMain>(
            builder:(context, state) {
              List<Operation> listNotWork = [];
              List<Operation> listWork = [];
              for (var e in state.listoperatorOperations!) {
                if (e.status == 'not_work') {listNotWork.add(Operation(plan: e.details, operation: '${e.stageOperationId}', time: '${e.time ~/ 60} мин'));}
                else {listWork.add(Operation(plan: e.details, operation: '${e.stageOperationId}', time: '${e.time ~/ 60} мин'));}
              }
              return Column(
                children: [
                  LineTextSpawn(title: 'Загрузка станка', text: state.listEquipment![0].name),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.amber ,list: listWork, heder: const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',)),
                  const SizedBox(height: 8),
                  TableCard(color: Colors.black12 ,list: listNotWork, heder: const RowList(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки',))
                ],
              ); 
            },
          )
        ),
      ),
    ),
      ),
    );
  }
}