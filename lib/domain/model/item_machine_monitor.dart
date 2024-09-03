// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';

class ItemMachineMonitorMaster {
  final Machine machine;
  final List<MonitoringMachine> listStatus;
  final int allTime;

  ItemMachineMonitorMaster({
    required this.machine,
    required this.listStatus,
    required this.allTime,
  });

}
