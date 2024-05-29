import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import '../../../../../../data/repositories/supabase/dto/chief_operation_dto.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import '../../../../../../data/repositories/supabase/service/chief_operation_table.dart';
import 'state.dart';

class CubitWork extends Cubit<StateWork> {
  final List<ShiftsDistribution>? zShiftsDistributionList;
  final List<int> machineListId;
  final operatorOperationsTable = OperatorOperationsTable();
  final monitorTable = MonitoringMachineTable();
  CubitWork(this.zShiftsDistributionList, this.machineListId) : super(const StateWork()) {

    List<int> btn = [];
    List<bool> setStart = [];
    for (var i = 0; i < zShiftsDistributionList!.length; i++) {btn.add(0);setStart.add(false);}
    emit(state.copyWith(statusBtn: btn, setStart: setStart));

    operatorOperationsTable.table.stream(primaryKey: ['id']).inFilter('machine_id', machineListId).listen((event) {
      }).onData((data)async {
          await getQuere(data);
      });
  }

    Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {if (element['status_id'] == 3 || element['status_id'] == 6 || element['status_id'] == 7 || element['status_id'] == 8) listId.add(element['id']);}
    final quere = await operatorOperationsTable.selectIdListNew(listId);
    List<OperatorOperations> operatorOperationsList = [];
      for (var operatorOper in quere) {
        final model = OperatorOperationsDTO.fromMap(operatorOper);
        operatorOperationsList.add(convertDto(model));
      }
    List<int> timeActive = [];
    List<PageItem> pageData = [];
    List<int> statusBtn1 = [...state.statusBtn];
    List<bool> setStart1 = [...state.setStart];
    for (var shiftsDistr in zShiftsDistributionList!) {
      List<OperatorOperations> listOperReady = [];
      List<OperatorOperations> listOperQueue = [];
      OperatorOperations? operActive;
      for (var operList in operatorOperationsList) {
        if (shiftsDistr.machine.id == operList.machine!.id) {
          if (operList.status.id == 6) listOperReady.add(operList);
          if (operList.status.id == 3) listOperQueue.add(operList);
          if (operList.status.id == 7) operActive = operList;
        }
      }
      //активным ставим первый
      if (operActive == null && listOperQueue.isNotEmpty){
        operActive ??= listOperQueue.first;
        listOperQueue.removeAt(0);
      }
      pageData.add(PageItem(machine: shiftsDistr.machine, operReadyList: listOperReady, operQueueList: listOperQueue, operActive: operActive));
      timeActive.add(operActive == null ? 0 : operActive.timestart ?? 0);

      for (var i = 0; i < timeActive.length; i++) {
        if (timeActive[i] !=0) {statusBtn1[i] = 1;setStart1[i]=true;}
      }
    }
    emit(state.copyWith(pageData: pageData, timeActive: timeActive, statusBtn: statusBtn1));
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  Future<void> setReady(OperatorOperations oper, int userId, int seconds, String comment, bool isStart)async{
    final quereMon = await monitorTable.selectIdMonitor(userId, oper, state.pageData[state.activePage].machine.id);
    final idMon = quereMon.first['id'];
    operatorOperationsTable.updateTimeStopAndReady(oper.id, DateTime.now().millisecondsSinceEpoch, seconds);
    setStopMonitor(1, idMon);
    setIsStart(false);

    checkIsDetailReady(chiefBatchId: oper.chiefBatchId ?? 0, chiefOperationId: oper.chiefOperationId ?? 0);
  }

  // проверка на готовность детали
  Future<void> checkIsDetailReady({required int chiefBatchId, required int chiefOperationId})async
  {
    final chiefOperationTable = ChiefOperationTable();
    final chiefBatchTable = ChiefBatchTable();

    // получает последнюю операцию в детали
    final fetchedLastOperationInBatch = await chiefOperationTable.fetchLastOperationInBatch(chiefBatchId: chiefBatchId);

    final lastOperationInBatchDto = ChiefOperationDto.fromMap(fetchedLastOperationInBatch);

    // если id последней операции в детали равен chiefOperationId у операции из operator_operations, то меняет статус детали на готово(2)
    if (lastOperationInBatchDto.id == chiefOperationId){
      chiefBatchTable.updateChiefBatchStatusToReady(chiefBatchId: chiefBatchId);
    }
  }



  Future<void> setStartMonitor(int status, int userid, String? comment, int operId) async{
    if (!state.setStart[state.activePage]){
      if ((comment == null) || (comment == '')) comment = 'none';
      final id = await monitorTable.insertToInt(MonitoringMachineDTO(id: 0, operationId: operId, date: DateTime.now(), changeId: (DateTime.now().hour > 8) && ( DateTime.now().hour <= 20) ? 1 : 2, timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: 1, userId: userid, machineId: state.pageData[state.activePage].machine.id, batchId: state.pageData[state.activePage].operActive!.batch.id, comment: comment));
      List<bool> list = [...state.setStart];
      list[state.activePage] = true;
      emit(state.copyWith(monitorId: id, setStart: list));
    }
    setBtnStatus(status);
  }

  Future<void> setStopMonitor(int status, int id) async{
    await monitorTable.updateId(id, DateTime.now().millisecondsSinceEpoch);
    setBtnStatus(status); 
  }

  void setError(int id, int userId, int seconds, String comment, bool isStart, int operId){
    operatorOperationsTable.updateTimeStop(id, DateTime.now().millisecondsSinceEpoch);
    setMonitor(4, userId, comment, isStart, operId);
  }

  Future<void> setMonitor(int status, int userid, String? comment, bool isStart, int operId) async{
    if ((comment == null) || (comment == '')) comment = 'none';
    if (isStart){
      final id = await monitorTable.insertToInt(MonitoringMachineDTO(id: 0, operationId: operId, date: DateTime.now(), changeId: (DateTime.now().hour > 8) && ( DateTime.now().hour <= 20) ? 1 : 2, timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: status, userId: userid, machineId: state.pageData[state.activePage].machine.id, batchId: state.pageData[state.activePage].operActive!.batch.id, comment: comment));
      emit(state.copyWith(monitorId: id));
    } else {
      await monitorTable.updateId(state.monitorId!, DateTime.now().millisecondsSinceEpoch);
    }
    setBtnStatus(status); 
  }


/*
0 - все активны
1 - пауза, готово, поломка
2 - уборка
3 - переналадка
4 - поломка
*/
  void setBtnStatus(int status){
    List<int> list = [...state.statusBtn];
    final index = state.activePage;
    int st;
    switch (status) {
      case 0: st = 1; break;
      case 1: st = 0; break;
      case 3: st = 3; break;
      case 4: st = 4; break;
      case 5: st = 2; break;
      default: st = 0;
    }
    if (!(st == 1) && (list[index] == st)) st = 0;
    list.removeAt(index);
    list.insert(index, st);
    emit(state.copyWith(statusBtn: list));
  }

  void setIsStart(bool b){
    List<bool> list = [...state.setStart];
    list[state.activePage] = b;
    emit(state.copyWith(setStart: list));
  }

  OperatorOperations convertDto(OperatorOperationsDTO dto) {
    return OperatorOperations(
      id: dto.id,
      area: dto.area!,
      operation: dto.operation,
      stage: dto.stage!,
      timeplan: dto.timeplan ?? 0,
      timefact: dto.timefact ?? 0,
      timestart: dto.timestart,
      timestop: dto.timestop,
      timeworking: dto.timeworking,
      status: Status(id: dto.status.id, name: dto.status.name),
      batch: Batch(
          id: dto.batch.id,
          number: dto.batch.number,
          name: dto.batch.name,
          count: dto.batch.count,
          code: dto.batch.code,
          packageId: dto.batch.packageId,
          technology: dto.batch.technology,
          order: dto.batch.order,
          isready: dto.batch.isready),
      order: dto.order,
      machine: Machine(
          id: dto.machine!.id,
          inventoryNumber: dto.machine!.inventoryNumber,
          name: dto.machine!.name,
          areaId: dto.areaId),
    );
  }
}