import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BatchTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_batch');

  final int? _companyId = CompanyService.instance.companyId;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    if (dto is BatchDTO) {
      var data = await table.insert({
        'number': dto.number,
        'name': dto.name,
        'code': dto.code,
        'technology': dto.technology,
        'isready': false,
        'order': 0,
        'count': dto.count,
        'company_id': _companyId,
      }).select('id');

      return data[0]['id'];
    }
    return 0;
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select().eq('company_id', _companyId ?? 1);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }



  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  stream(){
    return table.stream(primaryKey: ['id']).order('id', ascending: true);
  }
}
