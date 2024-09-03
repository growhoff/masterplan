import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/usecase/company_service.dart';

class ChiefBatchTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_chief_batch');
  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  Future bulkDeleteByBatchId(int batchId) async {
    await table.delete().eq('batch_id', batchId);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is ChiefBatchDTO) {
      var chiefBatch =
          await table.insert({'batch_id': dto.batchId}).select('id');
      return chiefBatch[0]['id'];
    }
    return 0;
  }

  Future<List<int>> bulkInsertFromList(
      {required List<ChiefBatchDTO> dtosList}) async {
    List<Map<String, Object>> mapsList = [];
    List<int> idsList = [];

    for (var dto in dtosList) {
      mapsList.add({'batch_id': dto.batchId});
    }

    var fetchedIdsList = await table.insert(mapsList).select('id');
    for (var fetchedId in fetchedIdsList) {
      idsList.add(fetchedId['id']);
    }

    return idsList;
  }

  Future<void> bulkInsert({
    required int batchId,
    required int quantity,
  }) async {
    List<Map<String, Object>> mapsList = [];
    for (int i = 0; i < quantity; i++) {
      mapsList.add({'batch_id': batchId, 'batch_status_id': 5});
    }

    await table.insert(mapsList);
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await table.select('*, z_batch(*)');
  }

  Future<List<Map<String, dynamic>>> selectByBatchId(int batchId) async {
    return await table
        .select('*,z_batch(*,z_batch_archive(*))')
        .eq('batch_id', batchId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByBatchIdWithInWorkStatus(
      int batchId) async {
    return await table
        .select('*,z_batch(*,z_batch_archive(*))')
        .eq('batch_id', batchId)
        .eq('batch_status_id', 7)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByBatchesIdList(
      List<int> batchesIdList) async {
    return await table
        .select('*,z_batch(*,z_batch_archive(*))')
        .inFilter('batch_id', batchesIdList);
  }

  Future<int> fetchReadyDetailsCount({required int batchId}) async {
    final res = await table
        .select('*, z_batch!inner(*)')
        .eq('batch_id', batchId)
        .eq('batch_status_id', 2)
        .eq('z_batch.company_id', _companyId)
        .count();

    return res.count;
  }

  Future<int> fetchDefectDetailsCount({required int batchId}) async {
    final res = await table
        .select('*, z_batch!inner(*)')
        .eq('batch_id', batchId)
        .eq('batch_status_id', 3)
        .eq('z_batch.company_id', _companyId)
        .count();
    return res.count;
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }

  Future updateChiefBatchStatusToInWorkList(
      {required List<int> chiefBatchIdList}) async {
    await table.update({'batch_status_id': 1}).inFilter('id', chiefBatchIdList);
  }

  Future updateChiefBatchStatusToIsFormedByList(
      {required List<int> chiefBatchIdList}) async {
    await table.update({'batch_status_id': 6}).inFilter('id', chiefBatchIdList);
  }

  Future<void> updateChiefBatchStatusToDefect(
      {required int chiefBatchId}) async {
    await table.update({'batch_status_id': 3}).eq('id', chiefBatchId);
  }

  Future<void> updateChiefBatchStatusToDefectList(
      {required List<int> chiefBatchId}) async {
    await table.update({'batch_status_id': 3}).inFilter('id', chiefBatchId);
  }

  Future<void> updateChiefBatchStatusToReady(
      {required int chiefBatchId}) async {
    await table.update({'batch_status_id': 2}).eq('id', chiefBatchId);
  }

  Future<void> updateChiefBatchStatusToReadyList(
      {required List<int> listChiefBatchId}) async {
    await table
        .update({'batch_status_id': 2})
        .inFilter('id', listChiefBatchId)
        .eq('batch_status_id', 1);
  }

  Future<void> updateStatusJob(List<int> idList) {
    return table.update({'batch_status_id': 7}).inFilter('id', idList);
  }

  Future<void> updateStatusReady(List<int> idList) {
    return table.update({'batch_status_id': 2}).inFilter('id', idList);
  }

  Future<void> updateStatusBrak(List<int> idList) {
    return table.update({'batch_status_id': 3}).inFilter('id', idList);
  }
}
