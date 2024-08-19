import 'package:master_plan/data/repositories/supabase/dto/operation_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OperationArchiveTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_operation_archive');

  final _companyId = CompanyService.instance.companyId ?? 0;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is OperationArchiveDto) {
      var res = await _table.insert({
        'name': dto.name,
        'number': dto.number,
        'code': dto.code,
        'time_pz': dto.timepz,
        'time_sh': dto.timeSH,
        'stage_archive_id': dto.stageArchiveId
      }).select('id');
      return res.first['id'];
    }
    return 1;
  }

  Future<void> updateTimeSH(int id, int operationTimeSH) async {
    return await _table.update({'time_sh': operationTimeSH}).eq('id', id);
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await _table.select();
  }

  Future<List<Map<String, dynamic>>> selectByStagesArchiveIdsList(
      List<int> stagesArchiveIdsList) async {
    return await _table
        .select('*, z_stage_archive(*)')
        .inFilter('stage_archive_id', stagesArchiveIdsList);
  }

  Future<List<Map<String, dynamic>>> selectByBatchArchiveId(
      int batchArchiveId) async {
    return await _table
        .select('*, z_stage_archive!inner(*)')
        .eq('z_stage_archive.batch_archive_id', batchArchiveId);
  }

  Future<List<Map<String, dynamic>>> selectByStageArchiveId(
      int stageArchiveId) async {
    return await _table.select().eq('stage_archive_id', stageArchiveId);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
