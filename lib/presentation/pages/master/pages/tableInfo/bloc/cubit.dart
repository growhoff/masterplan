import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'state.dart';

class CubitTableInfo extends Cubit<StateTableInfo> {
  final tableChief = ChiefDistributionOperationsTable();
  final int batchId;
  CubitTableInfo(this.batchId) : super(const StateTableInfo());

  // Future<void> getChiefTable (int batchId)async{
  //   final quereChief = await tableChief.selectListBatchId(listIdBatch);
  //   List<ChiefDistributionOperationsDTO> listChief = [];
  //   for (var element in quereChief) {
  //     listChief.add(ChiefDistributionOperationsDTO.fromMap(element));
  //   }
  //   List<SetModelChief> listB = [];
  //   var newMap = groupBy(listChief, (el) => el.batchId);
  //   newMap.forEach((key, value) {
  //     List<int> list = [];
  //     for (var element in value) {
  //       list.add(element.operationId);
  //     }
  //     listB.add(SetModelChief(batchId: key, list: list));
  //   });
  //   return listB;
  // }
}