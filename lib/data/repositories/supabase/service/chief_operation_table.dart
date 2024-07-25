import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChiefOperationTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_chief_operation');

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is ChiefOperationDto) {
      await table.insert({
        'chief_batch_id': dto.chiefBatchId,
        'stage_id': dto.stageId,
        'operation_id': dto.operationId
      });
    }
  }

  Future<void> bulkInsert({required List<ChiefOperationDto> dtosList}) async {
    List<Map<String, Object>> mapsList = [];

    for (var dto in dtosList) {
      mapsList.add({
        'chief_batch_id': dto.chiefBatchId,
        'stage_id': dto.stageId,
        'operation_id': dto.operationId,
        'distribution_stage_id': dto.distributionStageId ?? 0
      });
    }

    var res = await table.insert(mapsList).select('id');

    print(res);
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    var res = await table
        .select('*, z_chief_batch(*, z_batch(*)), z_stage(*), z_operation(*)')
        .order('id', ascending: true);
    return res;
  }

  Future<Map<String, dynamic>> fetchLastOperationInBatch(
      {required int chiefBatchId}) async {
    print('chiefbatchId: $chiefBatchId');
    final res = await table
        .select()
        .eq('chief_batch_id', chiefBatchId)
        .order('id', ascending: true);
    return res.last;
  }

  Future<List<Map<String, dynamic>>> fetchLastOperationInBatchList(
      {required List<int> listChiefBatchId}) async {
    print('chiefbatchId: $listChiefBatchId');
    final res = await table
        .select()
        .inFilter('chief_batch_id', listChiefBatchId)
        .order('id', ascending: true);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectId(int batchId, int stageId) async {
    return await table
        .select('*, z_chief_batch(*, z_batch(*)), z_stage(*), z_operation(*)')
        .eq('chief_batch_id', batchId)
        .eq('stage_id', stageId);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> fetchOperationsByOperationIdWithLimit(
      {required int limit, required int operationId}) async {
    return await table
        .select()
        .eq('operation_id', operationId)
        .eq('is_distributed', false)
        .limit(limit);
  }

  Future<void> changeIsDistributed(
      {required List<int> operationsIdList}) async {
    for (var id in operationsIdList) {
      await table.update({'is_distributed': true}).eq('id', id);
    }
  }
}
