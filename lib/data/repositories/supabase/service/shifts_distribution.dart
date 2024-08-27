import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ShiftsDistributionTable extends SupabaseTable{

  final table = Supabase.instance.client.from('z_shifts_distribution2');
  static const selectStaff = '*, z_position(*), z_company(*)';
  static const selectShifts = '*, z_staff($selectStaff), z_change(*), z_machine(*, z_shift_schedule(*))';
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

  Future<List<Map<String, dynamic>>> selectListIdNew(List<int> listId, DateTime date) {
    return table.select(selectShifts).inFilter('id',listId).eq('date', date);
  }

  Future<List<Map<String, dynamic>>> selectListMachineId(List<int> listId) {
    return table.select(selectShifts).inFilter('machine_id',listId);
  }

  Future<List<Map<String, dynamic>>> selectListId(List<int> listId, DateTime date) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'id.eq.${listId[i]}';
      } else {
        filters += 'id.eq.${listId[i]},';
      }
    }
    return table.select(selectShifts).or(filters).eq('date', date);
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select();
  }

  Future<List<Map<String, dynamic>>> selectEqMachineTimeChange(int machineId, DateTime time, int change) {
    return table.select(selectShifts).eq('machine_id', machineId).eq('date', time).eq('change_id', change);
  }

  Future<List<Map<String, dynamic>>> selectEqUser(int userId, DateTime time, int change) {
    return table.select(selectShifts).eq('staff_id', userId).eq('date', time).eq('change_id', change);
  }

  Future<List<Map<String, dynamic>>> selectListIdMachine(List<int> machineListId, DateTime date) {
    String filters = '';
    for (var i = 0; i < machineListId.length; i++) {
      if (i == (machineListId.length - 1)) {
        filters += 'machine_id.eq.${machineListId[i]}';
      } else {
        filters += 'machine_id.eq.${machineListId[i]},';
      }
    }
    return table.select(selectShifts).or(filters).eq('date', date);
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  Future<void> updateUser(int id, int userId) {
    return table.update({'staff_id': userId}).eq('id', id);
  }

}