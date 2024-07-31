import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';

import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/domain/model/staff.dart';
import 'package:master_plan/presentation/pages/dispatcher/lists_page/units_list_page/unit_model.dart';

import '../../../../../../data/repositories/supabase/service/unit_table.dart';
import '../../../../../../domain/model/unit.dart';

part 'units_state.dart';

class UnitsCubit extends Cubit<UnitsState> {
  UnitsCubit() : super(const UnitsState());

  Staff selectedStaff = Staff.empty;

  final TextEditingController unitNumberController = TextEditingController();
  final TextEditingController unitNameController = TextEditingController();
  final TextEditingController areasQuantityController = TextEditingController();
  final TextEditingController operatorsQuantityController =
      TextEditingController();

  final _unitTable = UnitTable();
  final _positionStaffTable = PositionStaffTable();
  final _areaTable = AreaTable();
  final _machineTable = MachineTable();

  Future fetchUnits() async {
    var fetchedList = await _unitTable.select();

    List<int> unitsIdList = [];
    List<UnitModel> unitsList = [];

    for (var fetchedUnit in fetchedList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);

      final unit = Unit(
          id: unitDto.id,
          companyId: unitDto.companyId,
          name: unitDto.name,
          number: unitDto.number,
          areasQuantity: unitDto.areasQuantity,
          machinesQuantity: unitDto.machinesQuantity,
          operatorsQuantity: unitDto.operatorsQuantity,
          supportStaffQuantity: unitDto.supportStaffQuantity,
          chief: Staff.fromDTO(unitDto.staff ??
              StaffDTO(
                  fio: '',
                  id: 0,
                  login: 'login',
                  password: 'password',
                  positionId: 0,
                  position: PositionDTO(id: 0, name: ''))));

      unitsIdList.add(unit.id);
      unitsList.add(UnitModel(
          chiefId: unit.chief?.id ?? 0,
          unitId: unit.id,
          unitName: unit.name ?? '',
          unitNumber: unit.number ?? '',
          chiefFIO: unit.chief?.fio ?? ''));
    }

    print(unitsIdList);

    var fetchedAreasList = await _areaTable.selectByUnitIdList(unitsIdList);
    List<AreaDTO> areasList = [];
    for (var fetchedArea in fetchedAreasList) {
      final areaDto = AreaDTO.fromMap(fetchedArea);
      areasList.add(areaDto);
    }

    var areasMap = groupBy(areasList, (area) => area.unitId);

    var fetchedMachinesList =
        await _machineTable.selectByUnitIdList(unitsIdList);
    List<MachineDTO> machinesList = [];
    for (var fetchedMachine in fetchedMachinesList) {
      final machineDto = MachineDTO.fromMap(fetchedMachine);
      machinesList.add(machineDto);
    }

    var machinesMap = groupBy(machinesList, (machine) => machine.area?.unitId);

    var fetchedOPositionStaffList =
        await _positionStaffTable.selectStaffByUnitsIdList(unitsIdList);

    List<PositionStaffDTO> allFetchedStaff = [];
    List<PositionStaffDTO> operatorsList = [];
    List<PositionStaffDTO> supportStaffList = [];
    for (var fetchedPositionStaff in fetchedOPositionStaffList) {
      final positionStaffDto = PositionStaffDTO.fromMap(fetchedPositionStaff);

      switch (positionStaffDto.positionId) {
        case 3:
          supportStaffList.add(positionStaffDto);
        case 4:
          operatorsList.add(positionStaffDto);
      }
    }

    var operatorsMap =
        groupBy(operatorsList, (operator) => operator.area?.unitId);

    operatorsMap.forEach((key, value) {
      print(key);
    });

    var supportStaffMap =
        groupBy(supportStaffList, (staff) => staff.area?.unitId);

    for (var unit in unitsList) {
      unit.areasQuantity = areasMap[unit.unitId]?.length ?? 0;

      unit.operatorsQuantity = operatorsMap[unit.unitId]?.length ?? 0;

      unit.machinesQuantity = machinesMap[unit.unitId]?.length ?? 0;

      unit.supportStaffQuantity = supportStaffMap[unit.unitId]?.length ?? 0;
    }

    emit(state.copyWith(unitsList: unitsList, status: UnitsStatus.success));
  }

  Future fetchChiefs({int? selectedStaffId}) async {
    var fetchedChiefList = await _positionStaffTable.selectAllChiefs();

    List<Staff> staffList = [];

    for (var fetchedStaff in fetchedChiefList) {
      final positionStaffDto = PositionStaffDTO.fromMap(fetchedStaff);
      final staff = Staff.fromDTO(positionStaffDto.staff);
      if (staff.id == selectedStaffId) {
        selectedStaff = staff;
      }
      staffList.add(staff);
    }
    if (selectedStaffId == null) {
      selectedStaff = staffList.first;
    }
    ;
    emit(state.copyWith(chiefsList: staffList));
  }

  Future editUnit({required UnitModel unit}) async {
    await _unitTable.update(
        unit.unitId,
        UnitDTO(
          id: 0,
          companyId: 0,
          number: (unitNumberController.text != '' &&
                  unitNumberController.text != ' ')
              ? unitNumberController.text
              : unit.unitNumber,
          name:
              (unitNameController.text != '' && unitNameController.text != ' ')
                  ? unitNameController.text
                  : unit.unitName,
          areasQuantity: (areasQuantityController.text != '' &&
                  areasQuantityController.text != ' ')
              ? int.parse(areasQuantityController.text)
              : unit.areasQuantity,
          operatorsQuantity: (operatorsQuantityController.text != '' &&
                  operatorsQuantityController.text != ' ')
              ? int.parse(operatorsQuantityController.text)
              : unit.operatorsQuantity,
          staffId: selectedStaff.id,
        ));
  }

  Future addUnit() async {
    await _unitTable.insert(UnitDTO(
        id: 0,
        companyId: 0,
        name: unitNameController.text,
        number: unitNumberController.text,
        areasQuantity: (areasQuantityController.text != '' &&
                areasQuantityController.text != ' ')
            ? int.parse(areasQuantityController.text)
            : 0,
        operatorsQuantity: (operatorsQuantityController.text != '' &&
                operatorsQuantityController.text != ' ')
            ? int.parse(operatorsQuantityController.text)
            : 0,
        staffId: selectedStaff.id));
  }

  Future deleteUnit(UnitModel unit) async {
    await _unitTable.delete(unit.unitId);
  }
}
