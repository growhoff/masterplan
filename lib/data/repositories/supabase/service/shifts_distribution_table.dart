import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShiftsDistributionTable extends SupabaseTable{

  final table = Supabase.instance.client.from('f_shifts_distribution');
  
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
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectEq(int regionId, int companyId, DateTime date) {
    return table.select('id, f_change(*), date, f_equipment(*), f_user(*), f_region(*), f_company(*)').eq('region_id', regionId).eq('company_id', companyId).eq('date', date);
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}