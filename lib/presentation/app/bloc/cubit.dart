import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/package_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_package_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_shifts_distribution.dart';
import 'package:master_plan/data/repositories/supabase/service/z_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_transfer_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_unit_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_user_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_staff_table.dart';
import 'package:master_plan/domain/model/z_area.dart';
import 'package:master_plan/domain/model/z_batch.dart';
import 'package:master_plan/domain/model/z_machine.dart';
import 'package:master_plan/domain/model/z_operation.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';
import 'package:master_plan/domain/model/z_package.dart';
import 'package:master_plan/domain/model/z_stage.dart';
import 'package:master_plan/domain/model/z_transfer.dart';
import 'package:master_plan/domain/model/z_unit.dart';
import 'state.dart';

class CubitMain extends Cubit<StateMain> {
  CubitMain() : super(const StateMain());

  Future<String> save(String login, String password) async {
    final tableStaff = ZStaffTable();
    final query = await tableStaff.selectName(login: login);
    if (query == []) {
      //ошибка авторизации.нет пользователя
      return 'Error 1';
    } else {
      if (query.first['password'] == password) {
        //успешная авторизация
        await getUserNew(query.first['user_id']);

        switch (state.user!.position.id) {
          //начальник
          case 2:
            emit(state.copyWith(unit: await getUnitZ(state.user!.unit!.id)));
            break;
          //мастер
          case 3:
            emit(state.copyWith(area: await getAreaZ(state.user!.area!.id)));
            await getMasterData();
            break;
          //оператор
          case 4:
            await getMachineOperatorZ(state.user!.id);
            break;
          default:
            break;
        }

        // if (equipment == []) print('Пользователь не закреплен к станкам');
        return state.user!.position.name;
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }

  Future<void> getUserNew(int id) async {
    final userTable = ZUserTable();
    final userQuery = await userTable.selectId(id);
    final userDto = UserDTO2.fromMap(userQuery.first);
    emit(state.copyWith(user: userDto));
  }

  Future<ZUnit> getUnitZ(int unitId) async {
    final unitTable = ZUnitTable();
    final unitQuery = await unitTable.selectId(unitId);
    final unitDto = UnitDTO2.fromMap(unitQuery.first);

    List<ZArea> areaList = [];
    for (var id in unitDto.areaId) {
      areaList.add(await getAreaZ(id));
    }

    return ZUnit(
        id: unitDto.id,
        name: unitDto.name,
        areaList: areaList,
        areaListId: unitDto.areaId);
  }

  Future<ZArea> getAreaZ(int areaId) async {
    final areaTable = ZAreaTable();
    final areaQuery = await areaTable.selectId(areaId);
    final areaDto = AreaDTO2.fromMap(areaQuery.first);

    final machineTable = ZMachineTable();
    final machineQuery = await machineTable.selectListId(areaDto.machineId);
    List<ZMachine> machineList = [];
    for (var machine in machineQuery) {
      final model = MachineDTO2.fromMap(machine);
      machineList.add(ZMachine(
          id: model.id,
          inventoryNumber: model.inventoryNumber,
          name: model.name));
    }
    return ZArea(
        id: areaDto.id,
        name: areaDto.name,
        number: areaDto.number,
        machineList: machineList,
        machineListId: areaDto.machineId);
  }

  Future<ZMachine> getMachineZ(int machineId) async {
    final machineTable = ZMachineTable();
    final machineQuery = await machineTable.selectId(machineId);
    final model = MachineDTO2.fromMap(machineQuery.first);
    return ZMachine(
        id: model.id, inventoryNumber: model.inventoryNumber, name: model.name);
  }

  Future<void> getMachineOperatorZ(int userId) async {
    final zshiftsDistributionTable = ZShiftsDistributionTable();
    final zshiftsDistributionQuery =
        await zshiftsDistributionTable.selectEqUser(userId);
    List<ZShiftsDistributionDTO2> zshiftsDistributionList = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      zshiftsDistributionList.add(ZShiftsDistributionDTO2.fromMap(shiftsDistr));
    }

    List<int> machineListId = [];
    for (var element in zshiftsDistributionList) {
      machineListId.add(element.machine.id);
    }

    List<ZOperatorOperations> operatorOperationsList = [];
    if (machineListId.isNotEmpty) {
      final zOperatorOperationsTable = ZOperatorOperationsTable();
      final zOperatorOperationsQuery =
          await zOperatorOperationsTable.selectListIdSt(machineListId);
      for (var operatorOper in zOperatorOperationsQuery) {
        final model = OperatorOperationsDTO2.fromMap(operatorOper);
        operatorOperationsList.add(ZOperatorOperations(
            id: model.id,
            timeplan: model.timeplan,
            timefact: model.timefact,
            timestart: model.timestart,
            timestop: model.timestop,
            timeworking: model.timeworking,
            status: model.status,
            stageoperationid: model.stageoperationid,
            stagemasteroperationid: model.stagemasteroperationid,
            batch: await getBatchZ(model.batch.id),
            user: model.user,
            isuploaded: model.isuploaded,
            order: model.order,
            machine: model.machine));
      }
    }

    emit(state.copyWith(
        zshiftsDistributionList: zshiftsDistributionList,
        operatorOperationsList: operatorOperationsList));
  }

  Future<void> getMasterData() async {
    final zshiftsDistributionTable = ZShiftsDistributionTable();
    final zshiftsDistributionQuery = await zshiftsDistributionTable.selectList(
        state.area!.machineListId, DateTime.now());
    List<ZShiftsDistributionDTO2> zshiftsDistributionList = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      zshiftsDistributionList.add(ZShiftsDistributionDTO2.fromMap(shiftsDistr));
    }

    final zOperatorOperationsTable = ZOperatorOperationsTable();
    final zOperatorOperationsQuery =
        await zOperatorOperationsTable.selectListId(state.area!.machineListId);
    List<ZOperatorOperations> operatorOperationsList = [];
    for (var operatorOper in zOperatorOperationsQuery) {
      final model = OperatorOperationsDTO2.fromMap(operatorOper);
      operatorOperationsList.add(ZOperatorOperations(
          id: model.id,
          timeplan: model.timeplan,
          timefact: model.timefact,
          timestart: model.timestart,
          timestop: model.timestop,
          timeworking: model.timeworking,
          status: model.status,
          stageoperationid: model.stageoperationid,
          stagemasteroperationid: model.stagemasteroperationid,
          batch: await getBatchZ(model.batch.id),
          user: model.user,
          isuploaded: model.isuploaded,
          order: model.order,
          machine: model.machine));
    }

    emit(state.copyWith(
        zshiftsDistributionList: zshiftsDistributionList,
        operatorOperationsList: operatorOperationsList));
  }

  Future<ZTransfer> getTransferZ(int transferId) async {
    final transferTable = ZTransferTable();
    final transferQuery = await transferTable.selectId(transferId);
    final model = TransferDTO2.fromMap(transferQuery.first);
    return ZTransfer(
        id: model.id,
        number: model.number,
        name: model.name,
        code: model.code,
        timepz: model.timepz,
        timesh: model.timesh);
  }

  Future<ZOperation> getOperationZ(int operationId) async {
    final operationTable = ZOperationTable();
    final operationQuery = await operationTable.selectId(operationId);
    final operationDto = OperationDTO2.fromMap(operationQuery.first);

    final transferTable = ZTransferTable();
    final transferQuery =
        await transferTable.selectListId(operationDto.transferId);
    List<ZTransfer> transferList = [];
    for (var transfer in transferQuery) {
      final model = TransferDTO2.fromMap(transfer);
      transferList.add(ZTransfer(
          id: model.id,
          number: model.number,
          name: model.name,
          code: model.code,
          timepz: model.timepz,
          timesh: model.timesh));
    }
    return ZOperation(
        id: operationDto.id,
        number: operationDto.number,
        name: operationDto.name,
        code: operationDto.code,
        isready: operationDto.isready,
        transferList: transferList,
        transferListId: operationDto.transferId);
  }

  Future<ZStage> getStageZ(int stageId) async {
    final stageTable = ZStageTable();
    final stageQuery = await stageTable.selectId(stageId);
    final stageDto = StageDTO2.fromMap(stageQuery.first);

    List<ZOperation> operationList = [];
    for (var id in stageDto.operationId) {
      operationList.add(await getOperationZ(id));
    }

    return ZStage(
        id: stageDto.id,
        number: stageDto.number,
        code: stageDto.code,
        name: stageDto.name,
        operationList: operationList,
        operationListId: stageDto.operationId);
  }

  Future<ZBatch> getBatchZ(int batchId) async {
    final batchTable = ZBatchTable();
    final batchQuery = await batchTable.selectId(batchId);
    final batchDto = BatchDTO2.fromMap(batchQuery.first);

    List<ZStage> stageList = [];
    for (var id in batchDto.stepId) {
      stageList.add(await getStageZ(id));
    }

    return ZBatch(
        id: batchDto.id,
        number: batchDto.number,
        name: batchDto.name,
        count: batchDto.count,
        code: batchDto.code,
        technology: batchDto.technology,
        order: batchDto.order,
        isready: batchDto.isready,
        stageList: stageList,
        stageListId: batchDto.stepId);
  }

  Future<ZPackage> getPackageZ(int packageId) async {
    final packageTable = ZPackageTable();
    final packageQuery = await packageTable.selectId(packageId);
    final packageDto = PackageDTO2.fromMap(packageQuery.first);

    List<ZBatch> batchList = [];
    for (var id in packageDto.batchId) {
      batchList.add(await getBatchZ(id));
    }

    return ZPackage(
        id: packageDto.id,
        number: packageDto.number,
        batchList: batchList,
        batchListId: packageDto.batchId);
  }
}
