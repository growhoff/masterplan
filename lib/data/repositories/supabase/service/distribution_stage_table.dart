import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/model/distribution_stage.dart';
import '../../../../domain/usecase/company_service.dart';
import '../impliments/imp_table.dart';

class DistributionStageTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_distribution_stage');

  final _companyId = CompanyService.instance.companyId ?? 0;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is DistributionStageDto) {
      await _table.insert({
        'stage_id': dto.stageId,
        'batch_id': dto.chiefBatchId,
        'status_id': 1,
        'unit_id': dto.unitId
      });
    }
  }

  Future bulkInsert(
      {required List<DistributionStage> distributionStagesList}) async {
    List<Map<String, Object>> mapsList = [];
    for (var stage in distributionStagesList) {
      mapsList.add({
        'stage_id': stage.stageId,
        'chief_batch_id': stage.chiefBatchId,
        'status_id': 1,
      });
    }
    await _table.insert(mapsList);
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await _table
        .select('*, z_batch!inner(*), z_stage(*)')
        .eq('z_batch.company_id', _companyId);
  }

  Future bulkChangeStatusToInWork(List<int> idList) async {
    await _table.update({'status_id': 2}).inFilter('id', idList);
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed() async {
    return await _table
        .select(
            '*, z_chief_batch(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('status_id', 1);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
