// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import '../model/item_machine.dart';
import '../model/status_next.dart';

class StateReadyDetailsChM extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activePage;
  final List<List<StatusNext>> statusList;
  final int count;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  const StateReadyDetailsChM({
    this.listMachine = const [],
    this.activePage = 0,
    this.statusList = const [],
    this.count = 0,
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const[],
  });

  @override
  List<Object> get props => [listMachine ?? [], activePage, statusList, count, activeMachine, activeArea, listAreaMachine];

  StateReadyDetailsChM copyWith({
    List<ItemMachine>? listMachine,
    int? activePage,
    List<List<StatusNext>>? statusList,
    int? count,
     int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
  }) {
    return StateReadyDetailsChM(
      listMachine: listMachine ?? this.listMachine,
      activePage: activePage ?? this.activePage,
      statusList: statusList ?? this.statusList,
      count: count ?? this.count,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
    );
  }

  @override
  bool get stringify => true;
}
