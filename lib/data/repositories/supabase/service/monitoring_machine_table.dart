import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dto/monitoring_machine_dto.dart';

class MonitoringMachineTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_monitoring_machine2');
  static const userStaff = '*, z_position(*), z_company(*)';
  static const userMonitor = '*, z_status_machine(*), z_staff($userStaff), z_machine(*), z_batch(*)';
  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async{
    if (dto is MonitoringMachineDTO) await table.insert(dto.toMap()).select();
  }

  Future<int?> insertAndGetId(Dto dto) async{
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
    var res = await table.select(userMonitor);
    return res;
  }

  Future<List<Map<String, dynamic>>> selectListIdNew(List<int> listId) {
    return table.select(userMonitor).inFilter('id',listId);
  }

  Future<List<Map<String, dynamic>>> selectListIdMachineChange(List<int> listIdMachine, int change, String date, int userId) {
    return table.select(userMonitor).inFilter('machine_id',listIdMachine).eq('change_id', change).eq('date', date).eq('user_id', userId).order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectListIdMachineChangeLastDay(List<int> listIdMachine) {
    return table.select(userMonitor).inFilter('machine_id',listIdMachine).eq('time_stop', 0) .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectStatus(String date, int change, int idMachine) {
    return table.select('*').eq('date',date).eq('status_machine_id', 8).eq('change_id', change).eq('machine_id', idMachine);
  }

  Future<Map<String, dynamic>?> selectStatusLastMachine(int idMachine) async{
    final queue = await table.select(userMonitor).eq('machine_id', idMachine).order('id', ascending: true);
    if (queue.isEmpty){ return null;}
    else{return queue.last;}
  }

  Future<Map<String, dynamic>?> selectStatusLastMachineDate(int idMachine, DateTime date) async{
    final queue = await table.select(userMonitor).eq('machine_id', idMachine).lte('date', date) .order('id', ascending: true);
    if (queue.isEmpty){ return null;}
    else{return queue.last;}
  }

  Future<List<Map<String, dynamic>>> selectIdMonitor(int machineId, int batchId, int optPathOper) {
    return table.select(userMonitor).eq('operation_id', optPathOper).eq('batch_id', batchId).eq('machine_id', machineId);
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
    return table.select(userMonitor).or(filters);
  }

  Future<List<Map<String, dynamic>>> selectListIdMachine(List<int> listId, DateTime date) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'machine_id.eq.${listId[i]}';
      } else {
        filters += 'machine_id.eq.${listId[i]},';
      }
    }
    return table.select(userMonitor).or(filters).eq('date', date);
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
    return table.select(userMonitor).or(filters).eq('date', date).order('time_start', ascending: true);
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  Future<void> updateId(int id, int time) async{
    return table.update({'time_stop': time}).eq('id', id);
  }

  Future<void> updateIdComment(int id, int time, String comment) async{
    return table.update({'time_stop': time, 'comment': comment}).eq('id', id);
  }

  stream() {
    return table.stream(primaryKey: ['id']);
  }
}
