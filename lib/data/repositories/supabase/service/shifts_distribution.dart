import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShiftsDistributionTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_shifts_distribution');
  final selectUser = '*, z_position(*), z_company(*), z_unit(*), z_area(*)';
  
  @override
  Future<void> delete(int id) async{
    await table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async{
    if (dto is ShiftsDistributionDTO){
      await table.insert(dto.toMap());
    } 
  }



  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectEqUser(int userId) {
    return table.select('*, z_user($selectUser), z_change(*), z_machine(*)').eq('user_id', userId).eq('date', DateTime.now());
  }

  Future<List<Map<String, dynamic>>> selectList(List<int> machineListId, DateTime date) {
      String filters = 'date.eq.$date,';
      for (var i = 0; i < machineListId.length; i++) {
        if (i == (machineListId.length - 1)) {
          filters += 'machine_id.eq.${machineListId[i]}';
        } else {
          filters += 'machine_id.eq.${machineListId[i]},';
        }
      }
    return table.select('*, z_user($selectUser), z_change(*), z_machine(*)').or(filters);
  }

  @override
  Future<void> update(int id, Dto dto) {
   return table.update({'name': '1'}).eq('id', id);
  }

}