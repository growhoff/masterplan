import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoring_page.dart';
import 'state.dart';

class CubitMonitoring extends Cubit<StateMonitoring> {
  final List<Machine>? machineList;
  List<MonitoringMachineDTO>? monitorList;
  CubitMonitoring(this.machineList, this.monitorList)
      : super(const StateMonitoring()) {
    List<ElementBarData> list = [];
    for (var machine in machineList!) {
      List<ItemMachineStatus> listStatus = [];
      int allTime = 0;
      for (var monitor in monitorList!) {
        if (monitor.machine!.id == machine.id) {
          listStatus.add(ItemMachineStatus(
              timeStart: monitor.timeStart,
              timeEnd: monitor.timeStop,
              timeWorking: (monitor.timeStop < monitor.timeStart) ? 0 : monitor.timeStop - monitor.timeStart,
              status: monitor.statusMachine!,
              comment: monitor.comment));
          allTime += (monitor.timeStop - monitor.timeStart);
        }
      }
      list.add(ElementBarData(
          header: machine.name,
          content: ContentListWidget(ItemMachineMonitor(
              machine: machine, listStatus: listStatus, allTime: allTime))));
    }
    emit(state.copyWith(listBar: list));
  }

  
}
