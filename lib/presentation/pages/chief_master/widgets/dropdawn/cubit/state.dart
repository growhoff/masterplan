// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';

class StateDrop extends Equatable {
  final List<AreaMachine> listAreaMachine;
  final int? activeArea;
  final int? activeMachine;
  final List<NameIndex>? listItemArea;
  final List<NameIndex>? listItemMachine;

  const StateDrop({
    this.listAreaMachine = const [],
    this.activeArea = 0,
    this.activeMachine = 0,
    this.listItemArea = const[],
    this.listItemMachine = const[]
  });

  @override
  List<Object> get props => [activeArea ?? 0, listAreaMachine, activeMachine ?? 0, listItemArea ?? [], listItemMachine ?? []];

  StateDrop copyWith({
    List<AreaMachine>? listAreaMachine,
    int? activeArea,
    int? activeMachine,
    List<NameIndex>? listItemArea,
    List<NameIndex>? listItemMachine,
  }) {
    return StateDrop(
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      activeArea: activeArea ?? this.activeArea,
      activeMachine: activeMachine ?? this.activeMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      listItemMachine: listItemMachine ?? this.listItemMachine,
    );
  }

  @override
  bool get stringify => true;
}
