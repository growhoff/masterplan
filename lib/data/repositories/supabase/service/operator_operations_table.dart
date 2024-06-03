import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/usecase/company_service.dart';

class OperatorOperationsTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_operator_operations');
  static const selectUser =
      '*, z_position(*), z_company(*), z_unit(*), z_area(*)';

  final _companyId = CompanyService.instance.companyId ?? 1;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  @override
  Future<void> insert(Dto dto) async {
    if (dto is OperatorOperationsDTO) {
      await table.insert({
        'status_id': dto.statusId,
        'batch_id': dto.batchId,
        'stage_id': dto.stageId,
        'operation_id': dto.operationId,
        'area_id': dto.areaId,
        'order': dto.order,
        'chief_operation_id': dto.chiefOperationId,
        'chief_batch_id': dto.chiefBatchId
      });
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table
        .select(
            '*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*), z_user($selectUser), z_machine(*), z_area!inner(*), z_chief_operation(*), z_chief_batch(*)')
        .eq('z_area.company_id', _companyId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectReadyDefectAndModification() {
    return table
        .select(
            '*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*), z_user($selectUser), z_machine(*), z_area!inner(*), z_chief_operation(*), z_chief_batch(*)')
        .eq('z_area.company_id', _companyId)
        .inFilter('status_id', [4, 5, 9]).order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectId(int machineId) {
    return table.select().eq('machine_id', machineId);
  }

  Future<List<Map<String, dynamic>>> selectListIdNew(List<int> listId) {
    return table
        .select(
            '*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .inFilter('id', listId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectIdListNew(List<int> machineIdList) {
    return table
        .select(
            '*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .inFilter('id', machineIdList);
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
    return table
        .select('*, z_status(*), z_batch(*), z_user($selectUser), z_machine(*)')
        .or(filters);
  }

  Future<List<Map<String, dynamic>>> selectListId2436(List<int> listId) {
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
            '*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .or(filters)
        .or('status_id.eq.2,status_id.eq.3,status_id.eq.4,status_id.eq.6')
        .order('order', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectListIdMachine3678(List<int> listId) {
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
            '*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .or(filters)
        .or('status_id.eq.3,status_id.eq.6,status_id.eq.7,status_id.eq.8')
        .order('order', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByAreaId(
      {required int areaId}) async {
    var res = await table
        .select(
            '*, z_status(*), z_batch(*), z_stage(*), z_operation(*),z_user($selectUser), z_machine(*)')
        .eq('area_id', areaId);
    print(res);
    return res;
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  //статус распределение мастер
  Future<void> updateMasterDistribMaster(int id) async {
    await table.update({'status_id': 2}).eq('id', id);
  }

  //выбор машины и статус "очередь"
  Future<void> updateMasterQueue(int id, int machineId) async {
    await table.update({'machine_id': machineId, 'status_id': 3}).eq('id', id);
  }

  //выбор машины и статус "очередь"
  Future<void> updateMasterQueueList(List<int> listId, int machineId) async {
    await table.update({'machine_id': machineId, 'status_id': 3}).inFilter(
        'id', listId);
  }

  //статус доработка
  Future<void> updateMasterModificate(int id) async {
    await table.update({'status_id': 4}).eq('id', id);
  }

  //статус брак
  Future<void> updateMasterBrak(int id) async {
    await table.update({'status_id': 5}).eq('id', id);
  }

  //статус готово
  Future<void> updateMasterReady(int id) async {
    await table.update({'status_id': 6}).eq('id', id);
  }

  //статус Статистика готовых
  Future<void> updateMasterStatisticReady(int id) async {
    await table.update({'status_id': 9}).eq('id', id);
  }

  Future<void> updateOrder(int id, int order) async {
    await table.update({'order': order}).eq('id', id);
  }

  Future<void> updateTimeStart(int id, int timeStart, int userId) async {
    await table.update({'time_start': timeStart, 'pause': false, 'user_id': userId}).eq('id', id);
  }

  Future<void> setFirstTimeStart(int id, int timeStart) async {
    await table.update({
      'time_first_start': timeStart,
      'time_start': timeStart,
      'status_id': 7,
      'pause': false
    }).eq('id', id);
  }

  Future<void> updateTimeStop(int id, int timeStop, int seconds) async {
    await table.update({
      'time_stop': timeStop,
      'pause': true,
      'time_working': seconds
    }).eq('id', id);
  }

  Future<void> updateTimeStopAndReady(int id, int timeStop, int seconds, int userId) async {
    await table.update({
      'time_stop': timeStop,
      'status_id': 6,
      'time_working': seconds,
      'user_id': userId
    }).eq('id', id);
  }
}
