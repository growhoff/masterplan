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
import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/domain/usecase/change_logic.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';

// import '../../../../../../data/repositories/supabase/dto/chief_operation_dto.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';

// import '../../../../../../data/repositories/supabase/service/chief_operation_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class CubitWork extends Cubit<StateWork> {
  final List<ShiftsDistribution>? zShiftsDistributionList;
  final List<int> machineListId;
  final operatorOperationsTable = OperatorOperationsTable();
  final monitorTable = MonitoringMachineTable();
  late Timer periodicTimer;
  final int userIds;

  CubitWork(this.zShiftsDistributionList, this.machineListId, this.userIds)
      : super(const StateWork()) {
    // getMonitorStart();
    //таймер
    periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final date = DateTime.now();
      if ((date.hour == 20 || date.hour == 8) && date.minute == 0) {
        emit(state.copyWith(exit: true));
        print('Завершил сессию');
      } else {
        emit(state.copyWith(exit: false));
      }
    });

    //стрим
    operatorOperationsTable.table
        .stream(primaryKey: ['id'])
        .inFilter('machine_id', machineListId)
        .listen((event) {})
        .onData((data) async {
          await getQuere(data);
        });
  }

  @override
  Future<void> close() {
    periodicTimer.cancel();
    // operatorOperationsTable.
    return super.close();
  }

  // Future<void> getMonitorStart()async{
  //   for (var machineId in machineListId) {
  //     final lastStatusMap = await monitorTable.selectStatusLastMachine(machineId);
  //     final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
  //     if ((dtoLast.statusMachine!.id == 4) && (dtoLast.timeStop == 0)){print('Поломка (id станка: $machineId)');}
  //   }
  // }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    for (var element in data!) {
      if (element['status_id'] == 3 ||
          element['status_id'] == 6 ||
          element['status_id'] == 7 ||
          element['status_id'] == 8) listId.add(element['id']);
    }
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
    List<String> statusBtn = [];
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
      if (operActive == null && listOperQueue.isNotEmpty) {
        operActive ??= listOperQueue.first;
        listOperQueue.removeAt(0);
      }

      final dtoL = await selectMonitorStatus(shiftsDistr.machine.id);
      if (dtoL != null){
        final status = dtoL.statusMachine!.id;
        if (status == 3 || status == 4 || status == 5 || status == 6 || status == 7 || status == 9){
          print('operActive == null/ btn = ${dtoL.statusMachine!.name}/ btnstart = false/ time = true');
          statusBtn.add(ButtonStatus().getStringStatus(status));
          listStartBtn.add(false);
          listStartTime.add(true);
          final difference = getDifferenceSec(dtoL.timeStart);
          timeActive.add(difference);
          emit(state.copyWith(monitorId: dtoL.id));
        } else {
          if (operActive != null) {
          if (operActive.pause == null) {
            print('pause == null/ btn = Все/ btnstart = false/ time = false');
            statusBtn.add('Все');
            listStartBtn.add(false);
            listStartTime.add(false);
            timeActive.add(0);
          } else if (operActive.pause == true) {
            print('pause == true/ btn = Простой/ btnstart = true/ time = false');
            statusBtn.add('Простой');
            listStartBtn.add(true);
            listStartTime.add(false);
            timeActive.add(operActive.list.first.timeworking!);
          } else {
            print('pause == false/ btn = Простой/ btnstart = false/ time = true');
            statusBtn.add('В работе');
            listStartBtn.add(false);
            listStartTime.add(true);
            final difference = getDifferenceSec(operActive.list.first.timestart!);
            timeActive.add(difference);
          }
        } else {
          statusBtn.add('Все');
          listStartBtn.add(false);
          listStartTime.add(false);
          timeActive.add(0);
        }
        }
      } else {
        if (operActive != null) {
          if (operActive.pause == null) {
            print('pause == null/ btn = Все/ btnstart = false/ time = false');
            statusBtn.add('Все');
            listStartBtn.add(false);
            listStartTime.add(false);
            timeActive.add(0);
          } else if (operActive.pause == true) {
            print('pause == true/ btn = Простой/ btnstart = true/ time = false');
            statusBtn.add('Простой');
            listStartBtn.add(true);
            listStartTime.add(false);
            timeActive.add(operActive.list.first.timeworking!);
          } else {
            print('pause == false/ btn = Простой/ btnstart = false/ time = true');
            statusBtn.add('В работе');
            listStartBtn.add(false);
            listStartTime.add(true);
            final difference = getDifferenceSec(operActive.list.first.timestart!);
            timeActive.add(difference);
          }
        } else {
          statusBtn.add('Все');
          listStartBtn.add(false);
          listStartTime.add(false);
          timeActive.add(0);
        }
      }
      //добавляем время в массив
      //выставление статусов относительно паузы
      // if (operActive != null) {
      //   if (operActive.pause == null) {
      //     print('pause == null/ btn = Все/ btnstart = false/ time = false');
      //     statusBtn.add('Все');
      //     listStartBtn.add(false);
      //     listStartTime.add(false);
      //     timeActive.add(0);
      //   } else if (operActive.pause == true) {
      //     print('pause == true/ btn = Простой/ btnstart = true/ time = false');
      //     statusBtn.add('Простой');
      //     listStartBtn.add(true);
      //     listStartTime.add(false);
      //     timeActive.add(operActive.list.first.timeworking!);
      //   } else {
      //     print('pause == false/ btn = Простой/ btnstart = false/ time = true');
      //     statusBtn.add('В работе');
      //     listStartBtn.add(false);
      //     listStartTime.add(true);
      //     final difference = getDifferenceSec(operActive.list.first.timestart!);
      //     timeActive.add(difference);
      //   }
      // } else {
      //   // ??
      //   // final lastStatusMap = await monitorTable.selectStatusLastMachine(shiftsDistr.machine.id);
      //   // if (lastStatusMap != null) {
      //     // final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
      //     // if ((dtoLast.statusMachine!.id == 4) && (dtoLast.timeStop == 0)) {
      //     //   print('operActive == null/ btn = Поломка/ btnstart = false/ time = true');
      //     //   statusBtn.add('Поломка');
      //     //   listStartBtn.add(false);
      //     //   listStartTime.add(true);
      //     //   final difference = getDifferenceSec(dtoLast.timeStart);
      //     //   timeActive.add(difference);
      //     // } else {
      //     //   print('operActive == null/ btn = Все/ btnstart = false/ time = false');
      //     //   statusBtn.add('Все');
      //     //   listStartBtn.add(false);
      //     //   listStartTime.add(false);
      //     //   timeActive.add(0);
      //     // }
      //   // } else {
      //   //   statusBtn.add('Все');
      //   //   listStartBtn.add(false);
      //   //   listStartTime.add(false);
      //   //   timeActive.add(0);
      //   // }
      // }
      //
      pageData.add(PageItem(
          machine: shiftsDistr.machine,
          operReadyList: listOperReady,
          operQueueList: listOperQueue,
          operActive: operActive));
    }
    emit(state.copyWith(
        pageData: pageData,
        timeActive: timeActive,
        statusBtn: statusBtn,
        listStartBtn: listStartTime,
        listStartTime: listStartTime));
  }


  Future<MonitoringMachineDTO?> selectMonitorStatus(int idMachine)async{
    final lastStatusMap = await monitorTable.selectStatusLastMachine(idMachine);
    if (lastStatusMap != null){
      final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
      if (dtoLast.timeStop == 0) {return dtoLast;}
      else {return null;}
    } else {return null;}
  }

  int getDifferenceSec(int time){
    final date1 = DateTime.fromMillisecondsSinceEpoch(time).toUtc();
    final date2 = DateTime.now().toUtc();
    final difference = (date2.difference(date1)).inSeconds;
    return difference;
  }


  void setActivePage(int index) {
    emit(state.copyWith(activePage: index));
  }

  Future<void> setReady(
      ItemOperOp oper, int seconds, String comment, bool isStart) async {
    getMonitoringIdAndSetMonitor(oper, comment);
    await operatorOperationsTable.updateTimeStopAndReady(oper.idPath,
        DateTime.now().millisecondsSinceEpoch, seconds, userIds, comment);
    setStateStart(false);
    // checkIsDetailReady(listChiefBatchId: oper.listChiefBatchId, listChiefOperationId: oper.listChiefOperationId);
  }

  Future<void> setBrak(
      ItemOperOp oper, int seconds, String comment, bool isStart) async {
    getMonitoringIdAndSetMonitor(oper, comment);
    setStatusOperationBrak(oper.listId, seconds);
    setStatusBatch(oper.list);
    setStateStart(false);
  }

  Future<void> getMonitoringIdAndSetMonitor(
      ItemOperOp oper, String comment) async {
    final int statusLast = await setLastStatusReady(oper.idPath, comment);
    final quereMon = await monitorTable.selectIdMonitor(
        state.pageData[state.activePage].machine.id,
        oper.list.first.batch.id,
        oper.idPath);
    final model = MonitoringMachineDTO.fromMap(quereMon.last);
    if (model.timeStop == 0) {
      await monitorTable.updateIdComment(
          model.id, DateTime.now().millisecondsSinceEpoch, comment);
      // await ChangeLogic(count: 2, firstTime: 8).setDateNext(model.timeStart, model, userIds, oper.idPath);
    } else {
      print('ошибка.пустое значение');
    }
    // late MonitoringMachineDTO model;
    // for (var element in quereMon) {
    //   final model1 = MonitoringMachineDTO.fromMap(element);
    //   if (model1.timeStop == 0) model = model1;
    // }

    if (statusLast != 2) await monitorTable.insert(getMonitoringStatus2());
    setBtnStatus('Все');
  }

  Future<void> setStatusOperationBrak(List<int> listId, int seconds) async {
    int count = state.count;
    List<int> listId5 = [];
    List<int> listId0 = [];
    for (var id in listId) {
      if (count == 0) {
        listId0.add(id);
      } else {
        listId5.add(id);
        count--;
      }
    }
    await operatorOperationsTable.updateTimeStopAndReadyCount(listId0, listId5,
        DateTime.now().millisecondsSinceEpoch, seconds, userIds);
  }

  Future<void> setStatusBatch(List<OperatorOperations> list) async {
    //меняем статус по id в брак
    final chiefBatchTable = ChiefBatchTable();
    List<OperatorOperations> chOperId = list.getRange(0, state.count).toList();
    List<int> chId = [];
    for (var e in chOperId) {
      chId.add(e.chiefBatchId!);
    }
    await chiefBatchTable.updateChiefBatchStatusToDefectList(
        chiefBatchId: chId);
  }

  Future<void> setStartMonitor(
      String status, int userid, String? comment, int idPath) async {
    if (!state.listStartBtn[state.activePage]) {
      if ((comment == null) || (comment == '')) comment = '-';
      //прежний расчёт смены
      // (DateTime.now().hour > 8) && ( DateTime.now().hour <= 20) ? 1 : 2
      await setLastStatus(idPath, comment);

      final id = await monitorTable.insertAndGetId(MonitoringMachineDTO(
          id: 0,
          firstStartBatch: DateTime.now().millisecondsSinceEpoch,
          operationId: idPath,
          date: DateTime.now(),
          changeId: ChangeLogic(count: 2, firstTime: 8).getChange(),
          timeStart: DateTime.now().millisecondsSinceEpoch,
          timeStop: 0,
          statusMachineId: 1,
          userId: userid,
          machineId: state.pageData[state.activePage].machine.id,
          batchId:
              state.pageData[state.activePage].operActive!.list.first.batch.id,
          comment: comment));
      List<bool> list = [...state.listStartBtn];
      list[state.activePage] = true;
      emit(state.copyWith(monitorId: id, listStartBtn: list));
    }
    // setBtnStatus(status);
  }

  Future<void> setMonitor(
      String status, String comment, bool isStart, int optPathOper) async {
    if (isStart) {
      await setLastStatus(optPathOper, '-');

      final id = await monitorTable.insertAndGetId(
          getMonitoringMachineDTOMonitor(status, '-', optPathOper));
      emit(state.copyWith(monitorId: id));
    } else {
      await monitorTable.updateIdComment(
          state.monitorId!, DateTime.now().millisecondsSinceEpoch, comment);
      //ставим статус простоя без окончания
      await monitorTable.insert(getMonitoringStatus2());
    }
    setBtnStatus(status);
  }

  Future<void> setLastStatus(int optPathOper, String comment) async {
    print('id machine: ${state.pageData[state.activePage].machine.id}');
    final lastStatusMap = await monitorTable
        .selectStatusLastMachine(state.pageData[state.activePage].machine.id);
    if (lastStatusMap != null) {
      final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
      print(lastStatusMap.toString());
      await ChangeLogic(count: 2, firstTime: 8)
          .setDateNextSt2(dtoLast, userIds, optPathOper, comment);
    }
  }

  Future<int> setLastStatusReady(int optPathOper, String comment) async {
    print('id machine: ${state.pageData[state.activePage].machine.id}');
    final lastStatusMap = await monitorTable
        .selectStatusLastMachine(state.pageData[state.activePage].machine.id);
    if (lastStatusMap != null) {
      final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
      print(lastStatusMap.toString());
      if (dtoLast.statusMachineId == 2) {
        return 2;
      } else {
        await ChangeLogic(count: 2, firstTime: 8)
            .setDateNextSt2(dtoLast, userIds, optPathOper, comment);
        return 0;
      }
    } else {
      return 0;
    }
  }

  MonitoringMachineDTO getMonitoringMachineDTOMonitor(
      String status, String comment, int optPathOper) {
    int idStatus = ButtonStatus().getIdStatus(status);
    return MonitoringMachineDTO(
        id: 0,
        operationId: optPathOper,
        date: DateTime.now(),
        changeId: ChangeLogic(count: 2, firstTime: 8).getChange(),
        timeStart: DateTime.now().millisecondsSinceEpoch,
        timeStop: 0,
        statusMachineId: idStatus,
        userId: userIds,
        machineId: state.pageData[state.activePage].machine.id,
        batchId: null,
        // state.pageData[state.activePage].operActive!.list.first.batch.id,
        comment: comment);
  }

  MonitoringMachineDTO getMonitoringStatus2() {
    return MonitoringMachineDTO(
        id: 0,
        operationId: -1,
        date: DateTime.now(),
        changeId: ChangeLogic(count: 2, firstTime: 8).getChange(),
        timeStart: DateTime.now().millisecondsSinceEpoch,
        timeStop: 0,
        statusMachineId: 2,
        userId: userIds,
        machineId: state.pageData[state.activePage].machine.id,
        batchId: null,
        comment: '-');
  }

  void setBtnStatus(String status) {
    List<String> listRes = [...state.statusBtn];
    final index = state.activePage;
    String oldStatus = listRes[index];
    if ((status != 'В работе' && oldStatus != 'В работе') ||
        (status != 'Простой' &&
            oldStatus != 'Простой')) if (status == oldStatus) status = 'Все';

    listRes.removeAt(index);
    listRes.insert(index, status);
    emit(state.copyWith(statusBtn: listRes));
  }

  void setStateStart(bool b) {
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
          // order: dto.batch.order,
          isready: dto.batch.isready,
          numberRS: dto.batch.numberRS),
      order: dto.order,
      machine: Machine(
          id: dto.machine!.id,
          isActivated: dto.machine!.isActivated,
          inventoryNumber: dto.machine!.inventoryNumber,
          name: dto.machine!.name,
          areaId: dto.areaId),
      modific: dto.modific,
    );
  }

  Future<void> toggleBrak(String countStr) async {
    int count = int.parse(countStr);
    int length = state.pageData[state.activePage].operActive!.list.length;
    if (count > length) {
      count = length;
    }
    if (count < 0) {
      count = 0;
    }
    emit(state.copyWith(count: count));
  }

  void toggleVisibleStatus() {
    emit(state.copyWith(visibleStatus: !state.visibleStatus));
  }
}
