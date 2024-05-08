import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/domain/model/area.dart';

import '../../../../../data/repositories/supabase/dto/monitoring_machine_dto.dart';
import '../../../../../data/repositories/supabase/service/area_table.dart';
import '../../../../../domain/model/machine.dart';
import '../../model/element_bar_model.dart';
import '../model/item_machine.dart';
import '../model/item_machine_monitor.dart';
import '../monitoring_page.dart';

part 'monitoring_state.dart';

class MonitoringCubit extends Cubit<MonitoringState> {
  MonitoringCubit() : super(const MonitoringState());

  final MachineTable _machineTable = MachineTable();
  final AreaTable _areaTable = AreaTable();
  final MonitoringMachineTable _monitoringMachineTable = MonitoringMachineTable();

  final _monitoringStream = MonitoringMachineTable().stream();

  Future<void> fetchElementBars() async {
    final List<Machine> machineList = [];
    List<ElementBarModel> list = [];
    List<MonitoringMachineDTO>? monitorList = [];
    var fetchedMachinesList = await _machineTable.select();

    for (var machine in fetchedMachinesList) {
      final machineDto = MachineDTO.fromMap(machine);
      machineList.add(Machine(
          id: machineDto.id,
          inventoryNumber: machineDto.inventoryNumber,
          name: machineDto.name,
          areaId: machineDto.areaId));
    }
    print('machineList: $machineList');



    var fetchedMonitoringMachinesList = await _monitoringMachineTable.select();
    for (var monitoringMachine in fetchedMonitoringMachinesList) {
      final monitoringMachineDto =
          MonitoringMachineDTO.fromMap(monitoringMachine);
      print('ID: ${monitoringMachineDto.machine?.id}');
      monitorList.add(monitoringMachineDto);
    }

    print('monitorList: $monitorList');

    for (var machine in machineList) {
      List<ItemMachineStatus> listStatus = [];
      int allTime = 0;
      for (var monitor in monitorList) {
        print(
            'monitorMachineId: ${monitor.machine?.id}  :  ${machine.id} machineId');
        if (monitor.machine?.id == machine.id) {
          listStatus.add(ItemMachineStatus(
              timeStart: monitor.timeStart,
              timeEnd: monitor.timeStop,
              timeWorking: monitor.timeStop - monitor.timeStart,
              status: monitor.statusMachine!,
              comment: monitor.comment));
          allTime += (monitor.timeStop - monitor.timeStart);
        }
      }
      print('machine: $machine,  listStatus: $listStatus,  allTime: $allTime');
      list.add(ElementBarModel(
          header: machine.name,
          content: ContentListWidget(
            monitor: ItemMachineMonitor(
                machine: machine, listStatus: listStatus, allTime: allTime),
          )));
    }
    print(list.length);
    emit(state.copyWith(listBar: list));
  }

  Future<void> fetch() async {
    List<Area> areasList = [];
    var fetchedAreasTable = await _areaTable.select();
    for (var area in fetchedAreasTable) {
      final areaDto = AreaDTO.fromMap(area);
      areasList.add(Area(
          id: areaDto.id,
          name: areaDto.name,
          number: areaDto.number,
          unitId: areaDto.unitId));
    }

    _monitoringStream.listen((list) {
      print(list);
    });
  }
}
