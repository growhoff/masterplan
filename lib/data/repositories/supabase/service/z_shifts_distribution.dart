import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ZShiftsDistributionTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_shifts_distribution');
  
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

  Future<List<Map<String, dynamic>>> selectEq(List<int> machineListId, DateTime date) { //, DateTime date
        String filters = 'date.eq.$date,';
      for (var i = 0; i < machineListId.length; i++) {
        if (i == (machineListId.length - 1)) {
          filters += 'machine_id.eq.${machineListId[i]}';
        } else {
          filters += 'machine_id.eq.${machineListId[i]},';
        }
      }
    return table.select('*, z_user(*), z_change(*), z_machine(*)').or(filters);
    // return table.select('*, z_machine(*)').eq('machine_id', machineId);//.eq('date', date)
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}