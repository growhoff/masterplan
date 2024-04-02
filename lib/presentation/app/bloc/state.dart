// // ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';

import 'package:master_plan/data/repositories/supabase/dto2/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';

import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/details.dart';
import 'package:master_plan/domain/model/equipment.dart';
import 'package:master_plan/domain/model/oper_operations.dart';
import 'package:master_plan/domain/model/operatoroperations.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/ready_operations.dart';
import 'package:master_plan/domain/model/region.dart';
import 'package:master_plan/domain/model/shiftsdistribution.dart';
import 'package:master_plan/domain/model/stage_master_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/domain/model/user_lite.dart';

class StateMain extends Equatable {
    // final UserModel? user;
    // final Company? company;
    final Region? region;
    // final Position? position;

    final UserDTO2? user;
    final CompanyDTO2? company;
    final PositionDTO2? position;
    final AreaDTO2? area;
    final UnitDTO2? unit;
    final List<MachineDTO2>? machineList;
    final List<ZShiftsDistributionDTO2>? zShiftsDistributionList; 

    final List<Equipment>? listEquipment;
    final List<Details>? listDetails;
    final List<Status>? listStatus;
    final List<OperatorOperations>? listoperatorOperations;
    final List<ShiftsDistribution>? listShiftsDistribution;
    final List<UserModelLite>? listOperators;
    final List<ReadyOperations>? listReadyOperations;
    final List<StageMasterOperations>? listStageMasterOperations;
    final List<OperOperations>? listOperOperations;
  const StateMain({
    this.user,
    this.company,
    this.region,
    this.position,
    this.area,
    this.unit,
    this.machineList,
    this.zShiftsDistributionList,
    this.listEquipment,
    this.listDetails,
    this.listStatus,
    this.listoperatorOperations,
    this.listShiftsDistribution,
    this.listOperators,
    this.listReadyOperations,
    this.listStageMasterOperations,
    this.listOperOperations,
  });

  @override
  List<Object> get props {
    return [
      // user ?? UserModel(id: -1, fio: '', position: '', region: '', company: ''),
      // company ?? Company(id: -1, name: 'none', fullName: 'none'),
      region ?? Region(id: -1, name: 'none', number: '-1'),
      // position ?? Position(id: -1, name: 'none'),
      user ?? UserDTO2.init(), 
      company ?? CompanyDTO2.init(), 
      position ?? PositionDTO2.init(),

      area ?? AreaDTO2(id: 0, name: '', number: 1, machineId: []),
      unit ?? UnitDTO2(id: 0, name: '', areaId: []),
      machineList ?? [],
      zShiftsDistributionList ?? [],

      listEquipment ?? [],
      listDetails ?? [],
      listStatus ?? [],
      listoperatorOperations ?? [],
      listShiftsDistribution ?? [],
      listOperators ?? [],
      listReadyOperations ?? [],
      listStageMasterOperations ?? [],
      listOperOperations ?? [],
    ];
  }


  StateMain copyWith({
    // UserModel? user,
    // Company? company,
    Region? region,
    // Position? position,
    
    UserDTO2? user,
    CompanyDTO2? company,
    PositionDTO2? position,
    AreaDTO2? area,
    UnitDTO2? unit,
    List<MachineDTO2>? machineList,
    List<ZShiftsDistributionDTO2>? zshiftsDistributionList,

    List<Equipment>? listEquipment,
    List<Details>? listDetails,
    List<Status>? listStatus,
    List<OperatorOperations>? listoperatorOperations,
    List<ShiftsDistribution>? listShiftsDistribution,
    List<UserModelLite>? listOperators,
    List<ReadyOperations>? listReadyOperations,
    List<StageMasterOperations>? listStageMasterOperations,
    List<OperOperations>? listOperOperations,
  }) {
    return StateMain(
      user: user ?? this.user,
      company: company ?? this.company,
      region: region ?? this.region,
      position: position ?? this.position,
      area: area ?? this.area,
      unit: unit ?? this.unit,
      machineList: machineList ?? this.machineList,
      zShiftsDistributionList: zshiftsDistributionList ?? this.zShiftsDistributionList,

      listEquipment: listEquipment ?? this.listEquipment,
      listDetails: listDetails ?? this.listDetails,
      listStatus: listStatus ?? this.listStatus,
      listoperatorOperations: listoperatorOperations ?? this.listoperatorOperations,
      listShiftsDistribution: listShiftsDistribution ?? this.listShiftsDistribution,
      listOperators: listOperators ?? this.listOperators,
      listReadyOperations: listReadyOperations ?? this.listReadyOperations,
      listStageMasterOperations: listStageMasterOperations ?? this.listStageMasterOperations,
      listOperOperations: listOperOperations ?? this.listOperOperations,
    );
  }

  @override
  bool get stringify => true;
}

