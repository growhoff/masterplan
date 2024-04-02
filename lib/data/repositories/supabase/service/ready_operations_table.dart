import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReadyOperationsTable extends SupabaseTable{

  final table = Supabase.instance.client.from('f_ready_operations');
  
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

  Future<List<Map<String, dynamic>>> selectEq(int regionId, int companyId, int equipmentId) {
    return table.select('*, f_status(*), f_details(*), f_equipment(*), f_user(*)').eq('region_id', regionId).eq('company_id', companyId).eq('equipment_id', equipmentId).eq('is_uploaded', false);
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}