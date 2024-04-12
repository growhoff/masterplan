import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/unit.dart';

class StateMain extends Equatable {
    final UserDTO? user;
    final Area? area;
    final Unit? unit;
    final List<AreaDTO>? areaList;
    final List<MachineDTO>? machineList;
    final List<ZShiftsDistributionDTO>? zShiftsDistributionList; 
    final List<OperatorOperations>? operatorOperationsList;
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
      user ?? UserDTO(id: 0, fio: '', company: CompanyDTO.init(), position: PositionDTO(id: 0, name: ''), positionId: 0, companyId: 0), 
      area ?? Area(id: 0, name: '', number: '', machineList: [], machineListId: []),
      unit ?? Unit(id: 0, name: '', areaList: [], areaListId: []),
      areaList ?? [],
      machineList ?? [],
      zShiftsDistributionList ?? [],
      operatorOperationsList ?? [],
    ];
  }


  StateMain copyWith({  
    UserDTO? user,
    CompanyDTO? company,
    PositionDTO? position,
    Area? area,
    Unit? unit,
    List<AreaDTO>? areaList,
    List<MachineDTO>? machineList,
    List<ZShiftsDistributionDTO>? zshiftsDistributionList,
    List<OperatorOperations>? operatorOperationsList,
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

