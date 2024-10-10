import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/model/chief_distribution_operations_model.dart';
import '../../../../domain/usecase/company_service.dart';

class ChiefDistributionOperationsTable extends SupabaseTable {
  final table =
      Supabase.instance.client.from('z_chief_distribution_operations');
  final int? _companyId = CompanyService.instance.companyId;
  final _unitId = ChiefUnitService.instance.unitId ?? 1;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future<void> bulkDelete(List<int> chiefDistributionOperationsIdsList) async {
    await table.delete().inFilter('id', chiefDistributionOperationsIdsList);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is ChiefDistributionOperationsDTO) {
      var operation = await table.insert({
        'batch_id': dto.batchId,
        'stage_id': dto.stageId,
        'operation_id': dto.operationId,
        'quantity': dto.quantity,
        'unit_id': dto.unitId ?? 0
      }).select('id');
      return operation[0]['id'];
    }
    return 0;
  }

  Future bulkInsert(List<ChiefDistributionOperationsDTO> dtosList) async {
    List<Map<String, Object>> mapsList = [];

    for (var dto in dtosList) {
      mapsList.add({
        'batch_id': dto.batchId,
        'stage_id': dto.stageId,
        'operation_id': dto.operationId,
        'quantity': dto.quantity,
        'unit_id': dto.unitId ?? 0
      });
    }

    await table.insert(mapsList);
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .eq('z_batch.company_id', _companyId ?? 1)
        .inFilter('unit_id', [0, _unitId]).order('id', ascending: true);
    print(res);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectByBatchAndStageIdWithNotZeroQuantity(
      {required int batchId, required int stageId}) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .eq('batch_id', batchId)
        .eq('stage_id', stageId)
        .neq('quantity', 0)
        .order('id', ascending: true);

    return res;
  }

  Future<List<Map<String, dynamic>>> selectByBatchAId(int batchId) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .eq('batch_id', batchId)
        .order('operation_id', ascending: true);

    return res;
  }

  Future<List<Map<String, dynamic>>> selectByBatchAndStageId(
      {required int batchId, required int stageId}) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .eq('batch_id', batchId)
        .eq('stage_id', stageId)
        .order('id', ascending: true);

    return res;
  }

  Future<List<Map<String, dynamic>>> selectByBatchesIdsLists({
    required List<int> batchesIdsList,
  }) async {
    var res = await table
        .select(
        '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .inFilter('batch_id', batchesIdsList)
        .order('id', ascending: true);

    return res;
  }


  Future<List<Map<String, dynamic>>> selectByBatchesIdsListsWithNoZeroQuantity({
    required List<int> batchesIdsList,
  }) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .inFilter('batch_id', batchesIdsList)
        .neq('quantity', 0)
        .order('id', ascending: true);

    return res;
  }

  Future<List<Map<String, dynamic>>> selectListBatchId(
      List<int> batchId) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .inFilter('batch_id', batchId)
        .eq('z_batch.company_id', _companyId ?? 1)
        .order('operation_id', ascending: true);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed(
      {required int minRange,
      required int maxRange,
      required int unitId}) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*, z_order(*)), z_stage:stage_id(*), z_operation:operation_id(*)')
        .eq('z_batch.company_id', _companyId ?? 1)
        .inFilter('unit_id', [0, unitId])
        .gt('quantity', 0)
        .order('id', ascending: true);
    return res;
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<void> updateQuantity(
      {required int chiefOperationId, required int newQuantity}) async {
    await table.update({'quantity': newQuantity}).eq('id', chiefOperationId);
  }

  Future<void> updateQuere(
      {required int stageId,
      required int operationId,
      required int batchId,
      required int quantity}) async {
    await table
        .update({'quantity': quantity})
        .eq('batch_id', batchId)
        .eq('operation_id', operationId)
        .eq('stage_id', stageId);
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }
}
