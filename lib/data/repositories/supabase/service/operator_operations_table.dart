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
        'time_plan': dto.timeplan,
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
        .select('*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*), z_user($selectUser), z_machine(*), z_area!inner(*), z_chief_operation(*), z_chief_batch(*)')
        .eq('z_area.company_id', _companyId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectReadyDefectAndModification() {
    return table
        .select('*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*), z_user($selectUser), z_machine(*), z_area!inner(*), z_chief_operation(*), z_chief_batch(*)')
        .eq('z_area.company_id', _companyId)
        .inFilter('status_id', [4, 5, 9]).order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectMachineId(int machineId) {
    return table.select().eq('machine_id', machineId);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)').eq('id', id);
  }

  Future<List<Map<String, dynamic>>> selectChiefBatchId(int chiefBatchId) {
    return table.select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)').eq('chief_batch_id', chiefBatchId);
  }

  Future<List<Map<String, dynamic>>> selectChiefBatchIdList(List<int> chiefBatchId) {
    return table.select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)').inFilter('chief_batch_id', chiefBatchId);
  }

  Future<List<Map<String, dynamic>>> selectListIdOrder(List<int> listId) {
    return table
        .select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .inFilter('id', listId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectListChiefBatchIdOrder(List<int> listId) {
    return table
        .select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .inFilter('chief_batch_id', listId)
        .order('id', ascending: true);
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

  Future<List<Map<String, dynamic>>> selectListMachineIdStatus2346(List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'machine_id.eq.${listId[i]}';
      } else {
        filters += 'machine_id.eq.${listId[i]},';
      }
    }
    return table
        .select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
        .or(filters)
        .or('status_id.eq.2,status_id.eq.3,status_id.eq.4,status_id.eq.6')
        .order('order', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectListIdMachineStatus3678(List<int> listId) {
    String filters = '';
    for (var i = 0; i < listId.length; i++) {
      if (i == (listId.length - 1)) {
        filters += 'machine_id.eq.${listId[i]}';
      } else {
        filters += 'machine_id.eq.${listId[i]},';
      }
    }
    return table
        .select('*, z_status(*), z_batch(*), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_user($selectUser)')
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

  Future<void> updateMasterDistribMasterEqOptimalPart(int id) async {
    await table.update({'status_id': 2}).eq('optimal_part', id);
  }

  //выбор машины и статус "очередь"
  Future<void> updateMasterQueue(int id, int machineId) async {
    await table.update({'machine_id': machineId, 'status_id': 3}).eq('id', id);
  }

  //выбор машины и статус "очередь"
  Future<void> updateMasterQueueList(List<int> listId, int machineId) async {
    await table.update({'machine_id': machineId, 'status_id': 3}).inFilter('id', listId);
  }

  //выбор машины и статус "очередь"
  Future<void> updateMasterQueueListPath(List<int> listId, int machineId, int random) async {

    await table.update({'machine_id': machineId, 'status_id': 3, 'optimal_part': DateTime.now().millisecondsSinceEpoch + random}).inFilter('id', listId);
  }

  //статус доработка
  Future<void> updateMasterModificate(int id) async {
    await table.update({'status_id': 4}).eq('id', id);
  }

  Future<void> updateMasterModificateList(List<int> listId) async {
    await table.update({'status_id': 4}).inFilter('id', listId);
  }

  //статус брак
  Future<void> updateMasterBrak(int id) async {
    await table.update({'status_id': 5}).eq('id', id);
  }

  Future<void> updateMasterBrakList(List<int> listId) async {
    await table.update({'status_id': 5}).inFilter('id', listId);
  }

  //статус готово
  Future<void> updateMasterReady(int id) async {
    await table.update({'status_id': 6}).eq('id', id);
  }

  Future<void> updateMasterReadyEqOptimalPart(int id) async {
    await table.update({'status_id': 6}).eq('optimal_part', id);
  }

  //статус Статистика готовых
  Future<void> updateMasterStatisticReady(int id) async {
    await table.update({'status_id': 9}).eq('id', id);
  }

  Future<void> updateMasterStatisticReadyList(List<int> listId) async {
    await table.update({'status_id': 9}).inFilter('id', listId);
  }

  Future<void> updateOrder(List<int> listId, int order) async {
    await table.update({'order': order}).inFilter('id', listId);
  }

  Future<void> updateTimeStart(int idOptPath, int timeStart, int userId) async {
    await table.update({'time_start': timeStart, 'pause': false, 'user_id': userId}).eq('optimal_part', idOptPath);
  }

  Future<void> setFirstTimeStart(int idOptPath, int timeStart) async {
    await table.update({
      'time_first_start': timeStart,
      'time_start': timeStart,
      'status_id': 7,
      'pause': false
    }).eq('optimal_part', idOptPath);
  }

  Future<void> updateTimeStop(int idOptPath, int timeStop, int seconds) async {
    await table.update({
      'time_stop': timeStop,
      'pause': true,
      'time_working': seconds
    }).eq('optimal_part', idOptPath);
  }

  Future<void> updateTimeStopAndReady(int idOptPath, int timeStop, int seconds, int userId) async {
    await table.update({
      'time_stop': timeStop,
      'status_id': 6,
      'time_working': seconds,
      'user_id': userId
    }).eq('optimal_part', idOptPath);
  }
}
