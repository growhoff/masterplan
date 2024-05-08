import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'state.dart';

class CubitDistributionDetails extends Cubit<StateDistributionDetails> {
  final int areaIdUser;
  final List<Machine> listMachine;
  final List<int> machineIdList;
  final tableOperations = OperatorOperationsTable();
  CubitDistributionDetails(this.areaIdUser, this.listMachine, this.machineIdList) : super(const StateDistributionDetails()){
      tableOperations.table.stream(primaryKey: ['id']).inFilter('machine_id', machineIdList).listen((event) {
      }).onData((data)async {
          List<DistribItem> res = [];
          res = [...await getQuere(data)];
          emit(state.copyWith(operList: res));
      });
  }

  void toggleSelect(int index){
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    bool select = state.operList[index].isSelected;
    final newitem = item.copyWith(isSelected: !select);
    list.removeAt(index);
    list.insert(index,newitem);
    emit(state.copyWith(operList: list));
  }

  void setMachine(int index, String machine){
    List<DistribItem> list = [...state.operList];
    DistribItem item = state.operList[index];
    final newitem = item.copyWith(setMachine: machine);
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

  Future<List<DistribItem>> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {
      if ((element['status_id'] as int == 2) || (element['status_id'] as int == 4)) listId.add(element['id']);
    }
    final table = OperatorOperationsTable();
    final quere = await table.selectListIdNew(listId);
    List<OperatorOperationsDTO> list = [];
    for (var item in quere) {
      list.add(OperatorOperationsDTO.fromMap(item));
    }
    List<DistribItem> listItem = [];
      for (var operOperat in list) {
        listItem.add(DistribItem(id: operOperat.id, stageNumber: '${operOperat.stage!.number}', statusId: operOperat.status.id, detailNumber: operOperat.batch.number, operationName: operOperat.operation.name, count: operOperat.batch.count, isSelected: false));
      }
    return listItem;
  }
}