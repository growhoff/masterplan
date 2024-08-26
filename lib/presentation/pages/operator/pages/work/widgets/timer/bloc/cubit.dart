import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_operations_table.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/usecase/change_logic.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'state.dart';

class CubitTimer extends Cubit<StateTimer> {

  final List<int> timeActive;
  final List<bool> listStartTime;
  final operatorOperTable = OperatorOperationsTable();
  final transferOperTable = TransferOperationsTable();
  CubitTimer(this.timeActive, this.listStartTime) : super(const StateTimer()){
    init();
  }

  void init(){
      List<int> listTick = [];
      List<String> listRes = [];
      for (var tick in timeActive) {
        if (tick == 0){
          listTick.add(0);
          listRes.add('00:00:00');
        } else {
          listTick.add(tick);
          listRes.add(convertTime(tick));
        }
      }
      emit(state.copyWith(listTick: listTick, listState: listStartTime, listRes: listRes));
      Timer.periodic(const Duration(seconds: 1), (timer) {
      List<int> listTick = [...state.listTick];
      List<String> listRes = [...state.listRes];
      for (var i = 0; i < state.listTick.length; i++) {
        if (state.listState[i]) {
          listTick[i] ++; 
          listRes[i] = convertTime(listTick[i]);
        }
      }
      emit(state.copyWith(listTick: listTick, listRes: listRes));
    });
  }

  Future<void> firstStart(int index, ItemOperOp operActive)async{
    List<bool> listState = [...state.listState];
      listState[index] = true;
      await operatorOperTable.setFirstTimeStart(operActive.idPath, DateTime.now().millisecondsSinceEpoch);
      await updateStatusBatchChiefBatchStage(operActive);      
    emit(state.copyWith(listState: listState));
  }

  Future<void> updateStatusBatchChiefBatchStage(ItemOperOp operActive)async{
      List<int> listIdBatch = [];
      List<int> listIdChiefBatch = [];
      List<int> listIdOrder = [];
      for (var e in operActive.list) {
        listIdBatch.add(e.batch.id);
        listIdChiefBatch.add(e.chiefBatchId!);
        listIdOrder.add(e.batch.orderId!);
      }
      await setBatchStatus(listIdBatch);
      await setChiefBatchStatus(listIdChiefBatch);
      await setDistribStageStatus(operActive.list);
      await setOrderBatchStatus(listIdOrder);
  }

  Future<void> setBatchStatus(List<int> listIdBatch)async{
    final batchTable = BatchTable();
    await batchTable.updateStatusJob(listIdBatch);
  }

  Future<void> setChiefBatchStatus(List<int> listIdCiefBatch)async{
    final chiefBatchTable = ChiefBatchTable();
    await chiefBatchTable.updateStatusJob(listIdCiefBatch);
  }

  Future<void> setDistribStageStatus(List<OperatorOperations> list)async{
    final distribStageTable = DistributionStageTable();
    for (var e in list) {
      await distribStageTable.updateStatusJob(e.stage.id, e.chiefBatchId!);
    }
  }

  Future<void> setOrderBatchStatus(List<int> listIdOrder)async{
    final orderTable = OrderTable();
    await orderTable.updateStatusJob(listIdOrder);
  }

  void firstStartTransfer(ItemOperOp operActive, int machineId, int staffId, int activeTransfer, int order){
      transferOperTable.insertDto(TransferOperationsDTO(id: 0, operatorOperationId: operActive.list.first.id, order: order, transferId: operActive.list.first.listTransfer?[activeTransfer].id, batchId: operActive.list.first.batch.id, operationId: operActive.list.first.operation.id, optPath: operActive.idPath, pause: false, timeFirstStart: DateTime.now().millisecondsSinceEpoch, timestart: DateTime.now().millisecondsSinceEpoch, timestop: 0, timeworking: 0, machineId: machineId, staffId: staffId));
  }
//
  Future<void> startOrStop(int index, bool isStart, int idOptPath, int userId, int machineId, int batchId, int firstTimeBatch)async{
    final monitorTable = MonitoringMachineTable();
    List<bool> listState = [...state.listState];
    if (isStart){

      final lastStatusMap = await monitorTable.selectStatusLastMachine(machineId);
      if (lastStatusMap != null){
        final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
        await monitorTable.updateId(dtoLast.id, DateTime.now().millisecondsSinceEpoch);
      }
      await monitorTable.insert(MonitoringMachineDTO(id: 0, operationId: idOptPath, date: DateTime.now(), changeId: ChangeLogic(count: 2, firstTime: 8).getChange(), timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: 1, userId: userId, machineId: machineId, batchId: batchId, comment: 'Продолжение обработки', firstStartBatch: firstTimeBatch));
      
      listState[index] = true;
      await operatorOperTable.updateTimeStart(idOptPath, DateTime.now().millisecondsSinceEpoch, userId);
    }
    else {
      
      final lastStatusMap = await monitorTable.selectStatusLastMachine(machineId);
      if (lastStatusMap != null){
        final dtoLast = MonitoringMachineDTO.fromMap(lastStatusMap);
        await monitorTable.updateId(dtoLast.id, DateTime.now().millisecondsSinceEpoch);
      }
      await monitorTable.insert(getMonitoringStatus2(userId, machineId));
      

      listState[index] = false;
      //
      final quereOper = await operatorOperTable.selectOptPath(idOptPath);
      final modelOper = OperatorOperationsDTO.fromMap(quereOper);
      int timeWork = modelOper.timeworking ?? 0;
      int? timeStart = modelOper.timestart;
      int seconds = TimeConverter().getTimeWorking(timeStart!, DateTime.now().millisecondsSinceEpoch);
      int tick = timeWork + seconds;
      await operatorOperTable.updateTimeStop(modelOper.optimalPart!, DateTime.now().millisecondsSinceEpoch, tick);
      //
      // await operatorOperTable.updateTimeStop(idOptPath, DateTime.now().millisecondsSinceEpoch, state.listTick[index]);
    }
    emit(state.copyWith(listState: listState));
  }

    Future<void> startOrStopTransfer(bool isStart, ItemOperOp operActive, int userId, int indexTransfer)async{
    final transferTable = TransferOperationsTable();
    if (isStart){
      await transferTable.updateTimeStart(operActive.idPath, DateTime.now().millisecondsSinceEpoch, userId, operActive.list.first.listTransfer![indexTransfer].id);
    }
    else {
      final quereTrans = await transferTable.selectOptPath(operActive.idPath, operActive.list.first.listTransfer![indexTransfer].id);
      final modelTrans = TransferOperationsDTO.fromMap(quereTrans);
      int timeWork = modelTrans.timeworking ?? 0;
      int? timeStart = modelTrans.timestart;
      int seconds = TimeConverter().getTimeWorking(timeStart!, DateTime.now().millisecondsSinceEpoch);
      int tick = timeWork + seconds;
      await transferTable.updateTimeStop(operActive.idPath, DateTime.now().millisecondsSinceEpoch, tick, operActive.list.first.listTransfer![indexTransfer].id);
    }
  }

    MonitoringMachineDTO getMonitoringStatus2(int userId, int machineId){
    return MonitoringMachineDTO(
          id: 0,
          operationId: -1,
          date: DateTime.now(),
          changeId: ChangeLogic(count: 2, firstTime: 8).getChange(),
          timeStart: DateTime.now().millisecondsSinceEpoch,
          timeStop: 0,
          statusMachineId: 2,
          userId: userId,
          machineId: machineId,
          batchId: null,
          comment: '-');
  }

  void refresh(index) {
    List<bool> listState = [...state.listState];
    List<int> listTick = [...state.listTick];
    List<String> listRes = [...state.listRes];
    listState[index] = false;
    listTick[index] = 0;
    listRes[index] = '00:00:00';
    emit(state.copyWith(listState: listState, listTick: listTick, listRes: listRes));
  }

  String convertTime(int tick){
    Duration duration = Duration(seconds: tick);
    final h = duration.inHours;
    final m = duration.inMinutes - duration.inHours * 60;
    final s = duration.inSeconds - duration.inMinutes * 60;
    return '${convertXX(h)}:${convertXX(m)}:${convertXX(s)}';
  }

  String convertXX(int num){
    if (num>=10) {return '$num';}
    else {return '0$num';}
  }

//
  void refreshAndStartStop(int index, bool isStart){
    //обнуляем нужный таймер
    List<bool> listState = [...state.listState];
    List<int> listTick = [...state.listTick];
    List<String> listRes = [...state.listRes];
    listState[index] = false;
    listTick[index] = 0;
    listRes[index] = '00:00:00';

    if (isStart){
      listState[index] = true;
      // operatorOperTable.updateTimeStart(id, DateTime.now().millisecondsSinceEpoch);
    }
    else {
      listState[index] = false;
      // operatorOperTable.updateTimeStop(id, DateTime.now().millisecondsSinceEpoch);
    }
    emit(state.copyWith(listState: listState, listTick: listTick, listRes: listRes));
  }
}