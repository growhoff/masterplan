import 'package:flutter_bloc/flutter_bloc.dart';

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

  void setList(List<OptPathOperations> list){
    emit(state.copyWith(list: list, isSaveOrder: list.isNotEmpty));
  }

  Future<void> saveDate() async {
    final tableOperations = OperatorOperationsTable();
    List<ItemSaver> saveList = [];
    for (var i = 0; i < state.list!.length; i++) {
      saveList.add(ItemSaver(idPath: state.list![i].idPath, order: i));
    }
    for (var element in saveList) {
      await tableOperations.updateOrder(element.idPath, element.order);
    }

    emit(state.copyWith(list: [], isSaveOrder: false));
  }
}