import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/domain/model/user.dart';

import '../../../domain/model/staff.dart';

class StateMain extends Equatable {
  final String version;
  final UserDTO? user;
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

  const StateMain({
    this.version = 'v2.5.19',
    this.user,
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
  });

  @override
  List<Object> get props {
    return [
      user ??
          UserDTO(
              id: 0,
              fio: '',
              company: CompanyDTO.init(),
              position: PositionDTO(id: 0, name: ''),
              positionId: 0,
              companyId: 0),
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
      staff ?? Staff.empty
    ];
  }

  StateMain copyWith(
      {UserDTO? user,
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
      List<int>? listAreaId}) {
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
      monitorList: monitorList ?? this.monitorList,
      zshiftsDistributionList:
          zshiftsDistributionList ?? this.zshiftsDistributionList,
      operatorOperationsList:
          operatorOperationsList ?? this.operatorOperationsList,
      link: link ?? this.link,
      change: change,
      listAreaId: listAreaId ?? this.listAreaId,
    );
  }

  @override
  bool get stringify => true;
}
