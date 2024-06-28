import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/domain/model/staff.dart';

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
    List<Unit> unitsList = [];

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
                  id: 0,
                  login: 'login',
                  password: 'password',
                  userId: 0,
                  user: UserDTO.empty)));

      unitsList.add(unit);
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

  Future editUnit({required Unit unit}) async {
    print('unit id: ${unit.id}');
    print('text: ${areasQuantityController.text.runtimeType}');

    await _unitTable.update(
        unit.id,
        UnitDTO(
          id: 0,
          companyId: 0,
          number: (unitNumberController.text != '' &&
                  unitNumberController.text != ' ')
              ? unitNumberController.text
              : unit.number,
          name:
              (unitNameController.text != '' && unitNameController.text != ' ')
                  ? unitNameController.text
                  : unit.name,
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
}
