import 'package:master_plan/data/repositories/supabase/dto/stage_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StageArchiveTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_stage_archive');
  final _companyId = CompanyService.instance.companyId ?? 0;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is StageArchiveDTO) {
      var res = await _table.insert({
        'name': dto.name,
        'number': dto.number,
        'batch_archive_id': dto.batchArchiveId
      }).select('id');

      return res.first['id'];
    }
    return 1;
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await _table
        .select('*, z_batch_archive!inner(*)')
        .eq('z_batch_archive.company_id', _companyId);
  }

  Future<List<Map<String, dynamic>>> selectByBatchArchiveId(
      int batchArchiveId) async {
    return await _table
        .select('*, z_batch_archive!inner(*)')
        .eq('batch_archive_id', batchArchiveId);

  }


  Future<List<Map<String, dynamic>>> selectByBatchArchiveIdAndStageNumber(
      int batchArchiveId, String number) async {
    return await _table
        .select('*, z_batch_archive!inner(*)')
        .eq('batch_archive_id', batchArchiveId)
        .eq('number', number);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
