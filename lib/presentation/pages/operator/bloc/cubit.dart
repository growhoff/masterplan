import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_table.dart';
import 'package:master_plan/domain/usecase/change_logic.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'state.dart';
import 'dart:async';

class CubitOperator extends Cubit<StateOperator> {
  final tableShifts = ShiftsTable();
  final monitorTable = MonitoringMachineTable();
  final operatorOperationsTable = OperatorOperationsTable();
  final int userId;
  final List<int> machineIdList;
  final int change;
  late Timer periodicTimer;
  final  timeConverter =TimeConverter();
  CubitOperator(this.userId, this.machineIdList, this.change) : super(const StateOperator()){
    getListShifts();
    //таймер
    periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final date = DateTime.now();
      // if ((date.hour == 20 || date.hour == 8) && date.minute == 0) toggleBtn();
      bool isToggle = ChangeLogic(count: 2, firstTime: 8).getTimePeresmen(date);
      //7:55 пауза простой. 8:00 завершается смена отключен. пока не зайдет.
      if (isToggle) {
        emit(state.copyWith(isStart: false));
        setTable(userId);
      }
    });
  }

  Future<void> getListShifts()async{
    DateTime dateNow = DateTime.now();
    if (change == 2 && (dateNow.hour > 0 && dateNow.hour < 8)) dateNow = DateTime(dateNow.year, dateNow.month, dateNow.day - 1);
    final quere = await tableShifts.selectNew(userId, change, timeConverter.getStringDataYYMMDDdate(dateNow));
    if (quere.isNotEmpty){
      final model = ShiftsDTO.fromMap(quere.last);
      if (model.timeEnd == 0) emit(state.copyWith(idShifts: model.id, isStart: model.isActive));
    }
  }
  
  void toggleBtn(){
    emit(state.copyWith(isStart: !state.isStart));
    setTable(userId);
  }

  Future<void> setTable(int userId)async{
    DateTime dateNow = DateTime.now();
    if (change == 2 && (dateNow.hour > 0 && dateNow.hour < 8)) dateNow = DateTime(dateNow.year, dateNow.month, dateNow.day - 1);

    if (state.isStart){
      final id = await tableShifts.insertToInt(ShiftsDTO(id: 0, userId: userId, timeStart: DateTime.now().millisecondsSinceEpoch, timeEnd: 0, isActive: true, changeId: change, date: DateTime.now()));      
      //
      for (var idMachine in machineIdList) {
        final quereStatus = await monitorTable.selectStatus(timeConverter.getStringDataYYMMDDdate(dateNow), change, idMachine);
        if (quereStatus.isEmpty) {await writeMonitorStart(idMachine, dateNow);}
        //апдейт для каждой машины
        else {
          final model = MonitoringMachineDTO.fromMap(quereStatus.last);
          if (model.timeStop == 0) {
          await monitorTable.updateId(model.id, DateTime.now().millisecondsSinceEpoch);
          await monitorTable.insert(getMonitoringStatus2(idMachine, dateNow));}
        }
      }
      //
      emit(state.copyWith(idShifts: id));
    } else {
      await tableShifts.updateId(state.idShifts!,DateTime.now(), false);
      await writeMonitorEnd(dateNow);
    }
  }

  Future<void> writeMonitorStart(int idMachine, DateTime dateNow)async{
    final dateStartCh = TimeConverter().getDateTimeSinceEpoch(DateTime.now(),change == 1 ? 8 : 20, 0);
    //выгрузка по статусам 2 и 4 (статусы, которые могу пройти сквозь смену) при time_stop = 0
    final queerMonitoring = await monitorTable.selectListIdMachineChangeLastDay([idMachine]);
    if (queerMonitoring.isNotEmpty){
      //???
      final model = MonitoringMachineDTO.fromMap(queerMonitoring.last);
      final nowChange = ChangeLogic(count: 2, firstTime: 8).getChange();
      if (nowChange == model.changeId){
        if (model.statusMachineId == 8){
          await monitorTable.updateId(model.id, dateNow.millisecondsSinceEpoch);
          await monitorTable.insert(getMonitoringStatus2(idMachine, dateNow));
        }
      } else {
        final dateStopCh = TimeConverter().getDateTimeSinceEpoch(DateTime.now(),model.changeId == 1 ? 20 : 8, 0);
        // заканчиваем предыдущий по смене
        await monitorTable.updateId(model.id, dateStopCh);
        //начинаем новый по смене
        await monitorTable.insertAndGetId(MonitoringMachineDTO(id: -1, operationId: model.operationId, date: DateTime.now(), changeId: change, timeStart: dateStartCh, timeStop: 0, statusMachineId: model.statusMachineId, userId: userId, machineId: idMachine, batchId: model.batchId, comment: 'Перенос на другой день'));
      }
      } else {
      //Записываем статус Отключено и Простой
      await monitorTable.insertAndGetId(MonitoringMachineDTO(id: -1, operationId: -1, date: DateTime.now(), changeId: change, timeStart: dateStartCh, timeStop: DateTime.now().millisecondsSinceEpoch, statusMachineId: 8, userId: userId, machineId: idMachine, batchId: null, comment: 'Включение'));
      await monitorTable.insert(getMonitoringStatus2(idMachine, dateNow));
    }
  }

  Future<void> writeMonitorEnd(DateTime dateNow)async{
    // final dateStopCh = TimeConverter().getDateTimeSinceEpoch(DateTime.now(),change == 1 ? 20 : 8, change == 1 ? 0 : 1);   
    for (var idMachine in machineIdList) {
      bool isSetMonitor = true;
      final queerMonitoring = await monitorTable.selectListIdMachineChange([idMachine], change, timeConverter.getStringDataYYMMDDdate(dateNow), userId);
      print('writeMonitorEnd -- id machine: $idMachine');
      if (queerMonitoring.isNotEmpty){
        final model = MonitoringMachineDTO.fromMap(queerMonitoring.last);
        if (model.timeStop == 0){
          final statusId = model.statusMachine!.id;
          if (statusId == 2 || statusId == 3 || statusId == 5 || statusId == 6 || statusId == 7 || statusId == 9) {await monitorTable.updateId(model.id, dateNow.millisecondsSinceEpoch);}
          //подправить
          
          //
          //
          //
          // if (statusId == 2 || statusId == 4) {isSetMonitor = false;}
          if (statusId == 4) {isSetMonitor = false;}
          if (statusId == 1) {
            await monitorTable.updateId(model.id, dateNow.millisecondsSinceEpoch);
            await monitorTable.insert(getMonitoringStatus2(idMachine, dateNow));
            final quereOper = await operatorOperationsTable.selectIdMachine(idMachine);
            final modelOper = OperatorOperationsDTO.fromMap(quereOper);
            if (modelOper.pause == true) print('Конфликт статуса и паузы операции');
            int timeWork = modelOper.timeworking ?? 0;
            int? timeStart = modelOper.timestart;
            int seconds = TimeConverter().getTimeWorking(timeStart!, dateNow.millisecondsSinceEpoch);
            int tick = timeWork + seconds;
            await operatorOperationsTable.updateTimeStop(modelOper.optimalPart!, dateNow.millisecondsSinceEpoch, tick);
          }
          if (statusId == 8) {isSetMonitor = false;}
        }
        }
      if (isSetMonitor) await monitorTable.insertAndGetId(getMonitoringStatus8(idMachine, dateNow));
    }
  }

    MonitoringMachineDTO getMonitoringStatus2(int idMachine, DateTime time){
    return MonitoringMachineDTO(
          id: 0,
          operationId: -1,
          date: time,
          changeId: ChangeLogic(count: 2, firstTime: 8).getChange(),
          timeStart: time.millisecondsSinceEpoch,
          timeStop: 0,
          statusMachineId: 2,
          userId: userId,
          machineId: idMachine,
          batchId: null,
          comment: '-');
  }

  MonitoringMachineDTO getMonitoringStatus8(int idMachine, DateTime time){
    return MonitoringMachineDTO(id: -1, operationId: -1, date: time, changeId: change, timeStart: time.millisecondsSinceEpoch, timeStop: 0, statusMachineId: 8, userId: userId, machineId: idMachine, batchId: null, comment: 'Включение');
  }
}