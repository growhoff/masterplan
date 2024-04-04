import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/details_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/equipment_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/oper_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/ready_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/region_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_master_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/package_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/company_table.dart';
import 'package:master_plan/data/repositories/supabase/service/details_table.dart';
import 'package:master_plan/data/repositories/supabase/service/equipment_table.dart';
import 'package:master_plan/data/repositories/supabase/service/oper_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_table.dart';
import 'package:master_plan/data/repositories/supabase/service/ready_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/region_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution_table.dart';
import 'package:master_plan/data/repositories/supabase/service/st_master_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/status_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_package_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_shifts_distribution.dart';
import 'package:master_plan/data/repositories/supabase/service/z_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_transfer_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_unit_table.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/domain/model/change.dart';
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
// import 'package:master_plan/domain/model/test.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/domain/model/user_lite.dart';
import 'package:master_plan/domain/model/z_area.dart';
import 'package:master_plan/domain/model/z_batch.dart';
import 'package:master_plan/domain/model/z_machine.dart';
import 'package:master_plan/domain/model/z_operation.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';
import 'package:master_plan/domain/model/z_package.dart';
import 'package:master_plan/domain/model/z_stage.dart';
import 'package:master_plan/domain/model/z_transfer.dart';
import 'package:master_plan/domain/model/z_unit.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'state.dart';

class CubitMain extends Cubit<StateMain> { 
  CubitMain() : super(const StateMain());

    Future<String> save(String login, String password) async{
    final tableStaff = StaffTable();
    final query = await tableStaff.selectName(login: login);
    if (query == []) {
      //ошибка авторизации.нет пользователя
      return 'Error 1';
    } else{
      if (query.first['password'] == password){
        //успешная авторизация
        
        await getUserNew(query.first['user_id']);
        if (state.position!.id == 2){
          emit(state.copyWith(unit: await getUnitZ(state.user!.unitId!)));
          }
        if (state.position!.id == 3){
          emit(state.copyWith(area: await getAreaZ(state.user!.areaId!)));
          await getMasterData();
          }
        
        // await getEquipment(state.region!.id, state.company!.id);
        // await getStatus();
        // await getDetails();
        // await getOperatorOperations();
        // await getShiftsDistribution();
        // await getOperatorList();
        // await getStageMasterOperation();
        // await getReadyOperations();
        // await getOperatorsOperations();

        // if (equipment == []) print('Пользователь не закреплен к станкам');
        return state.position!.name;
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }
  /*
  Future<void> getUser(int id) async{
    final tableUser = UserTable();
    final tableCompany = CompanyTable();
    final tableRegion = RegionTable();
    final tablePosition = PositionTable();

    final queryUser = await tableUser.selectId(id);
    final userDto = UserDTO.fromMap(queryUser[0]);

    final queryCompany = await tableCompany.selectId(userDto.companyId);
    final queryRegion = await tableRegion.selectId(userDto.regionId);
    final queryPosition = await tablePosition.selectId(userDto.positionId);

    final companyDto = CompanyDTO.fromMap(queryCompany[0]);
    final regionDto = RegionDTO.fromMap(queryRegion[0]);
    final positionDto = PositionDTO.fromMap(queryPosition[0]);

    final user = UserModel(id: userDto.id, fio: userDto.fio, position: positionDto.name, region: regionDto.name, company: companyDto.shortName);
    final company = Company(id: companyDto.id, name: companyDto.shortName, fullName: companyDto.fullName);
    final region = Region(id: regionDto.id, name: regionDto.name, number: regionDto.number);
    final position = Position(id: positionDto.id, name: positionDto.name);

    emit(state.copyWith(user: user, company: company, region: region, position: position));
  }
*/


  Future<void> getUserNew(int id) async{
    final userTable = UserTable();
    final companyTable = CompanyTable();
    final positionTable = PositionTable();

    final userQuery = await userTable.selectId(id);
    final userDto = UserDTO2.fromMap(userQuery.first);

    final queryCompany = await companyTable.selectId(userDto.companyId);
    final queryPosition = await positionTable.selectId(userDto.positionId);

    final companyDto = CompanyDTO2.fromMap(queryCompany.first);
    final positionDto = PositionDTO2.fromMap(queryPosition.first);

    final region = Region(id: 0, name: 'region', number: '0');

    emit(state.copyWith(user: userDto, company: companyDto, position: positionDto, region: region));
  }

  Future<ZUnit> getUnitZ(int unitId) async{
    final unitTable = UnitTable();
    final unitQuery = await unitTable.selectId(unitId);
    final unitDto = UnitDTO2.fromMap(unitQuery.first);

    List<ZArea> areaList = [];
    for (var id in unitDto.areaId) {
      areaList.add(await getAreaZ(id));
    }

    return ZUnit(id: unitDto.id, name: unitDto.name, areaList: areaList, areaListId: unitDto.areaId);
  }

  Future<ZArea> getAreaZ(int areaId) async{
    final areaTable = AreaTable();
    final areaQuery = await areaTable.selectId(areaId);
    final areaDto = AreaDTO2.fromMap(areaQuery.first);

    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectListId(areaDto.machineId);
    List<ZMachine> machineList = [];
    for (var machine in machineQuery) {
      final model = MachineDTO2.fromMap(machine);
      machineList.add(ZMachine(id: model.id, inventoryNumber: model.inventoryNumber, name: model.name));
    }
    return ZArea(id: areaDto.id, name: areaDto.name, number: areaDto.number, machineList: machineList, machineListId: areaDto.machineId);
  }

  Future<ZMachine> getMachineZ(int machineId) async{
    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectId(machineId);
    final model = MachineDTO2.fromMap(machineQuery.first);
    return ZMachine(id: model.id, inventoryNumber: model.inventoryNumber, name: model.name);
  }

  Future<void> getMasterData() async{
    final zshiftsDistributionTable = ZShiftsDistributionTable();
    final zshiftsDistributionQuery = await zshiftsDistributionTable.selectEq(state.area!.machineListId, DateTime.now());
    List<ZShiftsDistributionDTO2> zshiftsDistributionList = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      zshiftsDistributionList.add(ZShiftsDistributionDTO2.fromMap(shiftsDistr));
    }


    final zOperatorOperationsTable = ZOperatorOperationsTable();
    final zOperatorOperationsQuery = await zOperatorOperationsTable.selectListId(state.area!.machineListId);
    List<ZOperatorOperations> operatorOperationsList = [];
    for (var operatorOper in zOperatorOperationsQuery) {
      final model = OperatorOperationsDTO2.fromMap(operatorOper);
      operatorOperationsList.add(ZOperatorOperations(id: model.id, timeplan: model.timeplan, timefact: model.timefact, timestart: model.timestart, timestop: model.timestop, timeworking: model.timeworking, status: model.statusid, stageoperationid: model.stageoperationid, stagemasteroperationid: model.stagemasteroperationid, batch: await getBatchZ(model.batchid.id), user: model.userid, isuploaded: model.isuploaded, order: model.order, machine: model.machineid));
    }

    emit(state.copyWith(zshiftsDistributionList: zshiftsDistributionList, operatorOperationsList: operatorOperationsList));
  }

  Future<ZTransfer> getTransferZ(int transferId) async{
      final transferTable = ZTransferTable();
      final transferQuery = await transferTable.selectId(transferId);
      final model = TransferDTO2.fromMap(transferQuery.first);
      return ZTransfer(id: model.id, number: model.number, name: model.name, code: model.code, timepz: model.timepz, timesh: model.timesh);
  }

  Future<ZOperation> getOperationZ(int operationId) async{
    final operationTable = ZOperationTable();
    final operationQuery = await operationTable.selectId(operationId);
    final operationDto = OperationDTO2.fromMap(operationQuery.first);

    final transferTable = ZTransferTable();
    final transferQuery = await transferTable.selectListId(operationDto.transferId);
    List<ZTransfer> transferList = [];
    for (var transfer in transferQuery) {
      final model = TransferDTO2.fromMap(transfer);
      transferList.add(ZTransfer(id: model.id, number: model.number, name: model.name, code: model.code, timepz: model.timepz, timesh: model.timesh));
    }
    return ZOperation(id: operationDto.id, number: operationDto.number, name: operationDto.name, code: operationDto.code, isready: operationDto.isready, transferList: transferList, transferListId: operationDto.transferId);
  }

  Future<ZStage> getStageZ(int stageId) async{
    final stageTable = ZStageTable();
    final stageQuery = await stageTable.selectId(stageId);
    final stageDto = StageDTO2.fromMap(stageQuery.first);

    List<ZOperation> operationList = [];
    for (var id in stageDto.operationId) {
      operationList.add(await getOperationZ(id));
    }

    return ZStage(id: stageDto.id, number: stageDto.number, code: stageDto.code, operationList: operationList, operationListId: stageDto.operationId);
  }

  Future<ZBatch> getBatchZ(int batchId) async{
    final batchTable = ZBatchTable();
    final batchQuery = await batchTable.selectId(batchId);
    final batchDto = BatchDTO2.fromMap(batchQuery.first);

    List<ZStage> stageList = [];
    for (var id in batchDto.stepId) {
      stageList.add(await getStageZ(id));
    }

    return ZBatch(id: batchDto.id, number: batchDto.number, name: batchDto.name, count: batchDto.count, code: batchDto.code, technology: batchDto.technology, order: batchDto.order, isready: batchDto.isready, stageList: stageList, stageListId: batchDto.stepId);
  }

  Future<ZPackage> getPackageZ(int packageId) async{
    final packageTable = ZPackageTable();
    final packageQuery = await packageTable.selectId(packageId);
    final packageDto = PackageDTO2.fromMap(packageQuery.first);

    List<ZBatch> batchList = [];
    for (var id in packageDto.batchId) {
      batchList.add(await getBatchZ(id));
    }

    return ZPackage(id: packageDto.id, number: packageDto.number, batchList: batchList, batchListId: packageDto.batchId);
  }



  Future<void> getEquipment(int regionId, int companyId) async{
    final tableEquipment = EquipmentTable(); 
    final queryEquipment = await tableEquipment.selectEq(regionId, companyId);
    List<EquipmentDTO> listEquipmentDto = [];
    for (var element in queryEquipment) {
      final dto = EquipmentDTO.fromMap(element);
      listEquipmentDto.add(dto);
    }

    List<Equipment> listEquipmentModel = [];
    for (var dto in listEquipmentDto) {
      listEquipmentModel.add(Equipment(id: dto.id, inventoryNumber: dto.inventoryNumber, name: dto.name, regionId: dto.regionId, companyId: dto.companyId, userId: dto.userId));
    }

    emit(state.copyWith(listEquipment: listEquipmentModel));
  }

  Future<void> getStatus() async{
    final tableStatus = StatusTable(); 
    final queryStatus = await tableStatus.select();
    List<StatusDTO> listStatusDto = [];
    for (var element in queryStatus) {
      final dto = StatusDTO.fromMap(element);
      listStatusDto.add(dto);
    }

    List<Status> listStatus = [];
    for (var dto in listStatusDto) {
      listStatus.add(Status(id: dto.id, name: dto.name));
    }

    emit(state.copyWith(listStatus: listStatus));
  }

  Future<void> getDetails() async{
    final tableDetails = DetailsTable(); 
    final queryDetails = await tableDetails.select();
    List<DetailsDTO> listDetailsDto = [];
    for (var element in queryDetails) {
      final dto = DetailsDTO.fromMap(element);
      listDetailsDto.add(dto);
    }

    List<Details> listDetails = [];
    for (var dto in listDetailsDto) {
      listDetails.add(Details(id: dto.id, planNumber: dto.planNumber, planName: dto.planName));
    }

    emit(state.copyWith(listDetails: listDetails));
  }

  Future<void> getOperatorOperations() async{
    final tableOperatorOperations = OperatorOperationsTable(); 
    final queryOperatorOperations = await tableOperatorOperations.select();
    List<OperatorOperationsDTO> listOperatorOperationsDto = [];
    for (var element in queryOperatorOperations) {
      final dto = OperatorOperationsDTO.fromMap(element);
      listOperatorOperationsDto.add(dto);
    }

    List<OperatorOperations> listOperatorOperations = [];
    for (var dto in listOperatorOperationsDto) {
      listOperatorOperations.add(OperatorOperations(id: dto.id, order: dto.order, region: dto.regionId.name, company: dto.companyId.shortName, time: dto.time, timeStart: dto.timeStart, timeWorking: dto.timeWorking, status: dto.statusId.name, stageOperationId: dto.stageOperationId, stageMasterOperationId: dto.stageMasterOperationId, equipment: dto.equipmentId.name, details: '${dto.detailsId.planNumber} ${dto.detailsId.planName}'));
    }

    emit(state.copyWith(listoperatorOperations: listOperatorOperations));
  }

  Future<void> getOperatorList() async{
    final tableOperators = UserTable(); 
    final queryOperators = await tableOperators.selectEqOperator(regionId: state.region!.id, companyId: state.company!.id);
    List<UserDTO> listOperatorsDto = [];
    for (var element in queryOperators) {
      final dto = UserDTO.fromMap(element);
      listOperatorsDto.add(dto);
    }

    List<UserModelLite> listOperators = [];
    for (var dto in listOperatorsDto) {
      listOperators.add(UserModelLite(id: dto.id, fio: dto.fio));
    }

    emit(state.copyWith(listOperators: listOperators));
  }

  Future<void> getShiftsDistribution() async{
    final tableShiftsDistribution = ShiftsDistributionTable(); 
    final queryShiftsDistribution = await tableShiftsDistribution.selectEq(state.region!.id, state.company!.id, DateTime.now());
    List<ShiftsDistributionDTO> listShiftsDistributionDto = [];
    for (var element in queryShiftsDistribution) {
      final dto = ShiftsDistributionDTO.fromMap(element);
      listShiftsDistributionDto.add(dto);
    }

    List<ShiftsDistribution> listShiftsDistribution = [];
    for (int i = 0; i < state.listEquipment!.length; i++) {
      bool isWrt = false;
      for (var dto in listShiftsDistributionDto) {
        if (dto.equipment.id == state.listEquipment![i].id) {
          listShiftsDistribution.add(ShiftsDistribution(id: dto.id, change: ChangeModel(id: dto.change.id, name: dto.change.name, number: dto.change.number), date: dto.date, equipment: Equipment(id: dto.equipment.id, inventoryNumber: dto.equipment.inventoryNumber, name: dto.equipment.name, regionId: dto.equipment.regionId, companyId: dto.equipment.companyId, userId: dto.equipment.userId), user: UserModelLite(id: dto.user.id, fio: dto.user.fio), region: Region(id: dto.region.id, name: dto.region.name, number: dto.region.number), company: Company(id: dto.company.id, name: dto.company.shortName, fullName: dto.company.fullName)));
          isWrt = true;
          }
      }
      if (isWrt == false) listShiftsDistribution.add(ShiftsDistribution(id: -1, change: ChangeModel(id: -1, name: '-1', number: -1), date: DateTime.now(), equipment: state.listEquipment![i], user: UserModelLite(id: -1, fio: 'none'), region: Region(id: state.listEquipment![i].regionId, name: '-1', number: '-1'), company: Company(id: state.listEquipment![i].companyId, name: '', fullName:'')));
    }
    
    emit(state.copyWith(listShiftsDistribution: listShiftsDistribution));
  }


// new
  Future<void> getStageMasterOperation() async{
    final tableStageMasterOperations = StageMasterOperationsTable(); 
    final queryStageMasterOperations = await tableStageMasterOperations.select();
    List<StageMasterOperationsDTO> listStageMasterOperationsDto = [];
    for (var element in queryStageMasterOperations) {
      final dto = StageMasterOperationsDTO.fromMap(element);
      listStageMasterOperationsDto.add(dto);
    }

    List<StageMasterOperations> listStageMasterOperations = [];
    for (var dto in listStageMasterOperationsDto) {
      listStageMasterOperations.add(StageMasterOperations(id: dto.id, stageNumber: dto.ststage.stageNumber, operationNumber: dto.operationNumber, operationName: dto.stageDistribution.operationName, planNumber: dto.ststage.planNumber, planName: dto.ststage.planName, operationsListLength: '${dto.stageDistribution.operationsIdList.length}', quantity: '${dto.stageDistribution.quantity}'));
    }

    emit(state.copyWith(listStageMasterOperations: listStageMasterOperations));
  }

  Future<void> getReadyOperations() async{
    final tableReadyOperations = ReadyOperationsTable(); 
    final queryReadyOperations = await tableReadyOperations.selectEq(state.region!.id, state.company!.id, 3);
    List<ReadyOperationsDTO> listReadyOperationsDto = [];
    for (var element in queryReadyOperations) {
      final dto = ReadyOperationsDTO.fromMap(element);
      listReadyOperationsDto.add(dto);
    }

    List<ReadyOperations> listReadyOperations = [];
    for (var dto in listReadyOperationsDto) {
      listReadyOperations.add(ReadyOperations(id: dto.id, timePlan: dto.timePlan, timeFact: dto.timeFact, timeStart: dto.timeStart, timeStop: dto.timeStop, status: dto.statusId.name, stageOperationId: dto.stageOperationId, details: '${dto.detailsId.planNumber} ${dto.detailsId.planName}', equipment: dto.equipmentId.name, user: dto.userId.fio, isUploaded: dto.isUploaded));
    }

    emit(state.copyWith(listReadyOperations: listReadyOperations));
  }

  Future<void> getOperatorsOperations() async{
    final tableOperatorsOperations = OperatorsOperationsTable(); 
    final queryOperatorsOperations = await tableOperatorsOperations.selectEq();
    List<OperatorsOperationsDTO> listOperatorsOperationsDto = [];
    for (var element in queryOperatorsOperations) {
      final dto = OperatorsOperationsDTO.fromMap(element);
      listOperatorsOperationsDto.add(dto);
    }

    List<OperOperations> listOperatorsOperations = [];
    for (var dto in listOperatorsOperationsDto) {
      listOperatorsOperations.add(OperOperations(id: dto.id, operationNumber: dto.operationNumber, order: dto.order, planNumber: dto.planNumber, operationName: dto.operationName, time: dto.time, status: dto.status));
    }

    emit(state.copyWith(listOperOperations: listOperatorsOperations));
  }
}