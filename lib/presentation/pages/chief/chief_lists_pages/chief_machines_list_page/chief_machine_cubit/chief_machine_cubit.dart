import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../../data/repositories/supabase/dto/machine_dto.dart';
import '../../../../../../data/repositories/supabase/service/area_table.dart';
import '../../../../../../data/repositories/supabase/service/machine_table.dart';
import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/model/machine.dart';

part 'chief_machine_state.dart';

class ChiefMachineCubit extends Cubit<ChiefMachineState> {
  ChiefMachineCubit() : super(const ChiefMachineState());

  final machineTableStream = MachineTable().stream();
  final areaStream = AreaTable().stream();
  final AreaTable _areaTable = AreaTable();
  final MachineTable _machineTable = MachineTable();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  String selectedArea = '';
  Map<String, int> areasMap =
      {}; // ключ - номер участка + его имя, значение - id

  int activeAreaId = 0;

  Future<void> fetchAreasAndMachines() async {
    await fetchAreas();

    fetchMachinesList();

  }

  fetchAreas() async {
    final areasFetchedList = await _areaTable.selectByUnitId();
    List<Area> areasList = [];
    for (var item in areasFetchedList) {
      final areaDto = AreaDTO.fromMap(item);
      areasList.add(Area(
        id: areaDto.id,
        name: areaDto.name,
        number: areaDto.number,
        unitId: areaDto.unitId,
      ));
    }

    activeAreaId = areasList[0].id;

    emit(state.copyWith(areasList: areasList));
  }

  fetchMachinesList() {
    machineTableStream.listen((list) {
      List<Machine> machinesList = [];
      for (var item in list) {
        final machineDto = MachineDTO.fromMap(item);
        {
          if (machineDto.areaId == activeAreaId){
            machinesList.add(Machine(
                id: machineDto.id,
                inventoryNumber: machineDto.inventoryNumber,
                name: machineDto.name,
                areaId: machineDto.areaId));
          }
        }
      }

      emit(state.copyWith(machinesList: machinesList));
    });
  }

  Future<void> fetchDropDownItems({int? selectedAreaId}) async {
    List<String> areasNamesList = [];
    var areasList = await _areaTable.selectByUnitId();
    for (var area in areasList) {
      AreaDTO areaDto = AreaDTO.fromMap(area);
      String key = '${areaDto.number} ${areaDto.name}';
      areasNamesList.add(key);
      areasMap[key] = areaDto.id;
    }

    if (selectedAreaId == null) {
      selectedArea = areasNamesList[0];
    } else {
      for (final element in areasMap.entries) {
        if (element.value == selectedAreaId) {
          selectedArea = element.key;
          break;
        }
      }
    }
    emit(state.copyWith(areasNamesList: areasNamesList));
  }

  Future insertMachine() async {
    int machineId = await _machineTable.insert(
      MachineDTO(
          id: 0,
          inventoryNumber: int.parse(numberController.text),
          name: nameController.text,
          areaId: areasMap[selectedArea] ?? 1),
    );


    nameController.clear();

    numberController.clear();
  }

  Future deleteMachine({required int machineId, required int areaId}) async {
    await _machineTable.delete(machineId);
  }

  Future updateMachine({
    required Machine machine,
  }) async {

    await _machineTable.update(
        machine.id,
        MachineDTO(
            id: machine.id,
            inventoryNumber: numberController.text == ''
                ? machine.inventoryNumber
                : int.parse(numberController.text),
            name:
                nameController.text == '' ? machine.name : nameController.text,
            areaId: areasMap[selectedArea] ?? machine.id));
  }
}
