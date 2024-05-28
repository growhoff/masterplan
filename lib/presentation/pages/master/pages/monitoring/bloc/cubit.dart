import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';
import 'state.dart';
import 'package:intl/intl.dart';

class CubitMonitoring extends Cubit<StateMonitoring> {
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final tableMonitoring = MonitoringMachineTable();
  CubitMonitoring(this.machineList, this.machineIdList) : super(StateMonitoring(days: DateTime.now())){
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
    
    List<ItemMachineMonitorMaster> listMonitor = [];
    for (var machine in machineList!) {
      List<ItemMachineStatus> listStatus = [];
      int allTime = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listStatus.add(ItemMachineStatus(
              timeStart: queueItem.timeStart,
              timeEnd: queueItem.timeStop,
              timeWorking: (queueItem.timeStop < queueItem.timeStart) ? 0 : getTimeWorking(queueItem.timeStart,queueItem.timeStop),
              status: queueItem.statusMachine!,
              comment: queueItem.comment,
              changeId: queueItem.changeId,
              ));
          allTime += (queueItem.timeStop - queueItem.timeStart);
        }
      }
      listMonitor.add(ItemMachineMonitorMaster(machine: machine, listStatus: listStatus, allTime: allTime));
    }
    emit(state.copyWith(listBar: listMonitor));
  }

  Future<void> setDate(DateTime date)async{
    final quere = await tableMonitoring.selectListIdMachine(machineIdList, date);
    List<MonitoringMachineDTO> queueList = [];
    for (var item in quere) {
      queueList.add(MonitoringMachineDTO.fromMap(item));
    }

    List<ItemMachineMonitorMaster> listMonitor = [];
    for (var machine in machineList!) {
      List<ItemMachineStatus> listStatus = [];
      int allTime = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listStatus.add(ItemMachineStatus(
              timeStart: queueItem.timeStart,
              timeEnd: queueItem.timeStop,
              timeWorking: (queueItem.timeStop < queueItem.timeStart) ? 0 : getTimeWorking(queueItem.timeStart,queueItem.timeStop),
              status: queueItem.statusMachine!,
              comment: queueItem.comment,
              changeId: queueItem.changeId,
              ));
          allTime += (queueItem.timeStop - queueItem.timeStart);
        }
      }
      listMonitor.add(ItemMachineMonitorMaster(machine: machine, listStatus: listStatus, allTime: allTime));
    }
    emit(state.copyWith(days: date, listBar: listMonitor));
  }

  void setChange(int change){
    emit(state.copyWith(change: change));
  }

  void setActivePage(int index){
    emit(state.copyWith(activePage: index));
  }

  String convertTime(int time){
    final h = time ~/ 60;
    final min = time - h * 60;
    final minStr = min > 9 ? '$min' : '0$min';
    final hStr = h > 9 ? '$h' : '0$h';
    return '$hStr:$minStr';
  }

  String convertTimeZone(int time){
    return DateFormat('hh:mm').format(DateTime.fromMillisecondsSinceEpoch(time)).toString();
  }

  String differenceTime(int timeMin){
    return convertTime(timeMin);
  }

  int getTimeWorking(int timeStart, int timeStop){
    final date1 = DateTime.fromMillisecondsSinceEpoch(timeStart).toUtc();
    final date2 = DateTime.fromMillisecondsSinceEpoch(timeStop).toUtc();
    final difference = (date2.difference(date1)).inMinutes;
    return difference;
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
