import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/model/distribution_stage.dart';
import '../../../../domain/usecase/company_service.dart';
import '../impliments/imp_table.dart';

class DistributionStageTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_distribution_stage');

  final _companyId = CompanyService.instance.companyId ?? 0;
  final _unitId = ChiefUnitService.instance.unitId ?? 1;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future bulkDeleteByIdsList(List<int> distributionStagesIdsList) async {
    await _table.delete().inFilter('id', distributionStagesIdsList);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is DistributionStageDto) {
      await _table.insert({
        'stage_id': dto.stageId,
        'chief_batch_id': dto.chiefBatchId,
        'status_id': 2,
        'unit_id': dto.unitId
      });
    }
  }

  Future<List<Map<String, dynamic>>> bulkInsert(
      {required List<DistributionStage> distributionStagesList}) async {
    List<Map<String, Object>> mapsList = [];
    for (var stage in distributionStagesList) {
      mapsList.add({
        'stage_id': stage.stageId,
        'chief_batch_id': stage.chiefBatchId,
        'status_id': 1,
      });
    }
    var res = await _table.insert(mapsList).select();
    return res;
  }

  Future<List<Map<String, dynamic>>> chiefBulkInsert(
      {required List<DistributionStage> distributionStagesList}) async {
    List<Map<String, Object>> mapsList = [];
    for (var stage in distributionStagesList) {
      mapsList.add({
        'unit_id': _unitId,
        'stage_id': stage.stageId,
        'chief_batch_id': stage.chiefBatchId,
        'status_id': 2,
      });
    }
    var res = await _table.insert(mapsList).select();
    return res;
  }

  Future bulkUpdateUnitOnNullAndStatusToOnDistribution(
      List<int> distributionStagesIdsList) async {
    await _table.update({
      'status_id': 1,
      'unit_id': null,
    }).inFilter('id', distributionStagesIdsList);
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByUnitsIdsList(
      List<int> unitsIdsList) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .inFilter('unit_id', unitsIdsList)
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByBatchesIdsList(
      List<int> batchesIdsList) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .inFilter('z_chief_batch.batch_id', batchesIdsList)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>>
      selectByBatchesIdsListOrderedByChiefBatchAndStageId(
          List<int> batchesIdsList) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .inFilter('z_chief_batch.batch_id', batchesIdsList)
        .order('chief_batch_id', ascending: true)
        .order('stage_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByBatchesAndStagesIdsList(
      {required List<int> batchesIdsList,
      required List<int> stagesIdsList}) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .inFilter('z_chief_batch.batch_id', batchesIdsList)
        .inFilter('z_chief_batch.batch_id', stagesIdsList)
        .order('chief_batch_id', ascending: true)
        .order('stage_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> select691() async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('z_chief_batch.batch_id', 691)
        .inFilter('stage_id', [1238, 1240]).order('id', ascending: true);
  }

  Future updateStage(int id) async {
    await _table.update({'status_id': 1, 'unit_id': null}).eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectByBatchId(int batchId) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*), z_order(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.batch_id', batchId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByUnitId(int unitId) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_order!inner(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('unit_id', unitId)
        .order('chief_batch_id', ascending: true)
        .order('stage_id', ascending: true)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByIdsList(List<int> idsList) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .inFilter('id', idsList)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByChiefBatchIdsList(
      List<int> chiefBatchIdsList) async {
    return await _table
        .select(
            '*,z_unit(*), z_chief_batch!inner(*, z_batch!inner(*, z_order(*),z_batch_archive(*))), z_stage(*), z_stage_status(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .inFilter('chief_batch_id', chiefBatchIdsList)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectUploadedByStageId(
      int stageId) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('stage_id', stageId)
        .eq('status_id', 4)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectUploadedByStageIdAndChiefBatchesList(
      int stageId,
      {required List<int> chiefBatchesIdsList}) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('stage_id', stageId)
        .inFilter('chief_batch_id', chiefBatchesIdsList)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByBatchIdAndStageId(
      {required int batchId, required int stageId}) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('stage_id', stageId)
        .eq('z_chief_batch.batch_id', batchId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectNotUploadedByBatchIdAndStageId(
      {required int batchId, required int stageId}) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('stage_id', stageId)
        .eq('z_chief_batch.batch_id', batchId)
        .neq('status_id', 4)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectUploadedByStageIdsList(
      List<int> stagesIdsList) async {
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*, z_batch_archive(*))), z_stage(*)')
        .inFilter('stage_id', stagesIdsList)
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('status_id', 4)
        .order('id', ascending: true);
  }

  Future bulkChangeStatusToInWork(List<int> idList) async {
    await _table.update({
      'status_id': 2,
    }).inFilter('id', idList);
  }

  Future bulkUpdateStatusToExecuteAndUnit(List<int> idList, int unitId) async {
    await _table.update({
      'status_id': 6,
      'unit_id': unitId,
    }).inFilter('id', idList);
  }

  Future bulkChangeStatusToDistributed(List<int> idList) async {
    await _table.update({
      'status_id': 4,
    }).inFilter('id', idList);
  }

  Future<List<Map<String, dynamic>>> selectNotDistributed() async {
    print(_companyId);
    return await _table
        .select(
            '*, z_chief_batch!inner(*, z_batch!inner(*,z_order(*), z_batch_archive(*))), z_stage(*)')
        .eq('z_chief_batch.z_batch.company_id', _companyId)
        .eq('status_id', 1);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future<void> updateStatus(int stageId, int chiefBatchId) async {
    await _table
        .update({'status_id': 3})
        .eq('stage_id', stageId)
        .eq('chief_batch_id', chiefBatchId)
        .eq('status_id', 2);
  }

  Future<void> updateStatusBrak(int stageId, int chiefBatchId) async {
    await _table
        .update({'status_id': 5})
        .eq('stage_id', stageId)
        .eq('chief_batch_id', chiefBatchId);
  }

  Future<void> updateStatusJob(int stageId, int chiefBatchId) async {
    await _table
        .update({'status_id': 2})
        .eq('stage_id', stageId)
        .eq('chief_batch_id', chiefBatchId);
  }

  Future<void> updateStatusReady(int stageId, int chiefBatchId) async {
    await _table
        .update({'status_id': 3})
        .eq('stage_id', stageId)
        .eq('chief_batch_id', chiefBatchId);
  }

  Future<void> updateUnit(int id, int unitId) async {
    await _table.update({'unit_id': unitId}).eq('id', id);
  }

  Future<void> bulkUpdate(List<int> idsList) async {
    await _table.update({'unit_id': 1}).inFilter('id', idsList);
  }
}
