import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto/control_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shift_schedule_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/type_machine_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/view_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/company_table.dart';
import 'package:master_plan/domain/model/name_index.dart';
import 'package:master_plan/domain/model/view_machine.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';

import '../../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../../data/repositories/supabase/dto/machine_dto.dart';
import '../../../../../../data/repositories/supabase/service/area_table.dart';
import '../../../../../../data/repositories/supabase/service/machine_table.dart';
import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/model/machine.dart';

part 'chief_machine_state.dart';

class ChiefMachineCubit extends Cubit<ChiefMachineState> {
  ChiefMachineCubit(this.listControl, this.listShiftSch, this.listViewMachine) : super(const ChiefMachineState()){
    getList();
  }

  final List<ControlMachineDTO> listControl;
  // final List<TypeMachineDTO> listType;
  // final List<ViewMachineDTO> listView;
  final List<ViewMachine> listViewMachine;
  final List<ShiftScheduleDTO> listShiftSch;

  final machineTableStream = MachineTable().stream();
  final _companyTable = CompanyTable();
  final areaStream = AreaTable().stream();
  final AreaTable _areaTable = AreaTable();
  final MachineTable _machineTable = MachineTable();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController prefixController = TextEditingController();

  bool isActivated = false;
  int paidMachinesQuantity = 0;
  int activatedMachinesQuantity = 0;

  final int? _companyId = CompanyService.instance.companyId;

  String selectedArea = '';
  Map<String, int> areasMap = {}; // ключ - номер участка + его имя, значение - id

  int activeAreaId = 0;
  //
  int? activeTypeMachineId;
  int? activeShiftScheduleId;
  int? activeViewId;
  int? activeControlId;

  void getList(){
    List<NameIndex> listControlName = [];
    for (var e in listControl) {
      listControlName.add(NameIndex(name: e.name, index: e.id));
    }
    List<NameIndex> listViewName = [];
    for (var e in listViewMachine) {
      listViewName.add(NameIndex(name: e.name, index: e.id));
    }
    List<NameIndex> listShiftSchName = [];
    for (var e in listShiftSch) {
      listShiftSchName.add(NameIndex(name: e.info, index: e.id));
    }
    List<NameIndex> listTypeName = [];
    for (var e in listViewMachine[state.activeView].listType) {
      listTypeName.add(NameIndex(name: e.name, index: e.id));
    }
    emit(state.copyWith(listControl: listControlName, listShiftSch: listShiftSchName, listType: listTypeName, listView: listViewName));
  }

  Future<void> fetchAreasAndMachines() async {
    await fetchAreas();
    fetchMachinesList();
  }

  void getNewlistViewMachine(index){
    int next = 0;
    for (var i = 0; i < listViewMachine.length; i++) {
      if (listViewMachine[i].id == index) next = i;
    }
    List<NameIndex> listTypeName = [];
    for (var e in listViewMachine[next].listType) {
      listTypeName.add(NameIndex(name: e.name, index: e.id));
    }
    activeTypeMachineId = null;
    emit(state.copyWith(activeView: next, listType: listTypeName));
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
          if (machineDto.areaId == activeAreaId) {
            machinesList.add(ConvertDtoModel.converterToMachine(machineDto));
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

    paidMachinesQuantity = await _companyTable.fetchPaidMachinesQuantityByCompanyId(_companyId ?? 0);

    activatedMachinesQuantity = await _machineTable.fetchActivatedMachinesByCompanyId();
    print('paid : $paidMachinesQuantity');

    print('activated : $activatedMachinesQuantity');
    emit(state.copyWith(areasNamesList: areasNamesList));
  }

  Future insertMachine() async {
    await _machineTable.insert(
      MachineDTO(
          id: 0,
          inventoryNumber: int.parse(numberController.text),
          name: nameController.text,
          isActivated: isActivated,
          areaId: areasMap[selectedArea] ?? 1,
            model: modelController.text,
            prefix: prefixController.text,
            viewId: activeViewId,
            controlId: activeControlId,
            typeMachineId: activeTypeMachineId,
            shiftScheduleId: activeShiftScheduleId,
      ),
    );
    nameController.clear();
    numberController.clear();
  }

  bool chekCreateMachine(){
    if (modelController.text != '' && prefixController.text != '' && activeViewId != null && activeControlId != null && activeTypeMachineId != null && activeShiftScheduleId != null) {return true;}
    else{return false;}
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
            isActivated: isActivated,
            inventoryNumber: numberController.text == ''
                ? machine.inventoryNumber
                : int.parse(numberController.text),
            name: nameController.text == '' ? machine.name : nameController.text,
            areaId: areasMap[selectedArea] ?? machine.id,
            model: modelController.text == '' ? machine.model : modelController.text,
            prefix: prefixController.text == '' ? machine.prefix : prefixController.text,
            viewId: activeViewId,
            controlId: activeControlId,
            typeMachineId: activeTypeMachineId,
            shiftScheduleId: activeShiftScheduleId,
            ));
  }
}
