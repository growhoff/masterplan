// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';

class StateMonitoring extends Equatable {
  final List<ItemMachineMonitorMaster>? listMonitor;
  final DateTime days;
  final int change;
  final int activePage;
  final List<MonitoringMachine> listStatusActive;
  final StatusMachineDTO? statusActive;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  final List<NameIndex> listItemArea;
  final List<NameIndex> listItemMachine;
  const StateMonitoring({
    this.listMonitor = const[],
    required this.days,
    this.change = 1,
    this.activePage = 0,
    this.listStatusActive = const [],
    this.statusActive,
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
    this.listItemArea = const [],
    this.listItemMachine = const [],
  });

  @override
  List<Object> get props => [listMonitor ?? [], days, change, activePage, listStatusActive, statusActive ?? StatusMachineDTO(id: -1, name: '-'), activeArea, activeMachine, listAreaMachine, listItemArea, listItemMachine];

  StateMonitoring copyWith({
    List<ItemMachineMonitorMaster>? listMonitor,
    DateTime? days,
    int? change,
    int? activePage,
    List<MonitoringMachine>? listStatusActive,
    StatusMachineDTO? statusActive,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    List<NameIndex>? listItemMachine,
  }) {
    return StateMonitoring(
      listMonitor: listMonitor ?? this.listMonitor,
      days: days ?? this.days,
      change: change ?? this.change,
      activePage: activePage ?? this.activePage,
      listStatusActive: listStatusActive ?? this.listStatusActive,
      statusActive:  statusActive ?? this.statusActive,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      listItemMachine: listItemMachine ?? this.listItemMachine,
    );
  }

  @override
  bool get stringify => true;
}
