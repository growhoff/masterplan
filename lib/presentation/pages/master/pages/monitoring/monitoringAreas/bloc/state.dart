// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/item_machine_monitor.dart';
import 'package:master_plan/domain/model/name_index.dart';

class StateMonitoringAreas extends Equatable {
  final List<ItemMachineMonitorMaster>? listMonitor;
  final DateTime days;
  final int change;
  final int activePage;
  final List<ItemMachineMonitorMaster> listStatusActiveNew;
  final List<StatusMachineDTO>? statusActiveList;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  final List<NameIndex> listItemArea;
  final List<NameIndex> listItemMachine;
  final bool isLoading;
  final int maxChange;
  final List<ShiftsDistributionDTO> listShifts;

  const StateMonitoringAreas({
    this.listMonitor = const[],
    required this.days,
    this.change = 1,
    this.activePage = 0,
    this.listStatusActiveNew = const [],
    this.statusActiveList = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
    this.listItemArea = const [],
    this.listItemMachine = const [],
    this.isLoading = false,
    this.maxChange = 0,
    this.listShifts = const [],
  });

  @override
  List<Object> get props => [isLoading, maxChange, listShifts, listMonitor ?? [], days, change, activePage, listStatusActiveNew, statusActiveList ?? [], activeArea, activeMachine, listAreaMachine, listItemArea, listItemMachine];

  StateMonitoringAreas copyWith({
    List<ItemMachineMonitorMaster>? listMonitor,
    DateTime? days,
    int? change,
    int? activePage,
    List<ItemMachineMonitorMaster>? listStatusActiveNew,
    List<StatusMachineDTO>? statusActiveList,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    List<NameIndex>? listItemMachine,
    bool? isLoading,
    int? maxChange,
    List<ShiftsDistributionDTO>? listShifts,
  }) {
    return StateMonitoringAreas(
      listMonitor: listMonitor ?? this.listMonitor,
      days: days ?? this.days,
      change: change ?? this.change,
      activePage: activePage ?? this.activePage,
      listStatusActiveNew: listStatusActiveNew ?? this.listStatusActiveNew,
      statusActiveList:  statusActiveList ?? this.statusActiveList,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      listItemMachine: listItemMachine ?? this.listItemMachine,
      isLoading: isLoading ?? this.isLoading,
      maxChange: maxChange ?? this.maxChange,
      listShifts: listShifts ?? this.listShifts
    );
  }

  @override
  bool get stringify => true;
}
