import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_machine_queue.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_text_ready_queue.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand.dart';
import '../../../../widgets/element_bar.dart';
import 'widgets/reorder_widget.dart';
import 'widgets/row_list_four.dart';

class QueuePageMaster extends StatelessWidget {
  const QueuePageMaster({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                  List<ElementBarData> list = [];
                  List<ItemMachineQueue> listMachine = [];

                  for (var machine in state.area!.machineList) {
                    int timeWorking = 0;
                    List<Batch> batchListQueue = [];
                    List<Batch> batchListOther = [];
                    for (var operList in state.operatorOperationsList!) {
                      //проверка на детали в очереди operList.status.id == 5
                      //проверка на детали помимо "в очереди" и готовых (operList.status.id != 5) && (operList.status.id != 2)
                      if ((operList.status.id == 5) &&
                          (operList.machine.id == machine.id)) {
                        batchListQueue.add(operList.batch);
                        timeWorking += operList.timeworking;
                      }
                      if ((operList.status.id != 5) &&
                          (operList.status.id != 2) &&
                          (operList.machine.id == machine.id)) {
                        batchListOther.add(operList.batch);
                        timeWorking += operList.timeworking;
                      }
                    }
                    listMachine.add(ItemMachineQueue(
                        machine: machine,
                        batchListOthers: batchListOther,
                        batchListQueue: batchListQueue,
                        timeWorking: timeWorking));
                  }

                  for (var machineItem in listMachine) {
                    list.add(ElementBarData(
                        header: machineItem.machine.name,
                        content: ContetnQueue(
                            batchListOther: machineItem.batchListOthers,
                            batchListQueue: machineItem.batchListQueue,
                            machine: machineItem.machine,
                            timeWorking: machineItem.timeWorking)));
                  }
                  return ElementBar(list: list);
                }),
              ],
            )),
      ),
    );
  }
}

class ContetnQueue extends StatelessWidget {
  const ContetnQueue({super.key, required this.batchListQueue, required this.batchListOther, required this.machine, required this.timeWorking});
  final List<Batch> batchListQueue;
  final List<Batch> batchListOther;
  final Machine machine;
  final int timeWorking;
  //статус первого списка не null и не ready
  //статус второго списка  null
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text('Время работы станка ${machine.name}: '),
            Text('$timeWorking минут')
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.maxFinite,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/addOperationPage'),
            child: const Text('Добавить операцию'),
          ),
        ),

        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        ListViewOperationsReady(batchListOther),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        //лист с удалением элементов и изменением порядка
        ReorderWidget(batchListQueue, header: const RowListFour(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки')),
      ],
    );
  }
}

class ListViewOperationsReady extends StatelessWidget {
  const ListViewOperationsReady(this.list, {super.key});
  final List<Batch> list;
  @override
  Widget build(BuildContext context) {
    List<ItemTextReadyQueue> listOperations = [];
    for (var batch in list) {
      for (var stage in batch.stageList) {
        for (var operat in stage.operationList) {
          int time = 0;
          for (var transfer in operat.transferList) {
            time += transfer.timepz;
          }
          listOperations.add(ItemTextReadyQueue(detailNumber: batch.number, operationName: operat.name, timeFact: time));
        }
      }
    }
    return (listOperations.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        const RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки'),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          itemCount: listOperations.length,
          itemBuilder: (context, index) => Card(
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RowExpand(
                  text1: '${listOperations[index].detailNumber}',
                  text2: listOperations[index].operationName,
                  text3: '${listOperations[index].timeFact}'),
            ),
          ),
        ),
      ],
    );
  }
}
