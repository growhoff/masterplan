import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'state.dart';

class CubitEqueueOperator extends Cubit<StateEqueueOperator> { 
  CubitEqueueOperator() : super(const StateEqueueOperator());

    Future<void> setList(List<ItemOperOp> list) async{
    final tableOperations = OperatorOperationsTable();
    int i = 1;
    for (var element in list) {
      await tableOperations.updateOrder(element.idPath, i);
      i++;
    }
  }
}