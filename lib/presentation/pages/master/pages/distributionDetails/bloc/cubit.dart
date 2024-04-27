import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'state.dart';

class CubitDistributionDetails extends Cubit<StateDistributionDetails> {
  final List<OperatorOperations> operOperatList;
  final int areaIdUser;
  final List<Machine> listMachine;
  CubitDistributionDetails(this.operOperatList, this.areaIdUser, this.listMachine) : super(const StateDistributionDetails()){
      List<DistribItem> list = [];
      for (var operOperat in operOperatList) {
        list.add(DistribItem(id: operOperat.id, stageNumber: '${operOperat.stage.number}', detailNumber: operOperat.batch.number, operationName: operOperat.operation.name, count: operOperat.batch.count, isSelected: false));
      }
    emit(state.copyWith(operList: list));
  }

  void toggleSelect(int index){
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    bool select = state.operList[index].isSelected;
    final newitem = item.copyWith(isSelected: !select);
    // print(newitem.isSelected);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setMachine(int index, String machine){
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    final newitem = item.copyWith(setMachine: machine);
    // print(newitem.setMachine);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setCount(int index, String countStr){
      if (countStr == '') {countStr = '0';}
      int count = int.parse(countStr);
      List<DistribItem> list = [...state.operList];
      DistribItem item = state.operList[index];
      final newitem = item.copyWith(setCount: count);
      // print(newitem.setCount);
      list.removeAt(index);
      list.insert(index,newitem);
      emit(state.copyWith(operList: list));
  }

  void updateOperation(){
    final table = OperatorOperationsTable();
    for (var oper in state.operList) {
      if ((oper.setCount != null) && (oper.setCount != 0) && (oper.setMachine != '')) {
        for (var machine in listMachine) {
          if (machine.name == oper.setMachine) table.updateMasterQueue(oper.id, machine.id);
        }
      }
    }
  }
}