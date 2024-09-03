// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/domain/model/shifts_machine_active.dart';
import 'package:master_plan/domain/model/user.dart';

class StateBrakDetails extends Equatable {
  final int change;
  final List<ShiftsMachine>? shiftsList;
  final int activeArea;
  final List<AreaMachine> listAreaMachine;
  final List<NameIndex> listItemArea;
  final List<User> operatorList;
  final int maxChange;
  final List<ShiftsMachineActive> activeShiftsList;
  const StateBrakDetails({
    this.change = 1,
    this.shiftsList = const[],
    this.activeArea = 0,
    this.listAreaMachine = const [],
    this.listItemArea = const [],
    this.operatorList = const [],
    this.maxChange = 0,
    this.activeShiftsList = const [],
  });

  @override
  List<Object> get props => [change, shiftsList ?? [], activeArea, listAreaMachine, listAreaMachine, operatorList, listItemArea, maxChange, activeShiftsList];

  StateBrakDetails copyWith({
    int? change,
    List<ShiftsMachine>? shiftsList,
    int? activeArea,
    List<AreaMachine>? listAreaMachine,
    List<NameIndex>? listItemArea,
    List<User>? operatorList,
    int? maxChange,
    List<ShiftsMachineActive>? activeShiftsList,
  }) {
    return StateBrakDetails(
      change: change ?? this.change,
      shiftsList: shiftsList ?? this.shiftsList,
      activeArea: activeArea ?? this.activeArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listItemArea: listItemArea ?? this.listItemArea,
      operatorList: operatorList ?? this.operatorList,
      maxChange: maxChange ?? this.maxChange,
      activeShiftsList: activeShiftsList ?? this.activeShiftsList,
    );
  }

  @override
  bool get stringify => true;
}
