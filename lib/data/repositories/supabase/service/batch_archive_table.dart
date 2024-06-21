import 'package:master_plan/data/repositories/supabase/dto/batch_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../domain/usecase/company_service.dart';

class BatchArchiveTable extends SupabaseTable {
  final _table = Supabase.instance.client.from('z_batch_archive');
  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is BatchArchiveDto) {
      await _table.insert({
        'name': dto.name,
        'number': dto.number,
        'technology_number': dto.technologyNumber,
        'company_id': dto.companyId
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    return await _table.select().eq('company_id', _companyId);
  }

  @override
  Future<void> update(int id, Dto dto) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
