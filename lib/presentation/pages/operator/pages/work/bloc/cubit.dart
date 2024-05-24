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
import 'state.dart';

class CubitWork extends Cubit<StateWork> {
  final List<ShiftsDistribution>? zShiftsDistributionList;
  // final List<OperatorOperations>? operatorOperationsList;
  final List<int> machineListId;
  final operatorOperationsTable = OperatorOperationsTable();
  CubitWork(this.zShiftsDistributionList, this.machineListId) : super(const StateWork()) {
    //
    operatorOperationsTable.table.stream(primaryKey: ['id']).inFilter('machine_id', machineListId).listen((event) {
      }).onData((data)async {
          await getQuere(data);
      });
    
    //

    // List<PageItem> pageData = [];
    // List<int> btn = [];
    // for (var shiftsDistr in zShiftsDistributionList!) {
    //   List<OperatorOperations> listOperReady = [];
    //   List<OperatorOperations> listOperQueue = [];
    //   for (var operList in operatorOperationsList!) {
    //     if (shiftsDistr.machine.id == operList.machine!.id) {
    //       if (operList.status.id == 6) listOperReady.add(operList);
    //       if (operList.status.id == 3) listOperQueue.add(operList);
    //     }
    //   }
    //   btn.add(0);
    //   pageData.add(PageItem(machine: shiftsDistr.machine, operReadyList: listOperReady, operQueueList: listOperQueue, time: 0));
    // }
    // emit(state.copyWith(pageData: pageData, statusBtn: btn));
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

    List<PageItem> pageData = [];
    List<int> btn = [];
    for (var shiftsDistr in zShiftsDistributionList!) {
      List<OperatorOperations> listOperReady = [];
      List<OperatorOperations> listOperQueue = [];
      for (var operList in operatorOperationsList) {
        if (shiftsDistr.machine.id == operList.machine!.id) {
          if (operList.status.id == 6) listOperReady.add(operList);
          if (operList.status.id == 3) listOperQueue.add(operList);
        }
      }
      btn.add(0);
      pageData.add(PageItem(machine: shiftsDistr.machine, operReadyList: listOperReady, operQueueList: listOperQueue, time: 0));
    }
    emit(state.copyWith(pageData: pageData, statusBtn: btn));
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  void setReady(int id, int userId, int seconds, String comment, bool isStart){
    final operatorOperTable = OperatorOperationsTable();
    operatorOperTable.updateTimeStopAndReady(id, DateTime.now().millisecondsSinceEpoch, seconds);
    //записываем в монитор
    setMonitor(1, userId, comment, isStart);
    
    List<PageItem> list = [...state.pageData];
    //добавляем первую операцию в список готовых
    list[state.activePage].operReadyList.insert(0, state.pageData[state.activePage].operQueueList[0]);
    //удаляем первую операцию
    list[state.activePage].operQueueList.removeAt(0);
    emit(state.copyWith(pageData: list));
  }

  void setError(int id, int userId, int seconds, String comment, bool isStart){
    final operatorOperTable = OperatorOperationsTable();
    //записываем время остановки
    operatorOperTable.updateTimeStop(id, DateTime.now().millisecondsSinceEpoch);
    //записываем в мониторинг статус
    setMonitor(4, userId, comment, isStart);
  }

  Future<void> setMonitor(int status, int userid, String? comment, bool isStart) async{
    if ((comment == null) || (comment == '')) comment = 'none';
    final monitorTable = MonitoringMachineTable();
    if (isStart){
      final id = await monitorTable.insertToInt(MonitoringMachineDTO(id: 0, date: DateTime.now(), changeId: (DateTime.now().hour > 8) && ( DateTime.now().hour <= 20) ? 1 : 2, timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: status, userId: userid, machineId: state.pageData[state.activePage].machine.id, batchId: state.pageData[state.activePage].operQueueList.first.batch.id, comment: comment));
      emit(state.copyWith(monitorId: id));
    } else {
      await monitorTable.updateId(state.monitorId!, DateTime.now().millisecondsSinceEpoch);
    }
    setBtnStatus(status); 

    //нужно сохранить id мониторинга, чтобы записать конец
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