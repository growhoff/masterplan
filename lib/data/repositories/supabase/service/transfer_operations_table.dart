import 'package:master_plan/data/repositories/supabase/dto/transfer_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TransferOperationsTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_transfer_operations');

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<int> insert(Dto dto) async {
    // if (dto is MachineDTO) {
    //   var data = await table.insert({
    //     'name': dto.name,
    //     'inventory_number': dto.inventoryNumber,
    //     'area_id': dto.areaId
    //   }).select('id');
    //   return data[0]['id'];
    // }
    return 0;
  }

  Future<void> updateTimeStart(
      int idOptPath, int timeStart, int staffId, int transferId) async {
    await table
        .update({'time_start': timeStart, 'pause': false, 'staff_id': staffId})
        .eq('opt_path', idOptPath)
        .eq('transfer_id', transferId);
  }

  Future<void> updateTimeStop(
      int idOptPath, int timeStop, int seconds, int transferId) async {
    await table
        .update({'time_stop': timeStop, 'pause': true, 'time_working': seconds})
        .eq('opt_path', idOptPath)
        .eq('transfer_id', transferId);
  }

  Future<void> updateTimeStopAndReady(int idOptPath, int timeStop, int seconds,
      int staffId, int transferId) async {
    await table
        .update({
          'time_stop': timeStop,
          'time_working': seconds,
          'staff_id': staffId,
          'pause': true,
        })
        .eq('opt_path', idOptPath)
        .eq('transfer_id', transferId);
  }

  Future<Map<String, dynamic>> selectOptPath(
      int optPath, int transferId) async {
    final quere = await table
        .select()
        .eq('opt_path', optPath)
        .eq('transfer_id', transferId);
    return quere.last;
  }

  Future<List<Map<String, dynamic>>> selectOptPathLast(int optPath) async {
    final quere = await table.select().eq('opt_path', optPath);
    return quere;
  }

  Future<int> selectOptPathTimeWork(int optPath) async {
    int time = 0;
    final quere = await table.select().eq('opt_path', optPath);
    if (quere.isNotEmpty) {
      for (var element in quere) {
        time = time + element['time_working'] as int;
      }
    }
    return time;
  }

  Future<void> insertDto(Dto dto) async {
    if (dto is TransferOperationsDTO) {
      await table.insert(dto.toMap());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table.select('*');
  }

  Future<List<Map<String, dynamic>>> selectByAreasIdsList(
      {required List<int> areasIdsList}) {
    return table
        .select('*,z_operator_operations!inner(*)')
        .inFilter('z_operator_operations.area_id', areasIdsList);
  }

  Future<List<Map<String, dynamic>>> selectByOperatorOperationsIdsList(
      List<int> operatorOperationsIdsList) async {
    return await table
        .select('*, z_transfer(*)')
        .inFilter('operator_operation_id', operatorOperationsIdsList)
        .order('operator_operation_id', ascending: true)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select().eq('id', id);
  }

  @override
  Future update(int id, Dto dto) async {
    // if (dto is MachineDTO) {
    //   await table.update({
    //     'name': dto.name,
    //     'inventory_number': dto.inventoryNumber,
    //     'area_id': dto.areaId
    //   }).eq('id', id);
    // }
  }
}
