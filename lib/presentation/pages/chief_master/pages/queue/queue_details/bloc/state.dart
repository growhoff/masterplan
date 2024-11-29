// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/group_opt_path.dart';
import 'package:master_plan/domain/model/item_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';

class StateQueueMaster extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  final List<NameIndex> listItemArea;
  final List<NameIndex> listItemMachine;
  final bool isSaver;
  final bool isGroup;
  final bool isLoading;
  final List<GroupOptPath> listSaver;
  final bool isActiveStream;
  const StateQueueMaster({
    this.listMachine = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
    this.listItemArea = const [],
    this.listItemMachine = const [],
    this.isSaver = false,
    this.isGroup = false,
    this.isLoading = false,
    this.listSaver = const [],
    this.isActiveStream = true,
  });

  @override
  List<Object> get props => [listMachine ?? [], listSaver, isActiveStream, activeArea, activeMachine, listAreaMachine, listItemArea, listItemMachine, isSaver, isGroup, isLoading];

  StateQueueMaster copyWith({
    List<ItemMachine>? listMachine,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    List<NameIndex>? listItemMachine,
    bool? isSaver,
    bool? isGroup,
    bool? isLoading,
    List<GroupOptPath>? listSaver,
    bool? isActiveStream,
  }) {
    return StateQueueMaster(
      listMachine: listMachine ?? this.listMachine,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      listItemMachine: listItemMachine ?? this.listItemMachine,
      isSaver: isSaver ?? this.isSaver,
      isGroup: isGroup ?? this.isGroup,
      isLoading: isLoading ?? this.isLoading,
      listSaver: listSaver ?? this.listSaver,
      isActiveStream: isActiveStream ?? this.isActiveStream,
    );
  }

  @override
  bool get stringify => true;
}
