// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
// import 'package:master_plan/domain/model/otp_path_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_machine.dart';

class StateQueueMaster extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  final List<NameIndex> listItemArea;
  final List<NameIndex> listItemMachine;
  final bool isGroup;
  final bool isLoading;
  const StateQueueMaster({
    this.listMachine = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
    this.listItemArea = const [],
    this.listItemMachine = const [],
    this.isGroup = false,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [listMachine ?? [], activeArea, activeMachine, listAreaMachine, listItemArea, listItemMachine, isGroup, isLoading];

  StateQueueMaster copyWith({
    List<ItemMachine>? listMachine,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    List<NameIndex>? listItemMachine,
    bool? isGroup,
    bool? isLoading,
  }) {
    return StateQueueMaster(
      listMachine: listMachine ?? this.listMachine,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      listItemMachine: listItemMachine ?? this.listItemMachine,
      isGroup: isGroup ?? this.isGroup,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool get stringify => true;
}
