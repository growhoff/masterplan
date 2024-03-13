import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OperatorOperationsTable extends SupabaseTable{

  final table = Supabase.instance.client.from('f_operator_operations');
  
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
    return table.select('id, order, f_region(*), f_company(*), time, time_start, time_working, f_status(*), stage_operation_id, stage_master_operation_id, f_equipment(*), f_details(*)');
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}