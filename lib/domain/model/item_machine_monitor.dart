// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';

class ItemMachineMonitorMaster {
  final Machine machine;
  final List<MonitoringMachine> listStatus;
  final StaffDTO? user;
  final int allTime;

  ItemMachineMonitorMaster({
    required this.machine,
    required this.listStatus,
    this.user,
    required this.allTime,
  });


  ItemMachineMonitorMaster copyWith({
    Machine? machine,
    List<MonitoringMachine>? listStatus,
    StaffDTO? user,
    int? allTime,
  }) {
    return ItemMachineMonitorMaster(
      machine: machine ?? this.machine,
      listStatus: listStatus ?? this.listStatus,
      user: user ?? this.user,
      allTime: allTime ?? this.allTime,
    );
  }
}
