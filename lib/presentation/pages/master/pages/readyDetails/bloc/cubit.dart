import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import 'state.dart';

class CubitReadyDetails extends Cubit<StateReadyDetails> { 
  final List<Machine>? machineList;
  final List<OperatorOperations>? readyList;
  CubitReadyDetails(this.machineList, this.readyList) : super(const StateReadyDetails()){
    List<ItemMachine> listMachine = [];
    List<List<int>> doubleList = [];
    for (var machine in machineList!) {
      int timePlan = 0;
      List<OperatorOperations> list = [];
      List<int> intList = [];
      for (var operList in readyList!) {
        if (operList.machine!.id == machine.id) {
          list.add(operList);
          timePlan += operList.timeplan;
          intList.add(6);
        }
      }
      listMachine.add(ItemMachine(machine: machine, listOper: list, time: timePlan));
      doubleList.add(intList);
    }
    emit(state.copyWith(listMachine: listMachine, doubleList: doubleList));
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  void toggleBrak(int indexOper){
    List<List<int>> l = [...state.doubleList];
    int it = l[state.activePage][indexOper];
    if (it == 5) {it = 6;} else {it = 5;}
    List<int> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, it);
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(doubleList: l, count: state.count+1));
  }
  

  void toggleModific(int indexOper){
    List<List<int>> l = [...state.doubleList];
    int it = l[state.activePage][indexOper];
    if (it == 4) {it = 6;} else {it = 4;}
    List<int> item = l[state.activePage];
    item.removeAt(indexOper);
    item.insert(indexOper, it);
    l.removeAt(state.activePage);
    l.insert(state.activePage, item);
    emit(state.copyWith(doubleList: l, count: state.count+1));
  }

  void updateOperation(){
    final table = OperatorOperationsTable();
    final listOper = state.listMachine![state.activePage].listOper;
    if (listOper.isNotEmpty){
      final listStatus = state.doubleList[state.activePage];
      for (var i = 0; i < listOper.length; i++) {
        if (listStatus[i] == 4) table.updateMasterModificate(listOper[i].id);
        if (listStatus[i] == 5) table.updateMasterBrak(listOper[i].id); 
        if (listStatus[i] == 6) table.updateMasterStatisticReady(listOper[i].id); 
      }
    }
  }
}