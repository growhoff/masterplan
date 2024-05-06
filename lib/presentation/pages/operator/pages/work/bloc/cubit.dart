import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
// import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
// import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';
import 'state.dart';

class CubitWork extends Cubit<StateWork> {
  final List<ShiftsDistribution>? zShiftsDistributionList;
  final List<OperatorOperations>? operatorOperationsList;

  CubitWork(this.zShiftsDistributionList, this.operatorOperationsList) : super(const StateWork()) {
    List<PageItem> pageData = [];
    List<int> btn = [];
    for (var shiftsDistr in zShiftsDistributionList!) {
      List<OperatorOperations> listOperReady = [];
      List<OperatorOperations> listOperQueue = [];
      for (var operList in operatorOperationsList!) {
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
      final id = await monitorTable.insertToInt(MonitoringMachineDTO(id: 0, timeStart: DateTime.now().millisecondsSinceEpoch, timeStop: 0, statusMachineId: status, userId: userid, machineId: state.pageData[state.activePage].machine.id, batchId: state.pageData[state.activePage].operQueueList.first.batch.id, comment: comment));
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
}