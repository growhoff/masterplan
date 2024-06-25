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
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import '../../../../../../data/repositories/supabase/dto/chief_operation_dto.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import '../../../../../../data/repositories/supabase/service/chief_operation_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class CubitWork extends Cubit<StateWork> {
  final List<ShiftsDistribution>? zShiftsDistributionList;
  final List<int> machineListId;
  final operatorOperationsTable = OperatorOperationsTable();
  final monitorTable = MonitoringMachineTable();
  late Timer periodicTimer;
  CubitWork(this.zShiftsDistributionList, this.machineListId) : super(const StateWork()) {
    //таймер
    periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final date = DateTime.now();
      if ((date.hour == 20 || date.hour == 8) && date.minute == 0) {
        emit(state.copyWith(exit: true));
        print('Завершил сессию');
      } else {emit(state.copyWith(exit: false));}
    });
    //стрим
    operatorOperationsTable.table.stream(primaryKey: ['id']).inFilter('machine_id', machineListId).listen((event) {
      }).onData((data)async {
          await getQuere(data);
      });
  }

@override
  Future<void> close() {
    periodicTimer.cancel();
    // operatorOperationsTable.
    return super.close();
  }

    Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {if (element['status_id'] == 3 || element['status_id'] == 6 || element['status_id'] == 7 || element['status_id'] == 8) listId.add(element['id']);}
    final quere = await operatorOperationsTable.selectListIdOrder(listId);
    List<OperatorOperations> operatorOperationsList = [];
      for (var operatorOper in quere) {
        final model = OperatorOperationsDTO.fromMap(operatorOper);
        operatorOperationsList.add(convertDto(model));
      }

    //группировка по оптимальной партии
    List<ItemOperOp> listB = [];
    var newMap = groupBy(operatorOperationsList, (el) => el.optimalPart);
    newMap.forEach((key, value) {
      List<OperatorOperations> list = [];
      List<int> listId = [];
      List<int> listChiefBatchId = [];
      List<int> listChiefOperationId = [];
      for (var element in value) {
        list.add(element);
        listId.add(element.id);
        listChiefBatchId.add(element.chiefBatchId!);
        listChiefOperationId.add(element.chiefOperationId!);
      }
      listB.add(ItemOperOp(
          idPath: key!,
          list: list,
          machineId: list.first.machine!.id,
          statusId: list.first.status.id,
          listId: listId,
          pause: list.first.pause,
          listChiefBatchId: listChiefBatchId,
          listChiefOperationId: listChiefOperationId,
          order: list.first.order!));
    });

    listB.sort((a, b) => a.order.compareTo(b.order));

    List<int> timeActive = [];
    List<PageItem> pageData = [];   
    List<int> statusBtn = [];
    List<bool> listStartBtn = [];
    List<bool> listStartTime = [];

    //проход по списку машин в сменах
    for (var shiftsDistr in zShiftsDistributionList!) {
      List<ItemOperOp> listOperReady = [];
      List<ItemOperOp> listOperQueue = [];
      ItemOperOp? operActive;
      //проход по опт. операциям
      for (var operPath in listB) {
        if (shiftsDistr.machine.id == operPath.machineId) {
          if (operPath.statusId == 6) listOperReady.add(operPath);
          if (operPath.statusId == 3) listOperQueue.add(operPath);
          if (operPath.statusId == 7) operActive = operPath;
        }
      }
      //активным ставим первый
      if (operActive == null && listOperQueue.isNotEmpty){
        operActive ??= listOperQueue.first;
        listOperQueue.removeAt(0);
      }
      //добавляем время в массив
      if (operActive == null){
        timeActive.add(0);
      } else {
        if (operActive.pause == null) {timeActive.add(0);}
        if (operActive.pause == true) {timeActive.add(operActive.list.first.timeworking!);}
        if (operActive.pause == false) {
          final date1 = DateTime.fromMillisecondsSinceEpoch(operActive.list.first.timestart!).toUtc();
          final date2 = DateTime.now().toUtc();
          final difference = (date2.difference(date1)).inSeconds;
          timeActive.add(difference);
      }
      }
      //выставление статусов относительно паузы
      if (operActive != null){
        if (operActive.pause == null){
          statusBtn.add(0);
          listStartBtn.add(false);
          listStartTime.add(false);
        } else if (operActive.pause == true){
          statusBtn.add(1);
          listStartBtn.add(true);
          listStartTime.add(false);
        } else {
          statusBtn.add(1);
          listStartBtn.add(false);
          listStartTime.add(true);
        }
      } else {
          statusBtn.add(0);
          listStartBtn.add(false);
          listStartTime.add(false);
      }
      //
      pageData.add(PageItem(machine: shiftsDistr.machine, operReadyList: listOperReady, operQueueList: listOperQueue, operActive: operActive));      
    }
    emit(state.copyWith(pageData: pageData, timeActive: timeActive, statusBtn: statusBtn, listStartBtn: listStartTime, listStartTime: listStartTime));
  }


  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }


  Future<void> setReady(ItemOperOp oper, int userId, int seconds, String comment, bool isStart)async{
    final quereMon = await monitorTable.selectIdMonitor(userId, state.pageData[state.activePage].machine.id, oper.list.first.batch.id, oper.idPath);
    final idMon = quereMon.first['id'];
    operatorOperationsTable.updateTimeStopAndReady(oper.idPath, DateTime.now().millisecondsSinceEpoch, seconds, userId);
    setStopMonitor(1, idMon);
    setIsStart(false);
//{переделать chiefOperationId}
    checkIsDetailReady(listChiefBatchId: oper.listChiefBatchId, listChiefOperationId: oper.listChiefOperationId);
  }

  Future<void> setBrak(ItemOperOp oper, int userId, int seconds, String comment, bool isStart)async{
    final quereMon = await monitorTable.selectIdMonitor(userId, state.pageData[state.activePage].machine.id, oper.list.first.batch.id, oper.idPath);
    final idMon = quereMon.first['id'];
    int count = state.count;
    List<int> listId5 = [];
    List<int> listId0 = [];
    for (var id in oper.listId) {
      if (count == 0) {listId0.add(id);}
        else{
          listId5.add(id);
          count --;
        }
    }
    operatorOperationsTable.updateTimeStopAndReadyCount(listId0, listId5, DateTime.now().millisecondsSinceEpoch, seconds, userId);

    //меняем статус по этим id в брак
        final chiefBatchTable = ChiefBatchTable();
          List<OperatorOperations> chOperId = oper.list.getRange(0, state.count).toList();
          List<int> chId = [];
          for (var e in chOperId) {
            chId.add(e.chiefBatchId!);
          }
        await chiefBatchTable.updateChiefBatchStatusToDefectList(chiefBatchId: chId);

    setStopMonitor(1, idMon);
    setIsStart(false);
  }


  // проверка на готовность детали
  Future<void> checkIsDetailReady({required List<int> listChiefBatchId, required List<int> listChiefOperationId})async
  {
    final chiefOperationTable = ChiefOperationTable();
    final chiefBatchTable = ChiefBatchTable();
    // получает последнюю операцию в детали
    final fetchedLastOperationInBatch = await chiefOperationTable.fetchLastOperationInBatchList(listChiefBatchId: listChiefBatchId);
    //создаём список с последними операциями и заносим их соотвественно
    List<ChiefOperationDto> listLast = [];
    int chifBatch = fetchedLastOperationInBatch.first['chief_batch_id'];
    for (var i = 0; i < fetchedLastOperationInBatch.length; i++) {
      final model = ChiefOperationDto.fromMap(fetchedLastOperationInBatch[i]);
      if (i == fetchedLastOperationInBatch.length - 1){
        listLast.add(ChiefOperationDto.fromMap(fetchedLastOperationInBatch[i]));
      }
      else{
        if (model.chiefBatchId != chifBatch){
        listLast.add(ChiefOperationDto.fromMap(fetchedLastOperationInBatch[i-1]));
        chifBatch = model.chiefBatchId;
      } 
      }

    }
    // final lastOperationInBatchDto = ChiefOperationDto.fromMap(fetchedLastOperationInBatch);
    List<int> listChiefBatchLast = [];
    for (var elLast in listLast) {
      for (var elChiefOper in listChiefOperationId) {
        if (elLast.id == elChiefOper) listChiefBatchLast.add(elLast.chiefBatchId);
      }
    }
    chiefBatchTable.updateChiefBatchStatusToReadyList(listChiefBatchId: listChiefBatchLast);
    // если id последней операции в детали равен chiefOperationId у операции из operator_operations, то меняет статус детали на готово(2)
    // if (lastOperationInBatchDto.id == chiefOperationId){
      
    // }
  }


  Future<void> setStartMonitor(int status, int userid, String? comment, int idPath) async{
    if (!state.listStartBtn[state.activePage]){
      if ((comment == null) || (comment == '')) comment = '-';
      final id = await monitorTable.insertToInt(MonitoringMachineDTO(id: 0, operationId: idPath, date: DateTime.now(), changeId: (DateTime.now().hour > 8) && ( DateTime.now().hour <= 20) ? 1 : 2, timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: 1, userId: userid, machineId: state.pageData[state.activePage].machine.id, batchId: state.pageData[state.activePage].operActive!.list.first.batch.id, comment: comment));
      List<bool> list = [...state.listStartBtn];
      list[state.activePage] = true;
      emit(state.copyWith(monitorId: id, listStartBtn: list));
    }
    setBtnStatus(status);
  }

  Future<void> setStopMonitor(int status, int id) async{
    await monitorTable.updateId(id, DateTime.now().millisecondsSinceEpoch);
    setBtnStatus(status); 
  }

  void setError(int userId, int seconds, String comment, bool isStart, int operId){
    operatorOperationsTable.updateTimeStop(operId, DateTime.now().millisecondsSinceEpoch, seconds);
    setMonitor(4, userId, comment, isStart, operId);
  }

  Future<void> setMonitor(int status, int userid, String? comment, bool isStart, int optPathOper) async{
    if ((comment == null) || (comment == '')) comment = '-';
    if (isStart){
      final id = await monitorTable.insertToInt(MonitoringMachineDTO(id: 0, operationId: optPathOper, date: DateTime.now(), changeId: (DateTime.now().hour > 8) && ( DateTime.now().hour <= 20) ? 1 : 2, timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: status, userId: userid, machineId: state.pageData[state.activePage].machine.id, batchId: state.pageData[state.activePage].operActive!.list.first.batch.id, comment: comment));
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
    List<bool> list = [...state.listStartBtn];
    list[state.activePage] = b;
    emit(state.copyWith(listStartBtn: list, count: 0));
  }

  OperatorOperations convertDto(OperatorOperationsDTO dto) {
    return OperatorOperations(
      id: dto.id,
      area: dto.area!,
      operation: dto.operation,
      stage: dto.stage!,
      timeplan: dto.timeplan ?? 0,
      pause: dto.pause,
      timeFirstStart: dto.timeFirstStart ?? 0,
      timestart: dto.timestart,
      timestop: dto.timestop,
      timeworking: dto.timeworking,
      chiefBatchId: dto.chiefBatchId,
      chiefOperationId: dto.chiefOperationId,
      optimalPart: dto.optimalPart,
      status: Status(id: dto.status.id, name: dto.status.name),
      batch: Batch(
          id: dto.batch.id,
          number: dto.batch.number,
          name: dto.batch.name,
          count: dto.batch.count,
          code: dto.batch.code,
          orderId: dto.batch.orderId,
          technology: dto.batch.technology,
          order: dto.batch.order,
          isready: dto.batch.isready),
      order: dto.order,
      machine: Machine(
          id: dto.machine!.id,
          inventoryNumber: dto.machine!.inventoryNumber,
          name: dto.machine!.name,
          areaId: dto.areaId),
      modific: dto.modific,
    );
  }

    Future<void> toggleBrak(String countStr)async{
      int count = int.parse(countStr);
      int length = state.pageData[state.activePage].operActive!.list.length;
      if (count > length) {count = length;}
      if (count < 0) {count = 0;}
      emit(state.copyWith(count: count));
    }
}