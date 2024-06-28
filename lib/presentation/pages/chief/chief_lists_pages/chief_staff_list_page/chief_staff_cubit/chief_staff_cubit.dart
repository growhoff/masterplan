import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

// import 'package:gpassword/gpassword.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/position_staff.dart';

import 'package:mime/mime.dart';

import '../../../../../../domain/model/unit.dart';
import '../../../../../../domain/usecase/generate_password_service.dart';
import '../../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../../data/repositories/supabase/dto/company_dto.dart';
import '../../../../../../data/repositories/supabase/dto/position_dto.dart';
import '../../../../../../data/repositories/supabase/dto/staff_dto.dart';
import '../../../../../../data/repositories/supabase/dto/user_dto.dart';
import '../../../../../../data/repositories/supabase/service/area_table.dart';

import '../../../../../../data/repositories/supabase/service/images_storage.dart';
import '../../../../../../data/repositories/supabase/service/position_table.dart';
import '../../../../../../data/repositories/supabase/service/staff_table.dart';
import '../../../../../../data/repositories/supabase/service/user_table.dart';
import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/model/position.dart';
import '../../../../../../domain/model/staff.dart';
import '../../../../../../domain/model/user.dart';

part 'chief_staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit({this.isStaffCanBeChief}) : super(const StaffState());

  final TextEditingController fioController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AreaTable _areasTable = AreaTable();

  final StaffTable _staffTable = StaffTable();
  final UserTable _userTable = UserTable();
  final PositionTable _positionTable = PositionTable();
  final PositionStaffTable _positionStaffTable = PositionStaffTable();

  final ImagePicker _imagePicker = ImagePicker();

  final imageStorage = ImageStorage();

  final bool? isStaffCanBeChief;

  final Unit selectedUnit = Unit.empty;

  int activeAreaId = 0;

  String selectedArea = '';
  String selectedPosition = '';

  XFile? loadedProfileImage;

  Map<String, int> areasMap = {};
  Map<String, int> positionsMap = {};

  final List<String> selectedPositionsList = [];
  List<String> positionsToSelectList = [];
  final List<String> positionsToSelectStartValue = ['Мастер', 'Оператор'];
  List<String> areasForPositionsList = [];
  List<Unit> unitsForPositionsList = [];

  final Password _password = Password(length: 4);

  Future<void> fetchAreasAndStaff() async {
    await fetchAreas();
    // fetchStaff();
  }

  Future<void> fetchAreas() async {
    final areas = await _areasTable.select();

    List<Area> areasList = [];
    for (var area in areas) {
      final AreaDTO areaDto = AreaDTO.fromMap(area);
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

  Future<void> fetchMasters() async {
    List<PositionStaffModel> positionStaffList = [];

    final areaId = areasMap[selectedArea] ?? 1;
    var fetchedList =
    await _positionStaffTable.selectMastersOnArea(areaId: areaId);

    for (var fetchedUser in fetchedList) {
      final userDto = PositionStaffDTO.fromMap(fetchedUser);
      final user = PositionStaffModel.fromDTO(userDto);
      positionStaffList.add(user);
    }

    emit(state.copyWith(
        status: ChiefStaffStatus.success,
        positionStaffList: positionStaffList));
  }

  Future<void> fetchOperators() async {
    emit(state
        .copyWith(status: ChiefStaffStatus.loading, positionStaffList: []));
    List<PositionStaffModel> positionStaffList = [];

    final areaId = areasMap[selectedArea] ?? 1;
    var fetchedList =
    await _positionStaffTable.selectOperatorsOnArea(areaId: areaId);

    for (var fetchedUser in fetchedList) {
      final userDto = PositionStaffDTO.fromMap(fetchedUser);
      final user = PositionStaffModel.fromDTO(userDto);
      positionStaffList.add(user);
    }

    emit(state.copyWith(
        status: ChiefStaffStatus.success,
        positionStaffList: positionStaffList));
    print('заэмитило');
  }

  Future fetchDropDownsItems({int? staffId}) async {
    await fetchAreas();

    final areasList = state.areasList;

    List<String> areasNamesList = [];

    for (int i = 0; i < areasList.length; i++) {
      String key = '${areasList[i].number} ${areasList[i].name}';
      areasNamesList.add(key);
      areasMap[key] = areasList[i].id;
    }

    selectedArea = areasNamesList[0];

    List<Position> positionsList = await fetchPositions();

    List<String> positionsNamesList = [];
    for (int i = 0; i < positionsList.length; i++) {
      String key = positionsList[i].name;
      positionsNamesList.add(key);
      positionsMap[key] = positionsList[i].id;
    }

    selectedPosition = positionsNamesList[0];

    if (isStaffCanBeChief == true) {
      positionsToSelectList = ['Начальник', 'Мастер'];
      List<Unit> unitsList = [];
      final unitTable = UnitTable();
      var fetchedUnitList = await unitTable.select();
      for (var fetchedUnit in fetchedUnitList) {
        final fetchedDto = UnitDTO.fromMap(fetchedUnit);
        final unit = Unit(
            id: fetchedDto.id,
            companyId: fetchedDto.companyId,
            name: fetchedDto.name,
            number: fetchedDto.number,
          areasQuantity: fetchedDto.areasQuantity,
          machinesQuantity: fetchedDto.machinesQuantity,
          operatorsQuantity: fetchedDto.operatorsQuantity,
          supportStaffQuantity: fetchedDto.supportStaffQuantity,);
        unitsList.add(unit);
      }
      emit(state.copyWith(unitsList: unitsList));
    } else {
      positionsToSelectList = [];
      positionsToSelectList.addAll(positionsToSelectStartValue);
    }

    if (staffId != null) {
      await fetchStaffPositions(staffId: staffId);
    }

    emit(state.copyWith(
        areasNamesList: areasNamesList, status: ChiefStaffStatus.success));
  }

  Future<List<Position>> fetchPositions() async {
    final positions = await _positionTable.select();

    List<Position> positionsList = [];

    for (int i = 0; i < positions.length; i++) {
      PositionDTO positionDto = PositionDTO.fromMap(positions[i]);

      positionsList.add(Position(id: positionDto.id, name: positionDto.name));
    }

    return positionsList;
  }

  Future<void> fetchStaffPositions({required int staffId}) async {
    var fetchedList =
    await _positionStaffTable.selectByStaffId(staffId: staffId);
    for (var positionsStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(positionsStaff);
      selectedPositionsList.add(positionStaffDto.position.name);

      if (isStaffCanBeChief != true) {
        positionsToSelectList.removeWhere(
                (position) => position != positionStaffDto.position.name);
      }
      areasForPositionsList.add(
          '${positionStaffDto.area?.number} ${positionStaffDto.area?.name}');

      if (isStaffCanBeChief == true) {
        final unit = Unit(id: positionStaffDto.unit?.id ?? 0,
            companyId: positionStaffDto.unit?.companyId ?? 0,
        name: positionStaffDto.unit?.name, number: positionStaffDto.unit?.number);
        unitsForPositionsList.add(unit);
      }

    }

  }

  Future insertStaff() async {
    final String? imageUrl;

    if (loadedProfileImage != null) {
      final imageBytes = await loadedProfileImage?.readAsBytes();

      final imageExtension = lookupMimeType(loadedProfileImage!.path);

      final String supabaseImagePath = '/users_photo/${numberController.text}';

      await imageStorage.uploadBinary(
          path: supabaseImagePath,
          bytes: imageBytes,
          imageExtension: imageExtension);

      imageUrl = await imageStorage.getPublicUrl(path: supabaseImagePath);
    } else {
      imageUrl = null;
    }

    var userId = await _userTable.insert(UserDTO(
        id: 0,
        fio: fioController.text,
        positionId: positionsMap[selectedPosition] ?? 1,
        areaId: areasMap[selectedArea],
        companyId: 1,
        company: CompanyDTO.init(),
        position: PositionDTO(id: 0, name: ''),
        photo: imageUrl,
        unitId: null));

    var staffId = await _staffTable.insert(StaffDTO(
        id: 0,
        login: numberController.text,
        password:
        passwordController.text == '' || passwordController.text == ' '
            ? _password.generatePassword()
            : passwordController.text,
        userId: userId,
        user: UserDTO.empty));

    for (int i = 0; i < selectedPositionsList.length; i++) {
      if (isStaffCanBeChief == true) {
        await _positionStaffTable.insert(PositionStaffDTO(
            id: 0,
            positionId: positionsMap[selectedPositionsList[i]] ?? 1,
            staffId: staffId,
            position: PositionDTO(id: 0, name: ''),
            staff: StaffDTO(
                id: 0,
                login: '',
                password: '',
                userId: 0,
                user: UserDTO.empty),
            unitId: unitsForPositionsList[i].id,
            areaId: areasMap[areasForPositionsList[i]] ?? 1,
            area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
      } else {
        await _positionStaffTable.insert(PositionStaffDTO(
            id: 0,
            positionId: positionsMap[selectedPositionsList[i]] ?? 1,
            staffId: staffId,
            position: PositionDTO(id: 0, name: ''),
            unitId: 0,
            staff: StaffDTO(
                id: 0,
                login: '',
                password: '',
                userId: 0,
                user: UserDTO.empty),
            areaId: areasMap[areasForPositionsList[i]] ?? 1,
            area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
      }
    }

    fioController.clear();
    numberController.clear();
    passwordController.clear();
    selectedPositionsList.clear();
    positionsToSelectList.clear();
    loadedProfileImage = null;
  }

  Future addPhotoFromGallery({required ImageSource imageSource}) async {
    final XFile? image = await _imagePicker.pickImage(source: imageSource);
    if (image == null) {
      print('не удалось загрузить изображение из галереи');
      return;
    } else {
      print(image.path);
      loadedProfileImage = image;
    }
  }

  Future updateProfileImageFromGallery({required String imageName,
    required int userId,
    required ImageSource imageSource}) async {
    final XFile? image = await _imagePicker.pickImage(source: imageSource);
    if (image == null) {
      print('не удалось загрузить изображение из галереи');
      return;
    } else {
      final imageBytes = await image.readAsBytes();

      final String supabaseImagePath = '/users_photo/$imageName';

      final imageExtension = lookupMimeType(image.path);

      await imageStorage.uploadBinary(
          path: supabaseImagePath,
          bytes: imageBytes,
          imageExtension: imageExtension);

      final imageUrl = await imageStorage.getPublicUrl(path: supabaseImagePath);

      await _userTable.updatePhoto(userId: userId, photoUrl: imageUrl);
    }
  }

  Future<void> updateStaff(PositionStaffModel positionStaff) async {
    await _userTable.update(
        positionStaff.staff.userId,
        UserDTO(
            id: positionStaff.staff.user.id,
            fio: fioController.text == ''
                ? positionStaff.staff.user.fio
                : fioController.text,
            positionId: positionsMap[selectedPosition] ?? 1,
            areaId: areasMap[selectedArea],
            companyId: positionStaff.staff.user.companyId,
            position: PositionDTO(id: 0, name: ''),
            photo: '',
            company: CompanyDTO(
              id: 0,
              name: '',
              code: '',
            )));

    await _staffTable.update(
        positionStaff.staffId,
        StaffDTO(
            id: positionStaff.staff.id,
            login: numberController.text == ''
                ? positionStaff.staff.login
                : numberController.text,
            password: passwordController.text == ''
                ? positionStaff.staff.password
                : passwordController.text,
            userId: positionStaff.staff.userId,
            user: UserDTO.empty));

    var fetchedList = await _positionStaffTable.selectByStaffId(
        staffId: positionStaff.staffId);
    for (var positionStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(positionStaff);
      _positionStaffTable.delete(positionStaffDto.id);
    }

    for (int i = 0; i < selectedPositionsList.length; i++) {
      await _positionStaffTable.insert(PositionStaffDTO(
          id: 0,
          positionId: positionsMap[selectedPositionsList[i]] ?? 1,
          staffId: positionStaff.staffId,
          position: PositionDTO(id: 0, name: ''),
          staff: StaffDTO(
              id: 0,
              login: '',
              password: '',
              userId: 0,
              user: UserDTO.empty),
          areaId: areasMap[areasForPositionsList[i]] ?? 1,
          area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
    }
  }

  Future deleteStaff({required PositionStaffModel positionStaff}) async {
    final isHaveAnotherPositions = await _positionStaffTable
        .checkForAnotherRoles(staffId: positionStaff.staffId);
    if (isHaveAnotherPositions) {
      await _positionStaffTable.delete(positionStaff.id);
    } else {
      await _positionStaffTable.deleteByStaffId(staffId: positionStaff.staffId);
      await _staffTable.delete(positionStaff.staffId);
      await _userTable.delete(positionStaff.staff.userId);

      final String? imagePath = positionStaff.staff.user.photo;

      if (imagePath != null) {
        await imageStorage.remove(path: imagePath);
      }
    }

    if (positionStaff.positionId == 3) {
      fetchMasters();
    } else {
      fetchOperators();
    }
  }

  // добавление элемента в список ролей на странице добавление персонала, если осталась одна роль для выбора
  addLastPositionElement() {
    // в список выбранных участков добавляется значение
    areasForPositionsList.add(state.areasNamesList.first);

    // в список выбранных ролей добавляется значение должности(first, так как она там одна)
    selectedPositionsList.add(positionsToSelectList.first);
  }

  // добавление элемента в список ролей на странице добавления персонала
  addPositionElement(int index) {
    print(positionsToSelectList[index]);
    print('1: ${unitsForPositionsList.length}');
    // в список выбранных ролей добавляется выбранная из выпадающего списка роль
    selectedPositionsList.add(positionsToSelectList[index]);

    // в список выбранных участков добавляется значение

    //для мастера, так как у него цеха
    if (positionsMap[positionsToSelectList[index]] == 2) {
      areasForPositionsList.add('');
      unitsForPositionsList.add(state.unitsList.first);
      print('2: ${unitsForPositionsList.length}');
    }
    // для всех остальных
    else {
      areasForPositionsList.add(state.areasNamesList.first);
      unitsForPositionsList.add(Unit.empty);
    }

    // из списка выбора ролей удаляются все возможные роли кроме выбранной (сделано т.к. у начальника есть возможность
    // выбирать только мастера или оператора, а один человек не может обладать этими ролями одновременно)

    if (isStaffCanBeChief == null || isStaffCanBeChief == false) {
      positionsToSelectList
          .removeWhere((position) => position != positionsToSelectList[index]);
    }
  }

  changeAreasDropDownValue(int index, String? value) {
    areasForPositionsList[index] = value ?? areasForPositionsList[index];
  }

  changeUnitsDropDownValue(int index, Unit? value) {
    unitsForPositionsList[index] = value ?? unitsForPositionsList[index];
  }

  deletePositionElement(int index, String position) {
    print(index);
    areasForPositionsList.removeAt(index);
    if (isStaffCanBeChief == true){
      unitsForPositionsList.removeAt(index);
    }
    selectedPositionsList.removeAt(index);

    if (isStaffCanBeChief != true) {
      if (selectedPositionsList.isEmpty) {
        positionsToSelectList = [];
        positionsToSelectList.addAll(positionsToSelectStartValue);
      }
    }
  }
}
