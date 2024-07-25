import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';

class CubitChangeOperator extends Cubit<StateCubitChangeOperator> { 
  final List<Machine>? machineList;
  final List<int> machineIdList;
  final zshiftsDistributionTable = ShiftsDistributionTable();
  CubitChangeOperator(this.machineList, this.machineIdList) : super(StateCubitChangeOperator(days: DateTime.now())){
    zshiftsDistributionTable.table.stream(primaryKey: ['id']).inFilter('machine_id', machineIdList).listen((event) {
      }).onData((data)async {
          await getQuere(data);
      });
  }

  Future<void> getQuere (List<Map<String, dynamic>>? data)async{
    List<int> listId = [];
    for (var element in data!) {listId.add(element['id']);}
    List<Map<String, dynamic>> zshiftsDistributionQuery = [];
    if (listId.isNotEmpty) zshiftsDistributionQuery = await zshiftsDistributionTable.selectListId(listId, state.days);
    List<ShiftsDistributionDTO> listDto = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      listDto.add(ShiftsDistributionDTO.fromMap(shiftsDistr));
    }

    List<ShiftsMachine> list = [];
    for (var machine in machineList!) {
      ShiftsDistribution? changeOne;
      ShiftsDistribution? changeTwo;
      for (var dto in listDto) {
        if (dto.machineId == machine.id) {
          if (dto.change!.number == 1) changeOne = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), machine: Machine(id: dto.machine!.id,isActivated: dto.machine!.isActivated, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
          if (dto.change!.number == 2) changeTwo = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), machine: Machine(id: dto.machine!.id,isActivated: dto.machine!.isActivated, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
        }
      }
      list.add(ShiftsMachine(machine: machine, changeOne: changeOne, changeTwo: changeTwo));
    }
    emit(state.copyWith(shiftsList: list));
  }
  

  void setChange(int change){
    emit(state.copyWith(change: change));
  }

  Future<void> setDate(DateTime date)async{
    final zshiftsDistributionQuery = await zshiftsDistributionTable.selectListIdMachine(machineIdList, date);
    List<ShiftsDistributionDTO> listDto = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      listDto.add(ShiftsDistributionDTO.fromMap(shiftsDistr));
    }

    List<ShiftsMachine> list = [];
    for (var machine in machineList!) {
      ShiftsDistribution? changeOne;
      ShiftsDistribution? changeTwo;
      for (var dto in listDto) {
        if (dto.machineId == machine.id) {
          if (dto.change!.number == 1) changeOne = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), machine: Machine(id: dto.machine!.id,isActivated: dto.machine!.isActivated, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
          if (dto.change!.number == 2) changeTwo = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User(id: dto.user!.id, fio: dto.user!.fio, positionId: dto.user!.positionId, companyId: dto.user!.companyId, unitId: dto.user!.unitId, areaId: dto.user!.areaId, photo: dto.user!.photo, positionModel: Position(id: dto.user!.position.id, name: dto.user!.position.name)), machine: Machine(id: dto.machine!.id, isActivated: dto.machine!.isActivated,inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
        }
      }
      list.add(ShiftsMachine(machine: machine, changeOne: changeOne, changeTwo: changeTwo));
    }
    emit(state.copyWith(days: date, shiftsList: list));
  }

  void deleteShifts(int id){
    zshiftsDistributionTable.delete(id);
  }
}