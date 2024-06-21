// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import '../model/item_machine_monitor.dart';

class StateMonitoringChM extends Equatable {
  final List<ItemMachineMonitorMaster>? listMonitor;
  final DateTime days;
  final int change;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  const StateMonitoringChM({
    this.listMonitor = const[],
    required this.days,
    this.change = 1,
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
  });

  @override
  List<Object> get props => [listMonitor ?? [], days, change, activeMachine, activeArea, listAreaMachine];

  StateMonitoringChM copyWith({
    List<ItemMachineMonitorMaster>? listMonitor,
    DateTime? days,
    int? change,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
  }) {
    return StateMonitoringChM(
      listMonitor: listMonitor ?? this.listMonitor,
      days: days ?? this.days,
      change: change ?? this.change,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
    );
  }

  @override
  bool get stringify => true;
}
