import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import '../model/item_machine.dart';
import '../model/item_machine_monitor.dart';
import 'state.dart';

class CubitMonitoringChM extends Cubit<StateMonitoringChM> {
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final tableMonitoring = MonitoringMachineTable();
  CubitMonitoringChM(this.machineList, this.machineIdList) : super(StateMonitoringChM(days: DateTime.now())){
    tableMonitoring.table.stream(primaryKey: ['id']).inFilter('machine_id', machineIdList).listen((event) {
      }).onData((data)async {
          await getQuere(data);
      });
  }

  
  Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {listId.add(element['id']);}
    List<MonitoringMachineDTO> queueList = [];
    if (listId.isNotEmpty) {
      final quere = await tableMonitoring.selectListId(listId, state.days);
      for (var item in quere) {
        queueList.add(MonitoringMachineDTO.fromMap(item));
      }
    }
    List<ItemMachineMonitorMaster> listMonitor = getListMonitor(queueList);
    emit(state.copyWith(listBar: listMonitor));
  }


  Future<void> setDate(DateTime date)async{
    final quere = await tableMonitoring.selectListIdMachine(machineIdList, date);
    List<MonitoringMachineDTO> queueList = [];
    for (var item in quere) {
      queueList.add(MonitoringMachineDTO.fromMap(item));
    }
    List<ItemMachineMonitorMaster> listMonitor = getListMonitor(queueList);
    emit(state.copyWith(days: date, listBar: listMonitor));
  }


  List<ItemMachineMonitorMaster> getListMonitor(List<MonitoringMachineDTO> queueList){
    List<ItemMachineMonitorMaster> listMonitor = [];
    for (var machine in machineList!) {
      List<ItemMachineStatus> listStatus = [];
      int allTime = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listStatus.add(converterToItemMachineStatus(queueItem));
          allTime += (queueItem.timeStop - queueItem.timeStart);
        }
      }
      listMonitor.add(ItemMachineMonitorMaster(machine: machine, listStatus: listStatus, allTime: allTime));
    }
    return listMonitor;
  }

  ItemMachineStatus converterToItemMachineStatus(MonitoringMachineDTO dto) {
    return ItemMachineStatus(
      timeStart: dto.timeStart,
      timeEnd: dto.timeStop,
      timeWorking: (dto.timeStop < dto.timeStart) ? 0 : TimeConverter().getTimeWorking(dto.timeStart, dto.timeStop),
      status: dto.statusMachine!,
      comment: dto.comment,
      changeId: dto.changeId,
    );
  }

  void setChange(int change){
    emit(state.copyWith(change: change));
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  String convertTimeZone(int time){
    return TimeConverter().convertMillisecondsSinceEpochToHHMMSS(time);
  }

  String differenceTime(int timeSec){
    return TimeConverter().convertTimeFromSecondsHHMMSS(timeSec);
  }  

Color convertColor(int status){
  Color colorStatus;
  switch (status) {
      case 1: colorStatus = Colors.green;
      case 2: colorStatus = Colors.yellow;
      case 3: colorStatus = Colors.red;
      case 4: colorStatus = Colors.orange;
      case 5: colorStatus = Colors.purple;
      case 6: colorStatus = Colors.blue;
      case 7: colorStatus = Colors.grey;
      case 8: colorStatus = Colors.white;
        break;
      default: colorStatus = Colors.white;
    }
    return colorStatus;
}
}
