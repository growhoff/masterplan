import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/usecase/company_service.dart';

class ChiefDistributionOperationsTable extends SupabaseTable {
  final table =
      Supabase.instance.client.from('z_chief_distribution_operations');
  final int? _companyId = CompanyService.instance.companyId;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
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

  @override
  Future<List<Map<String, dynamic>>> select() async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .eq('z_batch.company_id', _companyId ?? 1)
        .order('id', ascending: true);
    // print(res);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectListBatchId(
      List<int> batchId) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)')
        .inFilter('batch_id', batchId)
        .order('id', ascending: true);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed(
      {required int minRange,
      required int maxRange,
      required int unitId}) async {
    var res = await table
        .select(
            '*, z_batch:batch_id!inner(*), z_stage:stage_id(*), z_operation:operation_id(*)')
        .eq('z_batch.company_id', _companyId ?? 1)
        .inFilter('unit_id', [0, unitId])
        .gt('quantity', 0)
        .range(minRange, maxRange)
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

  stream() {
    return table.stream(primaryKey: ['id']);
  }
}
