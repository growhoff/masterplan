import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/domain/model/area_machine.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/name_index.dart';
// import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/domain/model/shifts_machine_active.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';

class CubitChangeOperator extends Cubit<StateCubitChangeOperator> { 
  // final List<Machine>? machineList;
  // final List<int> machineIdList;
  final List<AreaMachine> listAreaMachine;
  final zshiftsDistributionTable = ShiftsDistributionTable();
  final staffTable = PositionStaffTable();
  CubitChangeOperator( this.listAreaMachine) : super(StateCubitChangeOperator(days: DateTime.now())){
    int max = getMaxChange(listAreaMachine);
    emit(state.copyWith(listAreaMachine: listAreaMachine, maxChange: max));
    setListItemDrop();
    getOperators();
    zshiftsDistributionTable.table.stream(primaryKey: ['id']).inFilter('machine_id', listAreaMachine[state.activeArea].idListMachine).listen((event) {
      }).onData((data)async {
          await getQuere(data);
      });
  }

  int getMaxChange(List<AreaMachine> listAreaMachine){
    int max = 0;
    for (var e in listAreaMachine) {
      for (var ee in e.listMachine) {
        if (max < ee.shiftSchedule!.count) max = ee.shiftSchedule!.count;
      }
    }
    return max;
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
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      List<ShiftsDistributionDTO> listMachineDto = [];
      for (var dto in listDto) {
        if (dto.machineId == machine.id) {listMachineDto.add(dto);}
      }
      list.add(ShiftsMachine(machine: machine, dtoList: listMachineDto));
    }
    emit(state.copyWith(shiftsList: list));
    setActiveList(state.change);
  }
  
  void setActiveList(int change){
    List<ShiftsMachineActive> listActive = [];
    for (var shiftsItem in state.shiftsList!) {
      if (shiftsItem.machine.shiftSchedule!.count >= state.change){
        ShiftsDistribution? changeItem;
        for (var dto in shiftsItem.dtoList) {
          if (dto.change!.number == state.change){
            changeItem = ShiftsDistribution(id: dto.id, date: dto.date, change: dto.change!, user: User.fromDTO(dto.user!, null, null), machine: Machine(id: dto.machine!.id,isActivated: dto.machine!.isActivated, inventoryNumber: dto.machine!.inventoryNumber, name: dto.machine!.name, areaId: dto.machine!.areaId));
          }
        }
        listActive.add(ShiftsMachineActive(machine: shiftsItem.machine, changeItem: changeItem));
      }
    }
    emit(state.copyWith(activeShiftsList: listActive));
  }

  void setChange(int change){
    emit(state.copyWith(change: change));
    setActiveList(change);
  }

  Future<void> setActiveArea(int index) async{
    emit(state.copyWith(activeArea: index, shiftsList: []));
    final queue = await zshiftsDistributionTable.selectListMachineId(listAreaMachine[index].idListMachine);
    await getOperators();
    await getQuere(queue);
  }

  void setListItemDrop() {
    List<NameIndex> listItemArea = [];
    if (state.listAreaMachine.isNotEmpty) {
      for (var i = 0; i < state.listAreaMachine.length; i++) {
        listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
      }
    }
    emit(state.copyWith(listItemArea: listItemArea));
  }


  Future<void> getOperators() async {
    final userQuery = await staffTable.selectOperatorsOnArea(areaId: listAreaMachine[state.activeArea].area.id);
    List<PositionStaffDTO> userListDto = [];
    for (var userDto in userQuery) {
      userListDto.add(PositionStaffDTO.fromMap(userDto));
    }
    List<User> userList = [];
    for (var user in userListDto) {
      userList.add(User.fromDTO(user.staff, null, null));
    }
    emit(state.copyWith(operatorList: userList));
  }


  Future<void> setDate(DateTime date)async{
    final zshiftsDistributionQuery = await zshiftsDistributionTable.selectListIdMachine(state.listAreaMachine[state.activeArea].idListMachine, date);
    List<ShiftsDistributionDTO> listDto = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      listDto.add(ShiftsDistributionDTO.fromMap(shiftsDistr));
    }

    List<ShiftsMachine> list = [];
    for (var machine in listAreaMachine[state.activeArea].listMachine) {
      List<ShiftsDistributionDTO> listMachineDto = [];
      for (var dto in listDto) {
        if (dto.machineId == machine.id) {listMachineDto.add(dto);}
      }
      list.add(ShiftsMachine(machine: machine, dtoList: listMachineDto));
    }
    emit(state.copyWith(days: date, shiftsList: list));
    setActiveList(state.change);
  }

  Future<void> deleteShifts(int id, int index) async{
    List<ShiftsMachineActive> newList = [...state.activeShiftsList];
    newList[index] = ShiftsMachineActive(machine: state.activeShiftsList[index].machine, changeItem: null);
    emit(state.copyWith(activeShiftsList: newList));
    await zshiftsDistributionTable.delete(id);
  }
}