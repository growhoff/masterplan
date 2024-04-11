

part of 'cubit.dart';

class StateMain extends Equatable {
    // final UserModel? user;
    // final Company? company;
    final Region? region;
    // final Position? position;

    final UserDTO2? user;
    final CompanyDTO2? company;
    final PositionDTO2? position;
    final AreaModel? area;
    final ZUnit? unit;
    final List<AreaDTO2>? areaList;
    final List<MachineDTO2>? machineList;
    final List<ZShiftsDistributionDTO2>? zShiftsDistributionList; 
    final List<OperatorOperationsDTO2>? operatorOperationsList;

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
    this.areaList,
    this.machineList,
    this.zShiftsDistributionList,
    this.operatorOperationsList,

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

      area ?? AreaModel(id: 0, name: '', number: '', machineList: [], machineListId: []),
      unit ?? ZUnit(id: 0, name: '', areaList: [], areaListId: []),
      areaList ?? [],
      machineList ?? [],
      zShiftsDistributionList ?? [],
      operatorOperationsList ?? [],

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
    AreaModel? area,
    ZUnit? unit,
    List<AreaDTO2>? areaList,
    List<MachineDTO2>? machineList,
    List<ZShiftsDistributionDTO2>? zshiftsDistributionList,
    List<OperatorOperationsDTO2>? operatorOperationsList,

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
      areaList: areaList ?? this.areaList,
      zShiftsDistributionList: zshiftsDistributionList ?? this.zShiftsDistributionList,
      operatorOperationsList: operatorOperationsList ?? this.operatorOperationsList,
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

