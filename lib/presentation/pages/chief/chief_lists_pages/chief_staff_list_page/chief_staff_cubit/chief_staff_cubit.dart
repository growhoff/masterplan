import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

// import 'package:gpassword/gpassword.dart';
import 'package:image_picker/image_picker.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/domain/model/position_staff.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';

import 'package:mime/mime.dart';

import '../../../../../../domain/usecase/generate_password_service.dart';
import '../../../../../../data/repositories/supabase/dto/area_dto.dart';

import '../../../../../../data/repositories/supabase/dto/position_dto.dart';
import '../../../../../../data/repositories/supabase/dto/staff_dto.dart';

import '../../../../../../data/repositories/supabase/service/area_table.dart';

import '../../../../../../data/repositories/supabase/service/images_storage.dart';
import '../../../../../../data/repositories/supabase/service/position_table.dart';
import '../../../../../../data/repositories/supabase/service/staff_table.dart';
import '../../../../../../domain/model/area.dart';
import '../../../../../../domain/model/position.dart';


part 'chief_staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit() : super(const StaffState());

  final TextEditingController fioController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AreaTable _areasTable = AreaTable();

  final StaffTable _staffTable = StaffTable();
  final PositionTable _positionTable = PositionTable();
  final PositionStaffTable _positionStaffTable = PositionStaffTable();

  final ImagePicker _imagePicker = ImagePicker();

  final _unitId = ChiefUnitService.instance.unitId;

  final imageStorage = ImageStorage();

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

  final Password _password = Password(length: 4);

  Future<void> fetchAreasAndStaff() async {
    await fetchAreas();
    // fetchStaff();
  }

  Future<void> fetchAreas() async {
    final areas = await _areasTable.selectByUnitId();

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
    print('fetch areas закочнилось');
  }

  Future<void> fetchMasters() async {
    List<PositionStaffModel> positionStaffList = [];

    final areaId = areasMap[selectedArea] ?? 1;
    print(areaId);
    var fetchedList =
        await _positionStaffTable.selectMastersOnArea(areaId: areaId);

    for (var fetchedPositionStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(fetchedPositionStaff);
      final positionStaff = PositionStaffModel.fromDTO(positionStaffDto);
      positionStaffList.add(positionStaff);
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

    for (var fetchedPositionStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(fetchedPositionStaff);
      final positionStaff = PositionStaffModel.fromDTO(positionStaffDto);
      positionStaffList.add(positionStaff);
    }

    emit(state.copyWith(
        status: ChiefStaffStatus.success,
        positionStaffList: positionStaffList));
  }

  Future initOperatorsPage() async {
    await fetchDropDownsItems();
    await fetchOperators();
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

    positionsToSelectList = [];
    positionsToSelectList.addAll(positionsToSelectStartValue);

    if (staffId != null) {
      await fetchStaffPositions(staffId: staffId);
      print('staffId not null : $staffId');
      print(selectedPosition);
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
      positionsToSelectList.removeWhere(
          (position) => position != positionStaffDto.position.name);
      areasForPositionsList.add(
          '${positionStaffDto.area?.number} ${positionStaffDto.area?.name}');
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

    var staffId = await _staffTable.insert(StaffDTO(
      id: 0,
      login: numberController.text,
      fio: fioController.text,
      password: passwordController.text == '' || passwordController.text == ' '
          ? _password.generatePassword()
          : passwordController.text,
      photo: imageUrl,
      positionId: positionsMap[selectedPositionsList.first] ?? 1,
      position: PositionDTO(id: 0, name: ''),
    ));

    for (int i = 0; i < selectedPositionsList.length; i++) {
      await _positionStaffTable.insert(PositionStaffDTO(
          id: 0,
          positionId: positionsMap[selectedPositionsList[i]] ?? 1,
          staffId: staffId,
          position: PositionDTO(id: 0, name: ''),
          staff: StaffDTO(
              id: 0,
              login: '',
              password: '',
              position: PositionDTO(id: 0, name: ''),
              positionId: 0,
              fio: ''),
          areaId: areasMap[areasForPositionsList[i]] ?? 1,
          area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
    }

    fioController.clear();
    numberController.clear();
    passwordController.clear();
    loadedProfileImage = null;
    positionsToSelectList = positionsToSelectStartValue;
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

  Future updateProfileImageFromGallery(
      {required String imageName,
      required int staffId,
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

      await _staffTable.updatePhoto(staffId: staffId, photoUrl: imageUrl);
    }
  }

  Future<void> updateStaff(PositionStaffModel positionStaff) async {
    print('positionstaff: ${positionStaff.positionId}');
    print('selectedPosition: $selectedPosition');

    await _staffTable.update(
        positionStaff.staffId,
        StaffDTO(
          fio: fioController.text == ''
              ? positionStaff.staff.fio
              : fioController.text,
          id: positionStaff.staff.id,
          login: numberController.text == ''
              ? positionStaff.staff.login
              : numberController.text,
          password: passwordController.text == ''
              ? positionStaff.staff.password
              : passwordController.text,
          positionId: positionsMap[selectedPositionsList.first] ??
              positionStaff.positionId,
          position: PositionDTO(id: 0, name: ''),
        ));

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
              positionId: 0,
              position: PositionDTO(id: 0, name: ''),
              fio: ''),
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

      final String? imagePath = positionStaff.staff.photo;

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
    // в список выбранных ролей добавляется выбранная из выпадающего списка роль
    selectedPositionsList.add(positionsToSelectList[index]);

    // в список выбранных участков добавляется значение
    areasForPositionsList.add(state.areasNamesList.first);

    // из списка выбора ролей удаляются все возможные роли кроме выбранной (сделано т.к. у начальника есть возможность
    // выбирать только мастера или оператора, а один человек не может обладать этими ролями одновременно)
    positionsToSelectList
        .removeWhere((position) => position != positionsToSelectList[index]);
  }

  changeAreasDropDownValue(int index, String? value) {
    areasForPositionsList[index] = value ?? areasForPositionsList[index];
  }

  deletePositionElement(int index, String position) {
    areasForPositionsList.removeAt(index);

    selectedPositionsList.removeAt(index);

    if (selectedPositionsList.isEmpty) {
      positionsToSelectList = [];
      positionsToSelectList.addAll(positionsToSelectStartValue);
    }
  }
}
