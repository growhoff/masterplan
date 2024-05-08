import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChiefDistributionOperationsTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_chief_distribution_operations');

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is ChiefDistributionOperationsDTO) {
      await table.insert({
        'batch_id': dto.batchId,
        'stage_id': dto.stageId,
        'operation_id': dto.operationId,
        'quantity': dto.quantity
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    var res = await table
        .select(
            '*, z_batch:batch_id(*), z_stage:stage_id(*, z_area(*)), z_operation:operation_id(*)');
    print(res);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed() async {
    var res = await table
        .select(
        '*, z_batch:batch_id(*), z_stage:stage_id(*), z_operation:operation_id(*)')
        .gt('quantity', 0);
    print(res);
    return res;
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<void> updateQuantity({required int chiefOperationId, required int newQuantity})async{
    await table.update({'quantity': newQuantity}).eq('id', chiefOperationId);
  }
}
