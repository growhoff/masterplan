import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OperatorOperationsTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_operator_operations');
  final selectUser = '*, z_position(*), z_company(*), z_unit(*), z_area(*)';

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

  Future<List<Map<String, dynamic>>> selectId(int machineId) {
    return table.select().eq('machine_id', machineId);
  }

  Future<List<Map<String, dynamic>>> selectListId(List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'machine_id.eq.${listId[i]}';
      } else {
        filters += 'machine_id.eq.${listId[i]},';
      }
    }
  return table.select('*, z_status(*), z_batch(*), z_user($selectUser), z_machine(*)').or(filters);
}

  Future<List<Map<String, dynamic>>> selectListIdSt(List<int> listId) {
    String filters = '';

    // if (listId.isEmpty) {filters = 'status_id.eq.5';}
    // else {filters = 'status_id.eq.5,';}

    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'machine_id.eq.${listId[i]}';
      } else {
        filters += 'machine_id.eq.${listId[i]},';
      }
    }
  return table.select('*, z_status(*), z_batch(*), z_user($selectUser), z_machine(*)').or(filters);//.eq('status_id', 5)
}

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}