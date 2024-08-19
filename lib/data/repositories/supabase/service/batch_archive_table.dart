import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/usecase/company_service.dart';

class BatchArchiveTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_batch_archive');
  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) async {
    await _table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is BatchArchiveDto) {
      var data = await _table.insert({
        'name': dto.name,
        'number': dto.number,
        'technology_number': dto.technologyNumber,
        'code': dto.code,
        'company_id': _companyId
      }).select('id');

      return data.first['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await _table.select().eq('company_id', _companyId).order('id', ascending: false);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
