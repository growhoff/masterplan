import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/z_area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/z_machine_table.dart';
import 'package:master_plan/domain/model/z_machine.dart';

import '../../../../../../data/repositories/supabase/dto2/area_dto.dart';
import '../../../../../../domain/model/z_area.dart';



part 'chief_machine_state.dart';

class ChiefMachineCubit extends Cubit<ChiefMachineState> {
  ChiefMachineCubit() : super(const ChiefMachineState());

  final machineTableStream = ZMachineTable().stream();
  final areaStream = ZAreaTable().stream();
  final ZAreaTable _areaTable = ZAreaTable();
  final ZMachineTable _machineTable = ZMachineTable();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();

  String selectedArea = '';
  Map<String, int> areasMap =
      {}; // ключ - номер участка + его имя, значение - id

  int activeAreaIndex = 0;

  Future<void> fetchAreasAndMachines() async {
    await fetchAreas();

    fetchMachinesList();
    print('area and machines');
  }

  fetchAreas() async {
    final areasSupabaseList = await _areaTable.select();
    List<ZArea> areasList = [];
    for (var item in areasSupabaseList) {
      final areaDto = AreaDTO2.fromMap(item);
      areasList.add(ZArea(
          id: areaDto.id,
          name: areaDto.name,
          number: areaDto.number,
          machineList: [],
          machineListId: areaDto.machineId));
    }

    //  final List<AreaModel> areasList = [];
    // await  areaStream.listen((list) {
    //
    //    for (var item in list) {
    //      final areaDto = AreaDTO2.fromMap(item);
    //      areasList.add(AreaModel(
    //          id: areaDto.id,
    //          name: areaDto.name,
    //          number: areaDto.number,
    //          machineList: [],
    //          machineListId: areaDto.machineId));
    //    }
    //  });

    emit(state.copyWith(areasList: areasList));
  }

  fetchMachinesList() {
    machineTableStream.listen((list) {
      List<ZMachine> machinesList = [];
      for (var item in list) {
        final machineDto = MachineDTO2.fromMap(item);
        if (state.areasList[activeAreaIndex].machineListId
            .contains(machineDto.id)) {
          machinesList.add(ZMachine(
              id: machineDto.id,
              inventoryNumber: machineDto.inventoryNumber,
              name: machineDto.name));
        }
      }

      emit(state.copyWith(machinesList: machinesList));
    });
  }

  Future<void> fetchDropDownItems({int? selectedAreaId}) async {
    List<String> areasNamesList = [];
    var areasList = await _areaTable.select();
    for (var area in areasList) {
      AreaDTO2 areaDto = AreaDTO2.fromMap(area);
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
      MachineDTO2(
          id: 0,
          inventoryNumber: int.parse(numberController.text),
          name: nameController.text),
    );

    await _areaTable.addMachine(
        areaId: areasMap[selectedArea], machineId: machineId);

    nameController.clear();

    numberController.clear();
  }

  Future deleteMachine({required int machineId, required int areaId}) async {
    await _areaTable.removeMachine(areaId: areaId, machineId: machineId);
    await _machineTable.delete(machineId);
  }

  Future updateMachine({
    required ZMachine machine,
    required int oldAreaId,
  }) async {


    if (oldAreaId != areasMap[selectedArea]) {
      await _areaTable.changeMachineArea(
          oldAreaId: oldAreaId,
          newAreaId: areasMap[selectedArea],
          machineId: machine.id);

    }

    await _machineTable.update(
        machine.id,
        MachineDTO2(
            id: machine.id,
            inventoryNumber: numberController.text == ''
                ? machine.inventoryNumber
                : int.parse(numberController.text),
            name: nameController.text == ''
                ? machine.name
                : nameController.text));


  }


}
