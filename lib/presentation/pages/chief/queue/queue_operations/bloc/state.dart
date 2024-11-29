// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import '../model/distrib_item.dart';


class StateOperatQueueChief extends Equatable {
  final List<DistribItem> listResOper;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  const StateOperatQueueChief({
    this.listResOper = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
  });

  @override
  List<Object> get props => [listResOper, activeMachine, activeArea, listAreaMachine];

  StateOperatQueueChief copyWith({
    List<DistribItem>? listResOper,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
  }) {
    return StateOperatQueueChief(
      listResOper: listResOper ?? this.listResOper,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
    );
  }

  @override
  bool get stringify => true;
}
