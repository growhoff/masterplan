import 'package:flutter/material.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/widgets/reorder_widget.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'widgets/row_list.dart';
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
      for (var e in element.list) {
        timeMachine += e.timeplan;
      }
    }

    return BlocProvider<CubitEqueueOperator>(
      create: (context) => CubitEqueueOperator(),
      child: GestureDetector(
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
          body: Scrollbar(
            thickness: 10,
            thumbVisibility: true,
            radius: const Radius.circular(10),
            child: ListView(
              children: [SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child:  Column(
                            children: [
                              Text('Загрузка станка ${TimeConverter().convertTimeMinHMin(timeMachine)}'),
                              const SizedBox(height: 8),
                              const RowList(mod: null, text1: 'Деталь', text2: 'Операция', text3: 'пр. № детали', text4: 'T факт, мин', text5: '№ опт. парт.', color: Colors.white),
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text('Обрабатывается', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              const Divider(),
                              dataPage.operActive == null
                              ? const Text('Нет активных')
                              : RowList(
                                color: Colors.blueAccent,
                                mod: dataPage.operActive!.list.first.modific,
                                text1: dataPage.operActive != null ? '${dataPage.operActive!.list.first.batch.numberRS} ${dataPage.operActive!.list.first.batch.name}' : 'none',
                                text2: dataPage.operActive != null ? '${dataPage.operActive!.list.first.operation.number} ${dataPage.operActive!.list.first.operation.name}' : 'none',
                                text3: '${dataPage.operActive!.idPath}',
                                text4: '-',
                                // text3: dataPage.operActive != null ? '${dataPage.operActive!.list.first.timeplan}' : 'none',
                                text5: dataPage.operActive != null ? '${dataPage.operActive!.list.length}' : 'none',
                              ),
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text('В очереди', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              const Divider(),
                              ReorderQuereOper(dataPage.operQueueList),
                               
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text('Готово', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              const Divider(),
                              dataPage.operReadyList.isEmpty 
                                ? const Text('Список пуст')
                                : Column(
                                  children: dataPage.operReadyList.map((item) => RowList(
                                      color: Colors.greenAccent,
                                      mod:  item.list.first.modific,
                                      text1: '${item.list.first.batch.numberRS} ${ item.list.first.batch.name}',
                                      text2: '${item.list.first.operation.number} ${ item.list.first.operation.name}',
                                      text3: '${item.idPath}',
                                      text4: TimeConverter().convertTimeFromSecondsToMin(item.list.first.timeworking ?? 0),
                                      text5: '${ item.list.length}',
                                      )).toList(),
                                ),
                              const Divider(),
                              const SizedBox(height: 8),
                              const Text('Отбраковано', style: TextStyle(fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              const Divider(),
                              dataPage.operBrakList.isEmpty 
                                ? const Text('Список пуст')
                                : Column(
                                  children: dataPage.operBrakList.map((item) => RowList(
                                      color: Colors.redAccent,
                                      mod:  item.list.first.modific,
                                      text1: '${item.list.first.batch.numberRS} ${ item.list.first.batch.name}',
                                      text2: '${item.list.first.operation.number} ${ item.list.first.operation.name}',
                                      text3: '${item.idPath}',
                                      text4: TimeConverter().convertTimeFromSecondsToMin(item.list.first.timeworking ?? 0),
                                      text5: '${ item.list.length}',
                                      )).toList(),
                                ),
                              ],
                          )
                    ),
                  )],
            ),
          ),
        ),
      ),
    );
  }
}

