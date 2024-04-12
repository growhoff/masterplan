import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/domain/model/z_area.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';
import 'package:master_plan/domain/model/z_unit.dart';

class StateMain extends Equatable {
    final UserDTO2? user;
    final ZArea? area;
    final ZUnit? unit;
    final List<AreaDTO2>? areaList;
    final List<MachineDTO2>? machineList;
    final List<ZShiftsDistributionDTO2>? zShiftsDistributionList; 
    final List<ZOperatorOperations>? operatorOperationsList;
  const StateMain({
    this.user,
    this.area,
    this.unit,
    this.areaList,
    this.machineList,
    this.zShiftsDistributionList,
    this.operatorOperationsList,
  });

  @override
  List<Object> get props {
    return [
      user ?? UserDTO2(id: 0, fio: '', company: CompanyDTO2.init(), position: PositionDTO2(id: 0, name: ''), positionId: 0, companyId: 0), 
      area ?? ZArea(id: 0, name: '', number: '', machineList: [], machineListId: []),
      unit ?? ZUnit(id: 0, name: '', areaList: [], areaListId: []),
      areaList ?? [],
      machineList ?? [],
      zShiftsDistributionList ?? [],
      operatorOperationsList ?? [],
    ];
  }


  StateMain copyWith({  
    UserDTO2? user,
    CompanyDTO2? company,
    PositionDTO2? position,
    ZArea? area,
    ZUnit? unit,
    List<AreaDTO2>? areaList,
    List<MachineDTO2>? machineList,
    List<ZShiftsDistributionDTO2>? zshiftsDistributionList,
    List<ZOperatorOperations>? operatorOperationsList,
  }) {
    return StateMain(
      user: user ?? this.user,
      area: area ?? this.area,
      unit: unit ?? this.unit,
      machineList: machineList ?? this.machineList,
      areaList: areaList ?? this.areaList,
      zShiftsDistributionList: zshiftsDistributionList ?? this.zShiftsDistributionList,
      operatorOperationsList: operatorOperationsList ?? this.operatorOperationsList,
    );
  }

  @override
  bool get stringify => true;
}

