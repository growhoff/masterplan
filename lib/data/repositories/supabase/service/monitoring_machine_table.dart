import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto/monitoring_machine_dto.dart';

class MonitoringMachineTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_monitoring_machine');
  static const userSelect = '*, z_position(*), z_company(*), z_unit(*), z_area(*)';

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }



  @override
  Future<void> insert(Dto dto) async{
    if (dto is MonitoringMachineDTO) await table.insert(dto.toMap()).select();
  }

  Future<int?> insertToInt(Dto dto) async{
    int? id;
    if (dto is MonitoringMachineDTO) {
      final qveru = await table.insert(dto.toMap()).select();
      id = qveru.first['id'] as int;
    }
    else {id = null;}
    return id;
  }

  @override
  Future<List<Map<String, dynamic>>> select() async {
    var res = await table.select(
        '*, z_status_machine(*), z_user($userSelect), z_machine(*), z_batch(*)');
    return res;
  }

  Future<List<Map<String, dynamic>>> selectList(List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'machine_id.eq.${listId[i]}';
      } else {
        filters += 'machine_id.eq.${listId[i]},';
      }
    }
    return table
        .select(
            '*, z_status_machine(*), z_user($userSelect), z_machine(*), z_batch(*)')
        .or(filters);
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  Future<void> updateId(int id, int time) async{
    return table.update({'time_stop': time}).eq('id', id);
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }
}
