import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/group_opt_path.dart';

import '../../../../domain/model/item_saver.dart';
import 'state.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';

import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';

class CubitMaster extends Cubit<StateMaster> { 
  CubitMaster() : super(const StateMaster());

  void setPage(int index){
    emit(state.copyWith(activePage: index));
  }

  bool checkDialog(int index){
    bool check;
    check = state.isSaveOrder && (state.activePage == 2) && (index != 2);
    return check;
  }

  void toggleMonitor(){
    emit(state.copyWith(isThisMonitoring: !state.isThisMonitoring));
  }

  void setList(List<GroupOptPath> list){
    List<OptPathOperations> listNew = [];
    for (var e in list) {
      listNew.addAll(e.listOptPath);
    }
    emit(state.copyWith(list: listNew, isSaveOrder: list.isNotEmpty));
  }

  Future<void> saveDate() async {
    emit(state.copyWith(isActiveStream: false));
    final tableOperations = OperatorOperationsTable();
    List<ItemSaver> saveList = [];
    for (var i = 0; i < state.list!.length; i++) {
      saveList.add(ItemSaver(idPath: state.list![i].idPath, order: i));
    }
    for (var element in saveList) {
      await tableOperations.updateOrder(element.idPath, element.order);
    }

    emit(state.copyWith(list: [], isSaveOrder: false, isActiveStream: true));
  }
}