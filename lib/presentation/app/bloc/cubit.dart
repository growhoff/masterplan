import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/package_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/package_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operation.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/package.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/stage.dart';
import 'package:master_plan/domain/model/transfer.dart';
import 'package:master_plan/domain/model/unit.dart';
import 'package:master_plan/domain/model/user.dart';
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

        switch(state.user!.position.id){
          //начальник
         // case 2: emit(state.copyWith(unit: await getUnitZ(state.user!.unit!.id)));
          //  break;
          //мастер
          //case 3: emit(state.copyWith(area: await getAreaZ(state.user!.area!.id)));
            //await getMasterData();
           // await getOperators();
         //   break;
          //оператор
       //   case 4: await getMachineOperatorZ(state.user!.id);
          //  break;
          default: break;
        }
        
        // if (equipment == []) print('Пользователь не закреплен к станкам');
        return state.user!.position.name;
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }

  Future<void> getUserNew(int id) async{
    final userTable = UserTable();
    final userQuery = await userTable.selectId(id);
    final userDto = UserDTO.fromMap(userQuery.first);
    emit(state.copyWith(user: userDto));
  }

  // Future<Unit> getUnitZ(int unitId) async{
  //   final unitTable = UnitTable();
  //   final unitQuery = await unitTable.selectId(unitId);
  //   final unitDto = UnitDTO.fromMap(unitQuery.first);
  //
  //   List<Area> areaList = [];
  //   for (var id in unitDto.areaId) {
  //     areaList.add(await getAreaZ(id));
  //   }
  //
  //   return Unit(id: unitDto.id, name: unitDto.name, areaList: areaList, areaListId: unitDto.areaId);
  // }
  //
  // Future<Area> getAreaZ(int areaId) async{
  //   final areaTable = AreaTable();
  //   final areaQuery = await areaTable.selectId(areaId);
  //   final areaDto = AreaDTO.fromMap(areaQuery.first);
  //
  //   final machineTable = MachineTable();
  //   final machineQuery = await machineTable.selectListId(areaDto.machineId);
  //   List<Machine> machineList = [];
  //   for (var machine in machineQuery) {
  //     final model = MachineDTO.fromMap(machine);
  //     machineList.add(Machine(id: model.id, inventoryNumber: model.inventoryNumber, name: model.name));
  //   }
  //   return Area(id: areaDto.id, name: areaDto.name, number: areaDto.number, machineList: machineList, machineListId: areaDto.machineId);
  // }
  //
  // Future<Machine> getMachineZ(int machineId) async{
  //   final machineTable = MachineTable();
  //   final machineQuery = await machineTable.selectId(machineId);
  //   final model = MachineDTO.fromMap(machineQuery.first);
  //   return Machine(id: model.id, inventoryNumber: model.inventoryNumber, name: model.name);
  // }
  //
  // Future<void> getMachineOperatorZ(int userId) async{
  //   final zshiftsDistributionTable = ShiftsDistributionTable();
  //   final zshiftsDistributionQuery = await zshiftsDistributionTable.selectEqUser(userId);
  //   List<ZShiftsDistributionDTO> zshiftsDistributionList = [];
  //   for (var shiftsDistr in zshiftsDistributionQuery) {
  //     zshiftsDistributionList.add(ZShiftsDistributionDTO.fromMap(shiftsDistr));
  //   }
  //
  //   List<int> machineListId = [];
  //   for (var element in zshiftsDistributionList) {
  //     machineListId.add(element.machine!.id);
  //   }
  //
  //   List<OperatorOperations> operatorOperationsList = [];
  //   if (machineListId.isNotEmpty){
  //     final zOperatorOperationsTable = OperatorOperationsTable();
  //     final zOperatorOperationsQuery = await zOperatorOperationsTable.selectListIdSt(machineListId);
  //     for (var operatorOper in zOperatorOperationsQuery) {
  //       final model = OperatorOperationsDTO.fromMap(operatorOper);
  //       operatorOperationsList.add(OperatorOperations(id: model.id, timeplan: model.timeplan, timefact: model.timefact, timestart: model.timestart, timestop: model.timestop, timeworking: model.timeworking, status: model.status, batch: await getBatchZ(model.batch.id), user: model.user, isuploaded: model.isuploaded, order: model.order, machine: model.machine));
  //     }
  //   }
  //
  //   emit(state.copyWith(zshiftsDistributionList: zshiftsDistributionList, operatorOperationsList: operatorOperationsList));
  // }
  //
  // Future<void> getMasterData() async{
  //   final zshiftsDistributionTable = ShiftsDistributionTable();
  //   final zshiftsDistributionQuery = await zshiftsDistributionTable.selectList(state.area!.machineListId, DateTime.now());
  //   List<ZShiftsDistributionDTO> zshiftsDistributionList = [];
  //   for (var shiftsDistr in zshiftsDistributionQuery) {
  //     zshiftsDistributionList.add(ZShiftsDistributionDTO.fromMap(shiftsDistr));
  //   }
  //
  //
  //   final zOperatorOperationsTable = OperatorOperationsTable();
  //   final zOperatorOperationsQuery = await zOperatorOperationsTable.selectListId(state.area!.machineListId);
  //   List<OperatorOperations> operatorOperationsList = [];
  //   for (var operatorOper in zOperatorOperationsQuery) {
  //     final model = OperatorOperationsDTO.fromMap(operatorOper);
  //     operatorOperationsList.add(OperatorOperations(id: model.id, timeplan: model.timeplan, timefact: model.timefact, timestart: model.timestart, timestop: model.timestop, timeworking: model.timeworking, status: model.status, batch: await getBatchZ(model.batch.id), user: model.user, isuploaded: model.isuploaded, order: model.order, machine: model.machine));
  //   }
  //
  //   emit(state.copyWith(zshiftsDistributionList: zshiftsDistributionList, operatorOperationsList: operatorOperationsList));
  // }
  //
  // Future<Transfer> getTransferZ(int transferId) async{
  //     final transferTable = TransferTable();
  //     final transferQuery = await transferTable.selectId(transferId);
  //     final model = TransferDTO.fromMap(transferQuery.first);
  //     return Transfer(id: model.id, number: model.number, name: model.name, code: model.code, timesh: model.timesh);
  // }
  //
  // Future<Operation> getOperationZ(int operationId) async{
  //   final operationTable = OperationTable();
  //   final operationQuery = await operationTable.selectId(operationId);
  //   final operationDto = OperationDTO.fromMap(operationQuery.first);
  //
  //   final transferTable = TransferTable();
  //   final transferQuery = await transferTable.selectListId(operationDto.transferId);
  //   List<Transfer> transferList = [];
  //   for (var transfer in transferQuery) {
  //     final model = TransferDTO.fromMap(transfer);
  //     transferList.add(Transfer(id: model.id, number: model.number, name: model.name, code: model.code, timesh: model.timesh));
  //   }
  //   return Operation(id: operationDto.id, timepz: operationDto.timepz, number: operationDto.number, name: operationDto.name, code: operationDto.code, isready: operationDto.isready, transferList: transferList, transferListId: operationDto.transferId);
  // }
  //
  // Future<Stage> getStageZ(int stageId) async{
  //   final stageTable = StageTable();
  //   final stageQuery = await stageTable.selectId(stageId);
  //   final stageDto = StageDTO.fromMap(stageQuery.first);
  //
  //   List<Operation> operationList = [];
  //   for (var id in stageDto.operationId) {
  //     operationList.add(await getOperationZ(id));
  //   }
  //
  //   return Stage(id: stageDto.id, isdistributed: stageDto.isdistributed, areaId: stageDto.areaId, number: stageDto.number, operationList: operationList, operationListId: stageDto.operationId, name: stageDto.name);
  // }
  //
  // Future<Batch> getBatchZ(int batchId) async{
  //   final batchTable = BatchTable();
  //   final batchQuery = await batchTable.selectId(batchId);
  //   final batchDto = BatchDTO.fromMap(batchQuery.first);
  //
  //   List<Stage> stageList = [];
  //   for (var id in batchDto.stageId) {
  //     stageList.add(await getStageZ(id));
  //   }
  //
  //   return Batch(id: batchDto.id, number: batchDto.number, name: batchDto.name, count: batchDto.count, code: batchDto.code, technology: batchDto.technology, order: batchDto.order, isready: batchDto.isready, stageList: stageList, stageListId: batchDto.stageId);
  // }
  //
  // Future<Package> getPackageZ(int packageId) async{
  //   final packageTable = PackageTable();
  //   final packageQuery = await packageTable.selectId(packageId);
  //   final packageDto = PackageDTO.fromMap(packageQuery.first);
  //
  //   List<Batch> batchList = [];
  //   for (var id in packageDto.batchId) {
  //     batchList.add(await getBatchZ(id));
  //   }
  //
  //   return Package(id: packageDto.id, number: packageDto.number, batchList: batchList, batchListId: packageDto.batchId);
  // }
  //
  // Future<void> getOperators() async{
  //   final userTable = UserTable();
  //   final userQuery = await userTable.selectEqOperator(areaId: state.user!.areaId!, companyId: state.user!.companyId);
  //   List<UserDTO> userListDto = [];
  //   for (var userDto in userQuery) {
  //     userListDto.add(UserDTO.fromMap(userDto));
  //   }
  //   List<User> userList = [];
  //   for (var user in userListDto) {
  //     userList.add(User(id: user.id, fio: user.fio, positionId: user.positionId, companyId: user.companyId, unitId: user.unitId, areaId: user.areaId, photo: user.photo, positionModel: Position(id: user.position.id, name: user.position.name)));
  //   }
  //   emit(state.copyWith(operatorList: userList));
  // }
  
}