// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
// import 'package:master_plan/presentation/pages/chief_master/pages/queue/queue_operations/model/item_oper.dart';
// import '../model/item_machine.dart';


class StateOperatQueueMasterChM extends Equatable {
  final List<OptPathOperations>? listOper;
  final int activeMachine;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  const StateOperatQueueMasterChM({
    this.listOper = const [],
    this.activeMachine = 0,
    this.activeArea = 0,
    this.listAreaMachine = const [],
  });

  @override
  List<Object> get props => [listOper ?? [], activeMachine, activeArea, listAreaMachine];

  StateOperatQueueMasterChM copyWith({
    List<OptPathOperations>? listOper,
    int? activeMachine,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
  }) {
    return StateOperatQueueMasterChM(
      listOper: listOper ?? this.listOper,
      activeMachine: activeMachine ?? this.activeMachine,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
    );
  }

  @override
  bool get stringify => true;
}
