import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_table.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../domain/usecase/company_service.dart';

class OperatorOperationsTable extends SupabaseTable {
  final table = Supabase.instance.client.from('z_operator_operations');
  static const selectStaff = '*, z_position(*), z_company(*)';
  static const selectOperOperat =
      '*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*, z_order(*)), z_staff($selectStaff), z_machine(*), z_area!inner(*), z_chief_operation(*), z_chief_batch(*), z_distribution_stage(*)';
  static const selectOperOperatLite = '*, z_status(*), z_batch(*, z_order(*)), z_stage(*), z_operation(*), z_area(*), z_machine(*), z_staff($selectStaff)';

  final _companyId = CompanyService.instance.companyId ?? 1;
  final _unitId = ChiefUnitService.instance.unitId ?? 0;

  @override
  Future<void> delete(int id) {
    return table.delete().eq('id', id);
  }

  Future<void> deleteListId(List<int> id) async{
    return await table.delete().inFilter('id', id);
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

  Future<void> bulkInsert(
      {required List<OperatorOperationsDTO> operationsList}) async {
    List<Map<String, Object?>> mapsList = [];

    for (var operation in operationsList) {
      mapsList.add({
        'time_plan': operation.timeplan,
        'status_id': operation.statusId,
        'batch_id': operation.batchId,
        'stage_id': operation.stageId,
        'operation_id': operation.operationId,
        'area_id': operation.areaId,
        'order': operation.order,
        'distribution_stage_id': operation.distributionStageId,
        'chief_operation_id': operation.chiefOperationId,
        'chief_batch_id': operation.chiefBatchId
      });
    }

    await table.insert(mapsList);
  }

  @override
  Future<List<Map<String, dynamic>>> select() {
    return table
        .select(selectOperOperat)
        .eq('z_area.company_id', _companyId)
        .order('id', ascending: true);
  }



  Future<List<Map<String, dynamic>>> selectByBatchIdWithoutDistributionStage(
      int batchId) {
    return table
        .select(selectOperOperat)
        .eq('batch_id', batchId)
        .isFilter('distribution_stage_id', null)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectOrderedByChiefOperation() {
    return table
        .select(selectOperOperat)
        .eq('z_area.company_id', _companyId)
        .eq('z_area.unit_id', _unitId)
        .order('chief_operation_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectByUnitOrderedByChiefOperation(
      int unitId) {
    return table
        .select(selectOperOperat)
        .eq('z_area.company_id', _companyId)
        .eq('z_area.unit_id', unitId)
        .order('chief_operation_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>>
  selectReadyDefectAndModificationOnAreaOrderedByBatch(
      List<int> areasIdList) {
    return table
        .select(
        '*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*,z_order(*)), z_staff(*,z_position(*)) z_machine(*), z_area!inner(*), z_chief_operation(*), z_chief_batch(*), z_distribution_stage()')
        .inFilter('area_id', areasIdList)
        .inFilter('status_id', [4, 5, 9])
        .order('batch_id', ascending: true)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>>
  selectByOperationIdListAndDistributionStagesIdList(
      {required List<int> operationsIdsList,
        required List<int> distributionStageIdsList}) {
    return table
        .select(
        '*, z_status(*), z_stage(*), z_operation(*) ,z_batch(*), z_staff(*, z_position(*)), z_machine(*), z_area!inner(*), z_chief_operation!inner(*), z_chief_batch(*)')
        .eq('z_area.company_id', _companyId)
        .inFilter('operation_id', operationsIdsList)
        .inFilter('distribution_stage_id', distributionStageIdsList)
        .order('id', ascending: true);
    //.order('chief_operation_id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectReadyDefectAndModificationOnArea(
      List<int> areasIdList) {
    print('_unitId : $_unitId');
    return table
        .select(selectOperOperat)
        .eq('z_area.company_id', _companyId)
        .inFilter('area_id', areasIdList)
        .inFilter('status_id', [4, 5, 9]).order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectMachineId(int machineId) {
    return table.select().eq('machine_id', machineId);
  }

  Future<List<Map<String, dynamic>>> selectListMachineId(
      List<int> machineIdList) {
    return table.select(selectOperOperat).inFilter('machine_id', machineIdList);
  }

  Future<List<Map<String, dynamic>>> selectAreaId(int idArea) {
    return table.select(selectOperOperat).eq('area_id', idArea);
  }

  Future<List<Map<String, dynamic>>> selectId(int id) {
    return table.select(selectOperOperatLite).eq('id', id);
  }

  Future<Map<String, dynamic>> selectOptPath(int optPath) async {
    final quere =
    await table.select(selectOperOperatLite).eq('optimal_part', optPath);
    return quere.last;
  }

  Future<Map<String, dynamic>> selectIdMachine(int idMachine) async {
    final quere = await table
        .select(selectOperOperatLite)
        .eq('status_id', 7)
        .eq('machine_id', idMachine);
    return quere.last;
  }

  Future<List<Map<String, dynamic>>> selectChiefBatchId(int chiefBatchId) {
    return table
        .select(selectOperOperatLite)
        .eq('chief_batch_id', chiefBatchId);
  }

  Future<List<Map<String, dynamic>>> selectChiefBatchIdList(
      List<int> chiefBatchId) {
    return table
        .select(selectOperOperatLite)
        .inFilter('chief_batch_id', chiefBatchId);
  }

  Future<List<Map<String, dynamic>>> selectListIdOrder(List<int> listId) {
    return table
        .select(selectOperOperatLite)
        .inFilter('id', listId)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> selectListChiefBatchIdOrder(
      List<int> listId) {
    return table
        .select(selectOperOperatLite)
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
        .select(
        '*, z_status(*), z_batch(*), z_staff($selectStaff), z_machine(*)')
        .or(filters);
  }

  Future<List<Map<String, dynamic>>> selectByAreaId(
      {required int areaId}) async {
    var res = await table
        .select(
        '*, z_status(*), z_batch(*), z_stage(*), z_operation(*),z_staff($selectStaff), z_machine(*)')
        .eq('area_id', areaId);
    print(res);
    return res;
  }

  @override
  Future<void> update(int id, Dto dto) {
    return table.update({'name': '1'}).eq('id', id);
  }

  Future<void> updateDistrStage(int id, int distStageId) {
    return table.update({'distribution_stage_id': distStageId}).eq('id', id);
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
    await table.update({'machine_id': machineId, 'status_id': 3}).inFilter(
        'id', listId);
  }

  //выбор машины и статус "очередь"
  Future<void> updateMasterQueueListPath(
      List<int> listId, int machineId, int random) async {
    await table.update({
      'machine_id': machineId,
      'status_id': 3,
      'optimal_part': DateTime.now().millisecondsSinceEpoch + random
    }).inFilter('id', listId);
  }

  //статус доработка
  Future<void> updateMasterModificate(int id) async {
    await table.update({'status_id': 4}).eq('id', id);
  }

  Future<void> updateMasterModificateList(List<int> listId) async {
    await table.update({'status_id': 4}).inFilter('id', listId);
  }

  Future<void> updateMasterModificateListCount(
      List<int> listId2, String comment) async {
    await table.update({
      'status_id': 4,
      'pause': null,
      'time_first_start': null,
      'time_start': null,
      'time_stop': null,
      'time_working': null,
      'modific': true,
      'comment': comment
    }).inFilter('id', listId2);
    // if (listId0.isNotEmpty) await table.update({'status_id': 9}).inFilter('id', listId0);
  }

  //статус брак
  Future<void> updateMasterBrak(int id) async {
    await table.update({'status_id': 5}).eq('id', id);
  }

  Future<void> updateMasterBrakList(List<int> listId) async {
    await table.update({'status_id': 5}).inFilter('id', listId);
  }

  Future<void> updateMasterBrakListCount(
      List<int> listId1, String comment) async {
    await table
        .update({'status_id': 5, 'comment': comment}).inFilter('id', listId1);
    // if (listId0.isNotEmpty) await table.update({'status_id': 9}).inFilter('id', listId0);
  }

  //статус готово
  Future<void> updateMasterReady(int id) async {
    await table.update({'status_id': 6}).eq('id', id);
  }

  Future<void> updateMasterReadyEqOptimalPart(
      int optPath,
      int staffId,
      ) async {
    await table.update({
      'status_id': 6,
      'staff_id': staffId,
      'time_working': 0,
      'time_first_start': DateTime.now().millisecondsSinceEpoch,
      'time_stop': DateTime.now().millisecondsSinceEpoch,
    }).eq('optimal_part', optPath);
  }

  //статус Статистика готовых
  Future<void> updateMasterStatisticReady(int id) async {
    await table.update({'status_id': 9}).eq('id', id);
  }

  Future<void> updateMasterStatisticReadyList(List<int> listId) async {
    await table.update({'status_id': 9}).inFilter('id', listId);
  }

  Future<void> updateOrder(int idPath, int order) async {
    await table.update({'order': order}).eq('optimal_part', idPath);
  }

  Future<void> updateTimeStart(
      int idOptPath, int timeStart, int staffId) async {
    await table.update({
      'time_start': timeStart,
      'pause': false,
      'staff_id': staffId
    }).eq('optimal_part', idOptPath);
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

  Future<void> updateTimeStopAndReady(int idOptPath, int timeStop, int seconds,
      int staffId, String comment) async {
    await table.update({
      'time_stop': timeStop,
      'status_id': 6,
      'time_working': seconds,
      'staff_id': staffId,
      'pause': true,
      'comment': comment
    }).eq('optimal_part', idOptPath);
  }

  Future<List<Map<String, dynamic>>>
  selectOrderedByChiefBatchIdAndChiefOperationId() {
    return table
        .select(selectOperOperat)
        .eq('z_area.company_id', _companyId)
        .eq('z_area.unit_id', _unitId)
        .order('chief_batch_id', ascending: true)
        .order('chief_operation_id', ascending: true);
  }

  Future<void> updateTimeStopAndReadyCount(List<int> listId0, List<int> listId5,
      int timeStop, int seconds, int staffId) async {
    if (listId0.isNotEmpty) {
      await table.update({
        'time_stop': timeStop,
        'status_id': 6,
        'time_working': seconds,
        'staff_id': staffId,
        'pause': true
      }).inFilter('id', listId0);
    }
    if (listId5.isNotEmpty) {
      await table.update({
        'time_stop': timeStop,
        'status_id': 5,
        'time_working': seconds,
        'staff_id': staffId,
        'pause': true,
      }).inFilter('id', listId5);
    }
  }
}
