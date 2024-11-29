import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';

import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';

import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/position_staff.dart';
import 'package:master_plan/domain/model/unit.dart';

import '../../../../../../data/repositories/supabase/dto/position_dto.dart';
import '../../../../../../data/repositories/supabase/dto/position_staff_dto.dart';
import '../../../../../../data/repositories/supabase/dto/staff_dto.dart';
import '../../../../../../data/repositories/supabase/service/area_table.dart';
import '../../../../../../data/repositories/supabase/service/staff_table.dart';
import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/usecase/generate_password_service.dart';
import '../chief_unit_and_area_model.dart';

part 'chiefs_list_state.dart';

class ChiefsListCubit extends Cubit<ChiefsListState> {
  ChiefsListCubit() : super(const ChiefsListState());

  Unit selectedUnit = Unit.empty;

  final TextEditingController fioController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<Unit> unitsList = [];
  List<Area> areasList = [];

  final _unitTable = UnitTable();
  final _areaTable = AreaTable();

  final _staffTable = StaffTable();
  final _positionStaffTable = PositionStaffTable();

  List<ChiefUnitAndAreaModel> positionsList = [];

  Area selectedArea = Area(id: 0, name: '', number: '', unitId: 0);

  Map<int, Unit> unitsMap = {};
  Map<int, Area> areasMap = {};

  final Password _password = Password(length: 4);

  final List<String> positionsToSelectStartValue = ['Начальник', 'Мастер'];

  List<String> positionsToSelectList = [];

  List<Area> areasForPositionsList = [];

  List<String> selectedPositionsList = [];

  Future fetchChiefsList() async {
    List<PositionStaffModel> chiefsList = [];

    var fetchedList =
        await _positionStaffTable.selectChiefOnUnit(selectedUnit.id);
    for (var fetchedStaff in fetchedList) {
      final staffDto = PositionStaffDTO.fromMap(fetchedStaff);
      final staff = PositionStaffModel.fromDTO(staffDto);
      chiefsList.add(staff);
    }

    emit(state.copyWith(
        status: ChiefsListStatus.success, chiefsList: chiefsList));
  }

  Future fetchAreas(int unitId, {int? index}) async {
    List<Area> areasList = [];

    var fetchedAreasList = await _areaTable.selectUnitId(unitId);

    for (var fetchedArea in fetchedAreasList) {
      final areaDto = AreaDTO.fromMap(fetchedArea);
      final area = Area(
          id: areaDto.id,
          name: areaDto.name,
          number: areaDto.number,
          unitId: areaDto.unitId);
      areasList.add(area);
      areasMap[area.id] = area;
    }

    print('fromFetch: ${areasList}');

    if (index != null) {
      positionsList[index].availableAreasList = areasList;
    }

    emit(state.copyWith(areasList: areasList));
  }

  Future fetchUnits() async {
    List<Unit> unitsList = [];
    var fetchedList = await _unitTable.select();

    for (var fetchedUnit in fetchedList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);
      final unit = Unit(
        id: unitDto.id,
        name: unitDto.name,
        number: unitDto.number,
        companyId: unitDto.companyId,
        areasQuantity: unitDto.areasQuantity,
        machinesQuantity: unitDto.machinesQuantity,
        operatorsQuantity: unitDto.operatorsQuantity,
        supportStaffQuantity: unitDto.supportStaffQuantity,
      );
      unitsList.add(unit);
      unitsMap[unit.id] = unit;
    }

    emit(state.copyWith(unitsList: unitsList));
  }

  fetchAreasAndUnits({int? staffId}) async {
    emit(state.copyWith(status: ChiefsListStatus.initial));

    await fetchUnits();

    await fetchAreas(selectedUnit.id);

    if (staffId != null) {
      await fetchStaffPositions(staffId: staffId);
    } else {
      positionsToSelectList.add('Начальник');
    }

    emit(state.copyWith(status: ChiefsListStatus.success));
  }

  initEditPage(int staffId) async {
    print(staffId);
    emit(state.copyWith(status: ChiefsListStatus.initial));
    List<PositionStaffModel> positionsStaffList = [];
    var fetchedList = await _positionStaffTable.selectChiefAndMastersByStaffId(
        staffId: staffId);

    for (var positionsStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(positionsStaff);
      final positionStaff = PositionStaffModel.fromDTO(positionStaffDto);
      positionsStaffList.add(positionStaff);
    }

    await fetchUnits();

    selectedUnit = unitsMap[positionsStaffList.first.unitId]!;
    await fetchAreas(selectedUnit.id);
    for (var positionStaff in positionsStaffList) {
      selectedPositionsList.add(positionStaff.position.name);
      areasForPositionsList.add(areasMap[positionStaff.areaId] ??
          Area(id: 0, name: '', number: '', unitId: 0));
    }

    positionsToSelectList = ['Мастер'];
    emit(state.copyWith(status: ChiefsListStatus.success));
  }

  addAreaToList(Area? area, {required int modelIndex, required int areaIndex}) {
    emit(state.copyWith(status: ChiefsListStatus.loading));
    if (areaIndex == positionsList[modelIndex].selectedAreasList.length) {
      positionsList[modelIndex].selectedAreasList.add(Area.empty);
    }
    positionsList[modelIndex].selectedAreasList[areaIndex] = area ?? Area.empty;
    emit(state.copyWith(status: ChiefsListStatus.success));
  }

  Future selectUnit(int index, Unit? unit) async {
    selectedUnit = unit ?? Unit.empty;
    if (index == positionsList.length) {
      positionsList.add(ChiefUnitAndAreaModel());
    }
    positionsList[index].unit = unit ?? Unit.empty;
    print('positionsList: $positionsList');

    await fetchAreas(unit?.id ?? selectedUnit.id, index: index);
  }

  Future<void> fetchStaffPositions({required int staffId}) async {
    print(areasMap);
    var fetchedList = await _positionStaffTable.selectChiefAndMastersByStaffId(
        staffId: staffId);

    for (var positionsStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(positionsStaff);
      selectedPositionsList.add(positionStaffDto.position.name);

      areasForPositionsList.add(areasMap[positionStaffDto.areaId] ??
          Area(id: 0, name: '', number: '', unitId: selectedUnit.id));
      selectedUnit = unitsMap[positionStaffDto.unitId] ?? Unit.empty;
      print(areasForPositionsList.last.id);
    }
  }

  Future<void> updateStaff(PositionStaffModel positionStaff) async {
    int positionId = 2;
    if (selectedPositionsList.contains('Начальник') &&
        selectedPositionsList.contains('Мастер')) {
      positionId = 7;
    } else {
      positionId = selectedPositionsList.contains('Начальник') ? 2 : 3;
    }

    print('selectedPositionsList : ${selectedPositionsList}');

    await _staffTable.updateWithPositionId(
        positionStaff.staffId,
        StaffDTO(
          fio: fioController.text,
          id: 0,
          login: numberController.text,
          password:
              passwordController.text == '' || passwordController.text == ' '
                  ? _password.generatePassword()
                  : passwordController.text,
          positionId: positionId,
          position: PositionDTO(id: 0, name: ''),
        ));

    var fetchedList = await _positionStaffTable.selectByStaffId(
        staffId: positionStaff.staffId);
    for (var positionStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(positionStaff);
      _positionStaffTable.delete(positionStaffDto.id);
    }

    for (int i = 0; i < selectedPositionsList.length; i++) {
      print('area id : ${areasForPositionsList[i].id}');
      await _positionStaffTable.insertChief(PositionStaffDTO(
          id: 0,
          positionId: selectedPositionsList[i] == 'Начальник' ? 2 : 3,
          staffId: positionStaff.staffId,
          position: PositionDTO(id: 0, name: ''),
          staff: StaffDTO(
              id: 0,
              login: '',
              password: '',
              position: PositionDTO(id: 0, name: ''),
              positionId: 0,
              fio: ''),
          areaId: areasForPositionsList[i].id == 0
              ? null
              : areasForPositionsList[i].id,
          unitId: selectedUnit.id,
          area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
    }
  }

  Future initChiefsListsPage() async {
    await fetchUnits();
    fetchChiefsList();
  }

  Future insertStaff() async {
    int positionId = 2;

    if (selectedPositionsList.contains('Начальник') &&
        selectedPositionsList.contains('Мастер')) {
      positionId = 7;
    } else {
      positionId = selectedPositionsList.contains('Начальник') ? 2 : 3;
    }

    var staffId = await _staffTable.insert(StaffDTO(
      id: 0,
      login: numberController.text,
      password: passwordController.text == '' || passwordController.text == ' '
          ? _password.generatePassword()
          : passwordController.text,
      positionId: positionId,
      position: PositionDTO(id: 0, name: ''),
      fio: fioController.text,
    ));

    for (int i = 0; i < selectedPositionsList.length; i++) {
      await _positionStaffTable.insertChief(PositionStaffDTO(
          id: 0,
          positionId: selectedPositionsList[i] == 'Начальник' ? 2 : 3,
          staffId: staffId,
          position: PositionDTO(id: 0, name: ''),
          staff: StaffDTO(
              id: 0,
              login: '',
              password: '',
              positionId: 0,
              position: PositionDTO(id: 0, name: ''),
              fio: ''),
          areaId: areasForPositionsList.isNotEmpty
              ? areasForPositionsList[i].id
              : 1,
          unitId: selectedUnit.id,
          area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
    }

    fioController.clear();
    numberController.clear();
    passwordController.clear();
    selectedPositionsList.clear();
    positionsToSelectList.clear();
  }

  Future insertStaffNew() async {
    int positionId = 2;

    for (var position in positionsList) {
      if (position.selectedAreasList.isNotEmpty) {
        positionId = 7;
      }
    }

    var staffId = await _staffTable.insert(StaffDTO(
      id: 0,
      login: numberController.text,
      password: passwordController.text == '' || passwordController.text == ' '
          ? _password.generatePassword()
          : passwordController.text,
      positionId: positionId,
      position: PositionDTO(id: 0, name: ''),
      fio: fioController.text,
    ));

    List<PositionStaffDTO> positionStaffDtosList = [];

    for (var position in positionsList) {
      positionStaffDtosList.add(PositionStaffDTO(
          id: 0,
          positionId: 2,
          staffId: staffId,
          unitId: position.unit.id,
          position: PositionDTO(id: 0, name: ''),
          staff: StaffDTO(
              id: 0,
              login: '',
              password: '',
              fio: '',
              positionId: 0,
              position: PositionDTO(id: 0, name: ''))));
      if (position.selectedAreasList.isNotEmpty) {
        for (var area in position.selectedAreasList) {
          positionStaffDtosList.add(PositionStaffDTO(
              id: 0,
              positionId: 3,
              staffId: staffId,
              position: PositionDTO(id: 0, name: ''),
              areaId: area.id,
              staff: StaffDTO(
                  id: 0,
                  login: '',
                  password: '',
                  fio: '',
                  positionId: 0,
                  position: PositionDTO(id: 0, name: ''))));
        }
      }
    }

    await _positionStaffTable.bulkInsert(positionStaffDtosList);

    fioController.clear();
    numberController.clear();
    passwordController.clear();
    selectedPositionsList.clear();
    positionsToSelectList.clear();
  }

  changeAreasDropDownValue(int index, Area? value) {
    areasForPositionsList[index] = value ?? areasForPositionsList[index];
  }

  Future changeUnitsDropDownValue(int index, Unit? value) async {
    selectedUnit = value ?? selectedUnit;
    await fetchAreas(value?.id ?? selectedUnit.id);
    areasForPositionsList = [];
    for (int i = 0; i < selectedPositionsList.length; i++) {
      if (state.areasList.isNotEmpty) {
        areasForPositionsList.add(state.areasList.first);
      }
    }
  }

  addPositionElement(int index) {
    // в список выбранных ролей добавляется выбранная из выпадающего списка роль

    selectedPositionsList.add(positionsToSelectList[index]);
    if (positionsToSelectList[index] == 'Начальник') {
      positionsToSelectList = positionsToSelectStartValue;
    }

    // в список выбранных участков добавляется значение

    if (state.areasList.isNotEmpty) {
      areasForPositionsList.add(state.areasList.first);
    } else {
      areasForPositionsList
          .add(Area(id: 0, name: '', number: '', unitId: selectedUnit.id));
    }
    print(selectedPositionsList);
  }

  deletePositionElement(int index, String position) {
    if (areasForPositionsList.isNotEmpty) {
      areasForPositionsList.removeAt(index);
    }

    selectedPositionsList.removeAt(index);
    if (selectedPositionsList.isEmpty) {
      positionsToSelectList = ['Начальник'];
    }
  }

  Future deleteStaff({
    required int staffId,
    required int positionStaffId,
  }) async {
    await _positionStaffTable.delete(positionStaffId);
    await _staffTable.delete(staffId);

    await fetchChiefsList();
  }
}
