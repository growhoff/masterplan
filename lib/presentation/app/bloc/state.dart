import 'package:equatable/equatable.dart';

import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';


import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/domain/model/user.dart';

import '../../../domain/model/staff.dart';

class StateMain extends Equatable {
  final String version;
  final User? user;
  final Staff? staff;
  final List<Machine>? machineList;
  final List<int>? machineIdList;
  final List<ShiftsMachine>? shiftsList;
  final List<OperatorOperations>? distribMasterList;
  final List<OperatorOperations>? queueList;
  final List<OperatorOperations>? readyList;
  final List<User>? operatorList;
  final List<MonitoringMachineDTO>? monitorList;
  final List<ShiftsDistribution>? zshiftsDistributionList;
  final List<OperatorOperations>? operatorOperationsList;
  final String link;
  final int? change;
  final List<int>? listAreaId;
  final List<Area>? listArea;
  final List<AreaMachine>? listAreaMachine;
  final List<AreaMachine>? listAreaMachineUser;
  final int? unitId;

  const StateMain({
    this.version = 'v2.6.22',
    this.user,
    this.unitId,
    this.staff,
    this.machineList,
    this.machineIdList,
    this.shiftsList,
    this.distribMasterList,
    this.queueList,
    this.readyList,
    this.operatorList,
    this.monitorList,
    this.zshiftsDistributionList,
    this.operatorOperationsList,
    this.link = '',
    this.change,
    this.listAreaId,
    this.listArea,
    this.listAreaMachine,
    this.listAreaMachineUser,
  });

  @override
  List<Object?> get props => [
    user ??
        User(
          id: 0,
          fio: '',
          companyId: 0,
          positionId: 0,
          unitId: 0,
          areaId: 0,
          photo: '',
          position: Position(id: 0, name: ''),
          company: Company(id: 0, name: '', code: ''),
        ),
    unitId,
    machineList ?? [],
    machineIdList ?? [],
    shiftsList ?? [],
    distribMasterList ?? [],
    queueList ?? [],
    readyList ?? [],
    operatorList ?? [],
    monitorList ?? [],
    zshiftsDistributionList ?? [],
    operatorOperationsList ?? [],
    version,
    link,
    change ?? 0,
    listAreaId ?? [],
    listArea ?? [],
    listAreaMachine ?? [],
    listAreaMachineUser ?? [],
    staff ?? Staff.empty
  ];

  StateMain copyWith({
    User? user,
    Staff? staff,
    List<Machine>? machineList,
    List<int>? machineIdList,
    List<ShiftsMachine>? shiftsList,
    List<OperatorOperations>? distribMasterList,
    List<OperatorOperations>? queueList,
    List<OperatorOperations>? readyList,
    List<User>? operatorList,
    List<MonitoringMachineDTO>? monitorList,
    List<ShiftsDistribution>? zshiftsDistributionList,
    List<OperatorOperations>? operatorOperationsList,
    String? link,
    int? change,
    int? unitId,
    List<int>? listAreaId,
    List<Area>? listArea,
    List<AreaMachine>? listAreaMachine,
    List<AreaMachine>? listAreaMachineUser,
  }) {
    return StateMain(
      user: user ?? this.user,
      staff: staff ?? this.staff,
      machineList: machineList ?? this.machineList,
      machineIdList: machineIdList ?? this.machineIdList,
      shiftsList: shiftsList ?? this.shiftsList,
      distribMasterList: distribMasterList ?? this.distribMasterList,
      queueList: queueList ?? this.queueList,
      readyList: readyList ?? this.readyList,
      operatorList: operatorList ?? this.operatorList,
      unitId: unitId ?? this.unitId,
      monitorList: monitorList ?? this.monitorList,
      zshiftsDistributionList:
      zshiftsDistributionList ?? this.zshiftsDistributionList,
      operatorOperationsList:
      operatorOperationsList ?? this.operatorOperationsList,
      link: link ?? this.link,
      change: change,
      listAreaId: listAreaId ?? this.listAreaId,
      listArea: listArea ?? this.listArea,
      listAreaMachine: listAreaMachine ?? this.listAreaMachine,
      listAreaMachineUser: listAreaMachineUser ?? this.listAreaMachineUser,
    );
  }

  @override
  bool get stringify => true;
}
