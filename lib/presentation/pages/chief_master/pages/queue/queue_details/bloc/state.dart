// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import '../model/item_machine.dart';

class StateQueueMasterChM extends Equatable {
  // final List<ElementBarData>? listBar;
  // final List<ItemArea>? listItemArea;
  final List<ItemMachine>? listMachine;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  const StateQueueMasterChM({
    // this.listItemArea = const [],
    this.listMachine = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
  });

  @override
  List<Object> get props => [listMachine ?? [], activeMachine, activeArea, listAreaMachine];

  StateQueueMasterChM copyWith({
    // List<ItemArea>? listItemArea,
    List<ItemMachine>? listMachine,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
  }) {
    return StateQueueMasterChM(
      listMachine: listMachine ?? this.listMachine,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
    );
  }

  @override
  bool get stringify => true;
}
