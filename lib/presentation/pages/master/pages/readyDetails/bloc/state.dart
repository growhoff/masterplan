// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/status_next.dart';

class StateReadyDetails extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activeMachine;
  final int activeArea;
  final List<List<StatusNext>> statusList;
  final int count;
  final bool isLoading;
  final bool isActiveStream;
  final List<AreaMachine> listAreaMachine;
  final List<NameIndex> listItemArea;
  final List<NameIndex> listItemMachine;

  const StateReadyDetails({
    this.listMachine = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.statusList = const [],
    this.count = 0,
    this.isLoading = false,
    this.isActiveStream = true,
    this.listAreaMachine = const [],
    this.listItemArea = const [],
    this.listItemMachine = const [],
  });

  @override
  List<Object> get props => [listMachine ?? [], activeMachine, activeArea, statusList, count, isLoading, isActiveStream, listAreaMachine, listItemArea, listItemMachine];

  StateReadyDetails copyWith({
    List<ItemMachine>? listMachine,
    int? activeMachine,
    List<List<StatusNext>>? statusList,
    int? count,
    bool? isLoading,
    bool? isActiveStream,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    List<NameIndex>? listItemMachine,
    int? activeArea,
  }) {
    return StateReadyDetails(
      listMachine: listMachine ?? this.listMachine,
      activeMachine: activeMachine ?? this.activeMachine,
      statusList: statusList ?? this.statusList,
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
      isActiveStream: isActiveStream ?? this.isActiveStream,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      listItemMachine: listItemMachine ?? this.listItemMachine,
      activeArea: activeArea ?? this.activeArea,
    );
  }

  @override
  bool get stringify => true;
}
