import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
import 'package:master_plan/domain/model/group_transfer.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/transfer.dart';
import 'package:master_plan/domain/usecase/button_status.dart';
import 'package:master_plan/domain/usecase/change_logic.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import 'state.dart';
import 'package:collection/collection.dart';
import 'dart:async';

class CubitWork extends Cubit<StateWork> {
  final List<ShiftsDistribution>? zShiftsDistributionList;
  final List<int> machineListId;
  final operatorOperationsTable = OperatorOperationsTable();
  final transferTable = TransferTable();
  final monitorTable = MonitoringMachineTable();
  final transferOperTable = TransferOperationsTable();
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

  Future<List<GroupTransfer>> getTransferList(List<int> listId)async{
    List<Transfer> list = [];
    final quereTransfer = await transferTable.selectOperationId(listId);
    for (var dto in quereTransfer) {
      final model = TransferDTO.fromMap(dto);
      list.add(ConvertDtoModel.convertToTransfer(model)); 
    }
    List<GroupTransfer> listGroup = [];
    var newMap = groupBy(list, (el) => el.operationId);
    newMap.forEach((key, value){
      listGroup.add(GroupTransfer(operId: key, listTransfer: value));
    });
    return listGroup;
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    Set<int> listOperationsId = {};
    for (var element in data!) {
      if (element['status_id'] == 3 ||
          element['status_id'] == 5 ||
          element['status_id'] == 6 ||
          element['status_id'] == 7 ||
          element['status_id'] == 8) {
            listId.add(element['id']); 
            listOperationsId.add(element['operation_id']);
          }
    }
    final quere = await operatorOperationsTable.selectListIdOrder(listId);
    final List<GroupTransfer> listGroup = await getTransferList(listOperationsId.toList());
    List<OperatorOperations> operatorOperationsList = [];
    for (var operatorOper in quere) {
      final model = OperatorOperationsDTO.fromMap(operatorOper);
      List<Transfer> listTrans = [];
      for (var grItem in listGroup) {
        if (model.operationId == grItem.operId) listTrans.addAll(grItem.listTransfer);
      }
      operatorOperationsList.add(convertDto(model, listTransfer: listTrans));
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
          staffId: list.first.user?.id,
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
      List<ItemOperOp> listBrak = [];
      ItemOperOp? operActive;
      //проход по опт. операциям
      for (var operPath in listB) {
        if (shiftsDistr.machine.id == operPath.machineId) {
          if (operPath.statusId == 5 && operPath.staffId == userIds) listBrak.add(operPath);
          if (operPath.statusId == 6 && operPath.staffId == userIds) listOperReady.add(operPath);
          if (operPath.statusId == 3) listOperQueue.add(operPath);
          if (operPath.statusId == 7) operActive = operPath;
        }
      }
      //активным ставим первый
      if (operActive == null && listOperQueue.isNotEmpty) {
        operActive ??= listOperQueue.first;
        listOperQueue.removeAt(0);
        print('Need id oper: ${operActive.list.first.operation.id}');
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
            final quereTransOper = await transferOperTable.selectOptPathLast(operActive.idPath);
            TransferOperationsDTO? transferOper;
            if (quereTransOper.isNotEmpty) transferOper = TransferOperationsDTO.fromMap(quereTransOper.last);
            statusBtn.add('Простой');
            listStartBtn.add(true);
            listStartTime.add(false);
            timeActive.add(transferOper != null ? transferOper.timeworking ?? 0 :  operActive.list.first.timeworking!);
            if (quereTransOper.isNotEmpty) emit(state.copyWith(activeTransfer: transferOper!.order));
          } else {
            print('pause == false/ btn = Простой/ btnstart = false/ time = true');
            final quereTransOper = await transferOperTable.selectOptPathLast(operActive.idPath);
            TransferOperationsDTO? transferOper;
            if (quereTransOper.isNotEmpty) transferOper = TransferOperationsDTO.fromMap(quereTransOper.last);
            statusBtn.add('В работе');
            listStartBtn.add(false);
            listStartTime.add(true);
            final difference = getDifferenceSec(transferOper != null ? transferOper.timestart! : operActive.list.first.timestart!);
            timeActive.add(difference);
            if (quereTransOper.isNotEmpty) emit(state.copyWith(activeTransfer: transferOper!.order));
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

      pageData.add(PageItem(
          machine: shiftsDistr.machine,
          operReadyList: listOperReady,
          operQueueList: listOperQueue,
          operBrakList: listBrak,
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

  Future<void> setReady(ItemOperOp oper, int seconds, String comment) async {
    getMonitoringIdAndSetMonitor(oper, comment);
    await operatorOperationsTable.updateTimeStopAndReady(oper.idPath, DateTime.now().millisecondsSinceEpoch, seconds, userIds, comment);
    setStateStart(false);
    // checkIsDetailReady(listChiefBatchId: oper.listChiefBatchId, listChiefOperationId: oper.listChiefOperationId);
  }
   Future<void> setReadyTransfer(ItemOperOp oper, int seconds, String comment) async {
    setStateStart(false);
    setBtnStatus('Все');
    await transferOperTable.updateTimeStopAndReady(oper.idPath, DateTime.now().millisecondsSinceEpoch, seconds, userIds, oper.list.first.listTransfer![state.activeTransfer].id);
    if (oper.list.first.listTransfer!.length - 1 == state.activeTransfer){
      emit(state.copyWith(activeTransfer: 0, newTransfer: true));
      int secondsOper = await transferOperTable.selectOptPathTimeWork(oper.idPath);
      setReady(oper, secondsOper, comment);
    } else {
      emit(state.copyWith(activeTransfer: state.activeTransfer + 1, newTransfer: true));
    }
  }

  Future<void> setBrak(ItemOperOp oper, int seconds, String comment) async {
    getMonitoringIdAndSetMonitor(oper, comment);
    setStatusOperationBrak(oper.listId, seconds);
    setStatusBatch(oper.list);
    setStateStart(false);
  }

  void toggleNewTransfer(){
    emit(state.copyWith(newTransfer: false));
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
          changeId: ChangeLogic(count: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.count, firstTime: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.timeFirst).getChange(),
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
    setBtnStatus(status);
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
      await ChangeLogic(count: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.count, firstTime: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.timeFirst)
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
        await ChangeLogic(count: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.count, firstTime: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.timeFirst)
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
        changeId: ChangeLogic(count: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.count, firstTime: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.timeFirst).getChange(),
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
        changeId: ChangeLogic(count: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.count, firstTime: zShiftsDistributionList![state.activePage].machine.shiftSchedule!.timeFirst).getChange(),
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

  OperatorOperations convertDto(OperatorOperationsDTO dto, {required List<Transfer> listTransfer}) {
    return ConvertDtoModel.convertToOperatorOperations(dto, listTransfer: listTransfer);
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

  String getButtonName(List<Transfer>? listTransfer, String statusBtn){
    if (listTransfer != null){
        switch (statusBtn){
        case 'Все': if (listTransfer.isNotEmpty) {return 'Начать переход';} else {return 'Начать обработку';}
        case 'В работе': return 'Пауза';
        default: return 'Продолжить';
      }
    } else {
      switch (statusBtn){
      case 'Все': return 'Начать обработку';
      case 'В работе': return 'Пауза';
      default: return 'Продолжить';
    }
    }
  }
}
