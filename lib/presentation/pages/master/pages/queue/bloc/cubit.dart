import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
// import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_saver.dart';
// import 'package:master_plan/presentation/pages/master/pages/queue/queue_page.dart';
import 'state.dart';

class CubitQueueMaster extends Cubit<StateQueueMaster> {
  final List<Machine>? machineList;
  final List<OperatorOperations>? queueList;
  CubitQueueMaster(this.machineList, this.queueList) : super(const StateQueueMaster()) {
    List<ItemMachine> list = [];

    for (var machine in machineList!) {
      List<OperatorOperations> listQueue = [];
      int time = 0;
      for (var queueItem in queueList!) {
        if (queueItem.machine!.id == machine.id) {
          listQueue.add(queueItem);
          time += queueItem.timeplan;
        }
      }
      list.add(ItemMachine(machine: machine, listOper: listQueue, time: time));
    }
    emit(state.copyWith(listMachine: list));
  }

  void updateOperationDistribMaster(int id){
    final table = OperatorOperationsTable();
    table.updateMasterDistribMaster(id);
  }

  void updateOperationReady(int id){
    final table = OperatorOperationsTable();
    table.updateMasterReady(id);
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  Future<void> saveDate() async{
    final table = OperatorOperationsTable();
    List<ItemSaver> saveList = [];
    final operList = state.listMachine![state.activePage].listOper;
    for (var i = 0; i < operList.length; i++) {
      saveList.add(ItemSaver(id: operList[i].id, order: i));
    }
    for (var element in saveList) {
      await table.updateOrder(element.id, element.order);
    }
  }
}