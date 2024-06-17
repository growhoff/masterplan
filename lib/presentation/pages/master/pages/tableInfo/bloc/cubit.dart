import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/model/table_model.dart';
import 'state.dart';

class CubitTableInfo extends Cubit<StateTableInfo> {
  final tableChief = ChiefDistributionOperationsTable();
  final tableOperations = OperatorOperationsTable();
  final List<OperatorOperations> operationList;
  CubitTableInfo(this.operationList) : super(const StateTableInfo()){
    print('id - chiefBatchId: \n');
    operationList.forEach((element) {print('${element.id} - ${element.chiefBatchId}');});
    getChiefTable(operationList.first.batch.id);
  }

  Future<void> getChiefTable (int batchId)async{
    final quereChief = await tableChief.selectListBatchId([batchId]);
    final quereOper = await tableOperations.selectChiefBatchId(operationList.first.chiefBatchId!);
    List<TableModel> listChief = [];
    int index = 0;
    for (var i = 0; i < quereChief.length; i++) {
      final model = ChiefDistributionOperationsDTO.fromMap(quereChief[i]);

    //проверка нахождения остальных операций
    String nameArea = '-';
    for (var element in quereOper) {
      final model2 = OperatorOperationsDTO.fromMap(element);
      if (model.operationId == model2.operationId) nameArea = model2.area!.name;
    }

    listChief.add(TableModel(nameOper: '${model.operation.number} ${model.operation.name}', order: i+1, nameArea: nameArea));
    if (model.operationId == operationList.first.operation.id){index = i;}
    }

  emit(state.copyWith(activeItem: index, listTable: listChief));
  }
}