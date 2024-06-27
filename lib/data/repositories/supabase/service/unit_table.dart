import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UnitTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_unit');
  final _companyId = CompanyService.instance.companyId ?? 0;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) {
    return table.insert(dto);
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select().eq('company_id', _companyId);
  }

    Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}