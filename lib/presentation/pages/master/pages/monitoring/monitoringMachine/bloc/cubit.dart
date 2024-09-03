import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/item_machine_monitor.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import 'package:master_plan/domain/usecase/machine_change.dart';
import 'package:master_plan/domain/usecase/monitoring_time_list.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'state.dart';

class CubitMonitoringMachine extends Cubit<StateMonitoringMachine> {
  final tableMonitoring = MonitoringMachineTable();
  TimeConverter timeConverter = TimeConverter();
  final List<AreaMachine> listAreaMachine;
  CubitMonitoringMachine( this.listAreaMachine): super(StateMonitoringMachine(days: DateTime.now())) {
    emit(state.copyWith(listAreaMachine: listAreaMachine));
    tableMonitoring.table
        .stream(primaryKey: ['id'])
        .inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine)
        .listen((event) {})
        .onData((data) async {
          await getQuere(data);
        });
  }

  Future<void> getQuere(List<Map<String, dynamic>>? data) async {
    emit(state.copyWith(isLoading: true));
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
    final listStatus = listMonitor[state.activeMachine].listStatus;
    final machine = listMonitor[state.activeMachine].machine;
    await getListMonitorChange(listStatus, machine);
    emit(state.copyWith(listMonitor: listMonitor, isLoading: false));
    setListItemDrop();
  }


  Future<void> setDate(DateTime date) async {
    emit(state.copyWith(days: date, isLoading: true));
    final quere = await tableMonitoring.selectListIdMachine(listAreaMachine[state.activeArea].idListMachine, date);
    List<MonitoringMachineDTO> queueList = [];
    for (var item in quere) {
      queueList.add(MonitoringMachineDTO.fromMap(item));
    }
    List<ItemMachineMonitorMaster> listMonitor = getListMonitor(queueList);
    final listStatus = listMonitor[state.activeMachine].listStatus;
    final machine = listMonitor[state.activeMachine].machine;
    await getListMonitorChange(listStatus, machine);
    emit(state.copyWith(listMonitor: listMonitor, isLoading: false));
  }


  Future<void> getListMonitorChange(List<MonitoringMachine> listStatus, Machine machine) async{
    List<MonitoringMachine> listStatusNew = [];
      if (listStatus.isNotEmpty) {
        listStatusNew = MonitoringTimeList(listTime: MachineChange.getListChange(listAreaMachine[state.activeArea].listMachine[state.activeMachine])).convertTimeStatusLast(listStatus, state.change, machine.shiftSchedule!.count);
      } else {
        final quere = await tableMonitoring.selectStatusLastMachineDate(machine.id, state.days);
        if (quere != null){
          final lastStatusItem = ConvertDtoModel.converterToMonitorMachine(MonitoringMachineDTO.fromMap(quere));
          listStatusNew = MonitoringTimeList(listTime: MachineChange.getListChange(listAreaMachine[state.activeArea].listMachine[state.activeMachine])).convertTimeStatusLastItem(lastStatusItem, state.change, state.days, machine.shiftSchedule!.count);
        } else {
          listStatusNew = MonitoringTimeList(listTime: MachineChange.getListChange(listAreaMachine[state.activeArea].listMachine[state.activeMachine])).convertTimeStatusNull(state.change, state.days, machine.shiftSchedule!.count);
        }
      }
      final statusActive = getActiveStatus(listStatusNew);
      emit(state.copyWith(statusActive: statusActive, listStatusActive: listStatusNew));

  }


  List<ItemMachineMonitorMaster> getListMonitor(List<MonitoringMachineDTO> queueList) {
    List<ItemMachineMonitorMaster> listMonitor = [];
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      List<MonitoringMachine> listStatus = [];
      int allTime = 0;
      for (var queueItem in queueList) {
        if (queueItem.machine!.id == machine.id) {
          listStatus.add(ConvertDtoModel.converterToMonitorMachine(queueItem));
          allTime += (queueItem.timeStop - queueItem.timeStart);
        }
      }
      listMonitor.add(ItemMachineMonitorMaster(machine: machine, listStatus: listStatus, allTime: allTime));
    }
    return listMonitor;
  }


  StatusMachineDTO getActiveStatus(List<MonitoringMachine> listStatus){
    StatusMachineDTO status = StatusMachineDTO(id: -1, name: '-');
    if (listStatus.isNotEmpty){
      List<MonitoringMachine> listStatusChange = [];
      for (var element in listStatus) {
        if (element.changeId == state.change) listStatusChange.add(element);
      }

      if (listStatusChange.isNotEmpty) {
        MonitoringMachine monitor = listStatusChange.last;
        if (timeConverter.getStringDataYYMMDDdate(monitor.date) == timeConverter.getStringDataYYMMDDdate(DateTime.now())) return monitor.statusMachine!;
      }
    }
    return status;
  }

  void setChange(int change) {
    emit(state.copyWith(change: change));
    final listStatus = state.listMonitor![state.activeMachine].listStatus;
    final machine = state.listMonitor![state.activeMachine].machine;
    getListMonitorChange(listStatus, machine);
  }

  // void setActivePage(int index) {
  //   final listStatus = state.listMonitor![index].listStatus;
  //   getListMonitorChange(listStatus);
  //   emit(state.copyWith(activePage: index));
  // }

    void setActiveMachine(int index) {
    final listStatus = state.listMonitor![index].listStatus;
    final machine = state.listMonitor![index].machine;
    getListMonitorChange(listStatus, machine);
    emit(state.copyWith(activeMachine: index, change: 1));
    setListItemDrop();
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, activeMachine: 0, listMonitor: []));
    final quere = await tableMonitoring.selectListIdMachine(state.listAreaMachine[index].idListMachine, state.days);
    await getQuere(quere);
  }

  void setListItemDrop() {
    List<NameIndex> listItemArea = [];
    List<NameIndex> listItemMachine = [];
    if (state.listAreaMachine.isNotEmpty) {
      for (var i = 0; i < state.listAreaMachine.length; i++) {
        listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
      }

      if (state.listAreaMachine[state.activeArea].listMachine.isNotEmpty) {
        var listMachine = state.listAreaMachine[state.activeArea].listMachine;
        for (var i = 0; i < listMachine.length; i++) {
          listItemMachine.add(NameIndex(name: listMachine[i].name, index: i));
        }
      }
    }
    emit(state.copyWith(listItemArea: listItemArea, listItemMachine: listItemMachine));
  }

  Color convertColor(int status) {
    Color colorStatus;
    switch (status) {
      case 1:
        colorStatus = Colors.green;
      case 2:
        colorStatus = Colors.red;
      case 3:
        colorStatus = Colors.yellow;
      case 4:
        colorStatus = Colors.orange;
      case 5:
        colorStatus = Colors.purple;
      case 6:
        colorStatus = Colors.blueAccent;
      case 7:
        colorStatus = Colors.blue;
      case 8:
        colorStatus = const Color.fromARGB(255, 207, 207, 207);
        break;
      default:
        colorStatus = Colors.white;
    }
    return colorStatus;
  }
}
