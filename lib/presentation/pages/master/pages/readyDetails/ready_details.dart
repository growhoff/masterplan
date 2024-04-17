import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_text_ready.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand_content.dart';
import '../../../../widgets/element_bar.dart';

class ReadyDetailsPage extends StatelessWidget {
  const ReadyDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                List<ElementBarData> list = [];
                List<ItemMachine> listMachine = [];

                for (var machine in state.area!.machineList) {
                  int idOper = 0;
                  int timeWorking = 0;
                  List<Batch> batchList = [];
                  for (var operList in state.operatorOperationsList!) {
                    //проверка на готовые детали
                    if ((operList.status.id == 2) && (operList.machine.id == machine.id)) {
                      batchList.add(operList.batch);
                      timeWorking += operList.timeworking;
                      idOper = operList.id;
                    }
                  }
                  listMachine.add(ItemMachine(machine: machine, batchList: batchList, timeWorking: timeWorking, id: idOper));
                }

                for (var machineItem in listMachine) {
                  list.add(ElementBarData(header: machineItem.machine.name, content: ContetnReady(idOper: machineItem.id, batchList: machineItem.batchList, machine: machineItem.machine, timeWorking: machineItem.timeWorking)));
                }
                return ElementBar(list: list);
              }),
            ],
          )
        ),
      ),
    );
  }
}

class ContetnReady extends StatelessWidget {
  const ContetnReady({super.key, required this.batchList, required this.machine, required this.timeWorking, required this.idOper});
  final int idOper;
  final List<Batch> batchList;
  final Machine machine;
  final int timeWorking;
  @override
  Widget build(BuildContext context) {
    List<ItemTextReady> listOperations = [];
    for (var batch in batchList) {
      for (var stage in batch.stageList) {
        for (var operat in stage.operationList) {
          int time = 0;
          for (var transfer in operat.transferList) {
            time += transfer.timesh;
          }
          listOperations.add(ItemTextReady(detailNumber: batch.number, operationName: operat.name, timeFact: time));
        }
      }
    }

    return (listOperations.isEmpty) 
    ? Center(child: Text('На станке ${machine.name} нет готовых деталей'),) 
    : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              Row(
                children: [
                  Text('Время работы станка - ${machine.name}: '),
                  Text('$timeWorking минут')
                ],
              ),
              const SizedBox(height: 8),
              const RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки'),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listOperations.length,
                itemBuilder: (context, index) => Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RowExpandContent(text1: '${listOperations[index].detailNumber}', text2: listOperations[index].operationName, text3: '${listOperations[index].timeFact}'),
                ),),),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {}, 
                  child: const Text('Вызгрузить'),
                ),
              )
      ],
    );
  }
}