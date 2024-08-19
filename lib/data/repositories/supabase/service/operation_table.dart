import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto/operation_dto.dart';

class OperationTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_operation');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is OperationDTO) {
      var operation = await table.insert({
        'number': dto.number,
        'name': dto.name,
        'code': dto.code,
        'time_pz': dto.timepz,
        'stage_id': dto.stageId,
        'time_sh': dto.timeSH,
      }).select('id');
      return operation[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() async{
    return await table.select('*,z_stage(*)').order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByStageIdList(
      List<int> stagesIdList) async {
    return await table
        .select()
        .inFilter('stage_id', stagesIdList)
        .order('id', ascending: true);
  }

  Future<void> bulkInsert(
      {required List<OperationDTO> operationsDtosList}) async {
    List<Map<String, Object>> mapsList = [];
    for (int i = 0; i < operationsDtosList.length; i++) {
      var operation = operationsDtosList[i];
      mapsList.add({
        'number': operation.number,
        'name': operation.name,
        'code': operation.code,
        'time_pz': operation.timepz,
        'stage_id': operation.stageId,
        'time_sh': operation.timeSH,
      });
    }

    await table.insert(mapsList);
  }

  Future<List<Map<String, dynamic>>> selectByBatchesIdsList(
      List<int> batchesIdList) async {
    return await table
        .select('*, z_stage!inner(*)')
        .inFilter('z_stage.batch_id', batchesIdList)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectListId(List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'id.eq.${listId[i]}';
      } else {
        filters += 'id.eq.${listId[i]},';
      }
    }
    return table.select().or(filters);
  }

  Future selectByIdsList(List<int> idsList) async {
    return await table
        .select('*, z_stage(*, z_batch(*))')
        .inFilter('id', idsList);
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  Future<void> updateTimeSH(int id, int operationTimeSH) async {
    return await table.update({'time_sh': operationTimeSH}).eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectByStageId(
      {required int stageId}) async {
    return await table
        .select()
        .eq('stage_id', stageId)
        .order('id', ascending: true);
  }

  Future<int> fetchOperationsQuantityInStage({required int stageId}) async {
    final res =
        await table.select().eq('stage_id', stageId).count(CountOption.exact);

    return res.count;
  }
}
