import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
// import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';
import 'state.dart';

class CubitMonitoring extends Cubit<StateMonitoring> {
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final tableMonitoring = MonitoringMachineTable();
  CubitMonitoring(this.machineList, this.machineIdList)
      : super(StateMonitoring(days: DateTime.now())) {
    tableMonitoring.table
        .stream(primaryKey: ['id'])
        .inFilter('machine_id', machineIdList)
        .listen((event) {})
        .onData((data) async {
          await getQuere(data);
        });
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    List<int> listId = [];
    for (var element in data!) {
      listId.add(element['id']);
    }
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

  Future<void> setDate(DateTime date) async {
    final quere =
        await tableMonitoring.selectListIdMachine(machineIdList, date);
    List<MonitoringMachineDTO> queueList = [];
    for (var item in quere) {
      queueList.add(MonitoringMachineDTO.fromMap(item));
    }
    List<ItemMachineMonitorMaster> listMonitor = getListMonitor(queueList);
    emit(state.copyWith(days: date, listBar: listMonitor));
  }

  List<ItemMachineMonitorMaster> getListMonitor(
      List<MonitoringMachineDTO> queueList) {
    List<ItemMachineMonitorMaster> listMonitor = [];
    for (var machine in machineList!) {
      List<MonitoringMachine> listStatus = [];
      int allTime = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listStatus.add(converterToMonitorMachine(queueItem));
          allTime += (queueItem.timeStop - queueItem.timeStart);
        }
      }
      //если в последнем статусе конечного времени нуль, тогда в работе, иначе закончил
      bool statusActive = false;
      if (listStatus.isNotEmpty) statusActive = listStatus.last.timeStop == 0;
      //
      List<MonitoringMachine> listStatusNew;
      if (listStatus.isNotEmpty) {
        listStatusNew = convertTimeStatus(listStatus);
      } else {
        listStatusNew = [];
      }

      listMonitor.add(ItemMachineMonitorMaster(
          machine: machine,
          listStatus: listStatusNew,
          allTime: allTime,
          statusActive: statusActive));
    }
//добавление простоя
    // final dateNow = DateTime.now();
    // for (var element in listMonitor) {
    //   for (var status in element.listStatus) {

    //     if (status.changeId == 1){
    //       // status.timeStart
    //       //h = 8
    //       //h = 20
    //     }
    //     else{
    //       //h = 20
    //       //h = 24
    //       //h = 8
    //     }
    //   }
    // }

    return listMonitor;
  }

  List<MonitoringMachine> convertTimeStatus(List<MonitoringMachine> listStatus) {
    List<MonitoringMachine> newList = [];
    final date = DateTime.fromMillisecondsSinceEpoch(listStatus.first.timeStart);
    int dateFirst = DateTime(date.year, date.month, date.day, 8, 0, 0).toUtc().millisecondsSinceEpoch;
    int dateSecond = DateTime(date.year, date.month, date.day, 20, 0, 0).toUtc().millisecondsSinceEpoch;

    for (var i = 0; i < listStatus.length; i++) {
      if (i == listStatus.length - 1) {
        if (listStatus[i].timeStop < dateSecond) {
          newList.add(listStatus[i]);
          newList.add(createMonitoringMachine(listStatus[i].timeStop, dateSecond, date, listStatus[i].user!));
        }
        else{newList.add(listStatus[i]);}
      } else {
        if (dateFirst != listStatus[i].timeStart) {
          newList.add(createMonitoringMachine(dateFirst, listStatus[i].timeStart, date, listStatus[i].user!));
        }
        newList.add(listStatus[i]);
        dateFirst = listStatus[i].timeStop;
      }
    }
    return newList;
  }

  MonitoringMachine createMonitoringMachine(
      int timeStart, int timeStop, DateTime date, UserDTO user) {
    return MonitoringMachine(
        timeStart: timeStart + 1000,
        timeStop: timeStop,
        timeWorking: (timeStop < timeStart)
            ? 0
            : TimeConverter().getTimeWorking(timeStart, timeStop),
        changeId: 1,
        date: date,
        statusMachine: StatusMachineDTO(id: 2, name: 'Простой'),
        comment: '-',
        user: user
        );
  }

  // ItemMachineStatus converterToItemMachineStatus(MonitoringMachineDTO dto) {
  //   return ItemMachineStatus(
  //     timeStart: dto.timeStart,
  //     timeEnd: dto.timeStop,
  //     timeWorking: (dto.timeStop < dto.timeStart) ? 0 : TimeConverter().getTimeWorking(dto.timeStart, dto.timeStop),
  //     status: dto.statusMachine!,
  //     comment: dto.comment,
  //     changeId: dto.changeId,
  //   );
  // }

  MonitoringMachine converterToMonitorMachine(MonitoringMachineDTO dto) {
    return MonitoringMachine(
        id: dto.id,
        date: dto.date,
        timeStart: dto.timeStart,
        timeStop: dto.timeStop,
        timeWorking: (dto.timeStop < dto.timeStart)
            ? 0
            : TimeConverter().getTimeWorking(dto.timeStart, dto.timeStop),
        statusMachine: dto.statusMachine!,
        comment: dto.comment,
        changeId: dto.changeId,
        batch: dto.batch,
        user: dto.user,
        operationId: dto.operationId);
  }

  void setChange(int change) {
    emit(state.copyWith(change: change));
  }

  void setActivePage(int index) {
    emit(state.copyWith(activePage: index));
  }

  String convertTimeZone(int time) {
    if (time == 0) {
      return '-';
    } else {
      return TimeConverter().convertMillisecondsSinceEpochToHHMMSS(time);
    }
  }

  String differenceTime(int timeSec) {
    return TimeConverter().convertTimeFromSecondsHHMMSS(timeSec);
  }

  Color convertColor(int status) {
    Color colorStatus;
    switch (status) {
      case 1:
        colorStatus = Colors.green;
      case 2:
        colorStatus = Colors.yellow;
      case 3:
        colorStatus = Colors.red;
      case 4:
        colorStatus = Colors.orange;
      case 5:
        colorStatus = Colors.purple;
      case 6:
        colorStatus = Colors.blue;
      case 7:
        colorStatus = Colors.grey;
      case 8:
        colorStatus = Colors.white;
        break;
      default:
        colorStatus = Colors.white;
    }
    return colorStatus;
  }
}
