import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/monitoring_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/domain/model/status.dart';
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
          case 2: 
            // emit(state.copyWith(unit: await getUnitZ(state.user!.unit!.id)));
            break;
          //мастер
          case 3:
            await getMachineToArea(state.user!.area!.id);
            emit(state.copyWith(shiftsList:  await getShiftsDistribution(state.machineIdList!, DateTime.now())));
            await getOperatorOperations(state.machineIdList!);
            await getOperators();
            await getMonitoring();
            break;
          //оператор
          case 4: await getMachineOperatorZ(state.user!.id); 
            break;
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

  //get user
  Future<void> getUserNew(int id) async{
    final userTable = UserTable();
    final userQuery = await userTable.selectId(id);
    final userDto = UserDTO.fromMap(userQuery.first);
    emit(state.copyWith(user: userDto));
  }

  // master
  Future<void> getMachineToArea(int areaId) async{
    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectMachineToArea(areaId);
    List<Machine> listMachine = [];
    for (var machine in machineQuery) {
      final model = MachineDTO.fromMap(machine);
      listMachine.add(Machine(id: model.id, inventoryNumber: model.inventoryNumber, name: model.name, areaId: model.areaId));
    }
    List<int> listId = [];
    for (var machine in listMachine) {
      listId.add(machine.id);
    }
    emit(state.copyWith(machineList: listMachine, machineIdList: listId));
  }

  // master
  Future<List<ShiftsMachine>> getShiftsDistribution(List<int> machineIdList, DateTime date) async{
    final zshiftsDistributionTable = ShiftsDistributionTable();
    final zshiftsDistributionQuery = await zshiftsDistributionTable.selectList(machineIdList, date);
    
    List<ShiftsDistributionDTO> listDto = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      listDto.add(ShiftsDistributionDTO.fromMap(shiftsDistr));
    }

    List<ShiftsMachine> list = [];
    for (var machine in state.machineList!) {
      ShiftsDistribution? changeOne;
      ShiftsDistribution? changeTwo;
      for (var dto in listDto) {
        if (dto.machineId == machine.id) {
          if (dto.change!.number == 1) changeOne = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), machine: Machine(id: dto.machine!.id, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
          if (dto.change!.number == 2) changeTwo = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), machine: Machine(id: dto.machine!.id, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
        }
      }
      list.add(ShiftsMachine(machine: machine, changeOne: changeOne, changeTwo: changeTwo));
    }
    return list;
  }

  //master
  Future<void> getOperatorOperations(List<int> machineListId) async{
    final operatorOperationsTable = OperatorOperationsTable();
    final operatorOperationsQuery = await operatorOperationsTable.selectListId236(machineListId);
    List<OperatorOperations> operOperListSt2 = [];
    List<OperatorOperations> operOperListSt3 = [];
    List<OperatorOperations> operOperListSt6 = [];
    for (var operatorOper in operatorOperationsQuery) {
      final model = OperatorOperationsDTO.fromMap(operatorOper);
      //Распределение мастер
      if (model.status.id == 2) operOperListSt2.add(convertDto(model));
      //Очередь
      if (model.status.id == 3) operOperListSt3.add(convertDto(model));
      //Готово
      if (model.status.id == 6) operOperListSt6.add(convertDto(model));
    }

    emit(state.copyWith(distribMasterList: operOperListSt2, queueList: operOperListSt3, readyList: operOperListSt6));
  }
  
  //master
  OperatorOperations convertDto(OperatorOperationsDTO dto){
    return OperatorOperations(
          id: dto.id, 
          area: dto.area, 
          operation: dto.operation, 
          stage: dto.stage, 
          timeplan: dto.timeplan, 
          timefact: dto.timefact, 
          timestart: dto.timestart, 
          timestop: dto.timestop, 
          timeworking: dto.timeworking, 
          status: Status(id: dto.status.id, name: dto.status.name), 
          batch: Batch(id: dto.batch.id, number: dto.batch.number, name: dto.batch.name, count: dto.batch.count, code: dto.batch.code, packageId: dto.batch.packageId, technology: dto.batch.technology, order: dto.batch.order, isready: dto.batch.isready),
          user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), 
          order: dto.order, 
          machine: Machine(id: dto.machine!.id, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.areaId),
          );
  }

  //master
  Future<void> getOperators() async{
    final userTable = UserTable();
    final userQuery = await userTable.selectEqOperator(areaId: state.user!.areaId!, companyId: state.user!.companyId);
    List<UserDTO> userListDto = [];
    for (var userDto in userQuery) {
      userListDto.add(UserDTO.fromMap(userDto));
    }
    List<User> userList = [];
    for (var user in userListDto) {
      userList.add(User(id: user.id, fio: user.fio, positionId: user.positionId, companyId: user.companyId, unitId: user.unitId, areaId: user.areaId, photo: user.photo, positionModel: Position(id: user.position.id, name: user.position.name)));
    }
    emit(state.copyWith(operatorList: userList));
  }

  //master
  Future<void> getMonitoring() async{
    final monitoringTable = MonitoringMachineTable();
    final monitoringQuery = await monitoringTable.selectList(state.machineIdList!);
    List<MonitoringMachineDTO> monitorListDto = [];
    for (var monitoringDto in monitoringQuery) {
      monitorListDto.add(MonitoringMachineDTO.fromMap(monitoringDto));
    }
    emit(state.copyWith(monitorList: monitorListDto));
  }

  //оператор
  Future<void> getMachineOperatorZ(int userId) async{
    final zshiftsDistributionTable = ShiftsDistributionTable();
    final zshiftsDistributionQuery = await zshiftsDistributionTable.selectEqUser(userId);
    List<ShiftsDistribution> zshiftsDistributionList = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      final model = ShiftsDistributionDTO.fromMap(shiftsDistr);
      zshiftsDistributionList.add(ShiftsDistribution(id: model.id, date: model.date, machine: Machine(id: model.machine!.id, inventoryNumber: model.machine!.inventoryNumber, name: model.machine!.name, areaId: model.machine!.areaId), user: User(id: model.user!.id, fio: model.user!.fio, positionId: model.user!.positionId, companyId: model.user!.companyId, unitId: model.user!.unitId, areaId: model.user!.areaId, photo: model.user!.photo, positionModel: Position(id: model.user!.position.id, name: model.user!.position.name)), change: model.change!));
    }

    List<int> machineListId = [];
    for (var element in zshiftsDistributionList) {
      machineListId.add(element.machine.id);
    }

    List<OperatorOperations> operatorOperationsList = [];
    if (machineListId.isNotEmpty){
      final zOperatorOperationsTable = OperatorOperationsTable();
      final zOperatorOperationsQuery = await zOperatorOperationsTable.selectListIdMachine3678(machineListId);
      for (var operatorOper in zOperatorOperationsQuery) {
        final model = OperatorOperationsDTO.fromMap(operatorOper);
        operatorOperationsList.add(convertDto(model));
    }
    }

    emit(state.copyWith(zshiftsDistributionList: zshiftsDistributionList, operatorOperationsList: operatorOperationsList));
  }
}