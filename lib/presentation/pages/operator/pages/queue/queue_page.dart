import 'package:flutter/material.dart';
import 'model/operation.dart';
import 'widgets/line_text_spawn.dart';
import 'widgets/row_list.dart';
import 'widgets/table_card.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

List<Operation> list1 = [
  Operation(plan: '1', operation: 'operation 1', time: '10'),
  Operation(plan: '2', operation: 'operation 2', time: '20'),
  Operation(plan: '3', operation: 'operation 3', time: '30')
];

List<Operation> list2 = [
  Operation(plan: '45', operation: 'operation 44', time: '15'),
  Operation(plan: '87', operation: 'operation 78', time: '60'),
  Operation(plan: '67', operation: 'operation 46', time: '45'),
  Operation(plan: '7', operation: 'operation 70', time: '60'),
];

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
          title: const Text('Очередь'),
          // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const LineTextSpawn(title: 'Загрузка станка', text: '213'),
              const SizedBox(height: 8),
              TableCard(color: Colors.amber ,list: list1, heder: const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',)),
              const SizedBox(height: 8),
              TableCard(color: Colors.black12 ,list: list2, heder: const RowList(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки',))
            ],
          )
        ),
      ),
    ),
      ),
    );
  }
}