import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
// import 'package:gpassword/gpassword.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mime/mime.dart';

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

class ChiefStaffCubit extends Cubit<ChiefStaffState> {
  ChiefStaffCubit() : super(const ChiefStaffState());

  final TextEditingController fioController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AreaTable _areasTable = AreaTable();

  final StaffTable _staffTable = StaffTable();
  final UserTable _userTable = UserTable();
  final PositionTable _positionTable = PositionTable();

  final ImagePicker _imagePicker = ImagePicker();

  final imageStorage = ImageStorage();

  int activeAreaId = 0;

  String selectedArea = '';
  String selectedPosition = '';

  XFile? loadedProfileImage;

  Map<String, int> areasMap = {};
  Map<String, int> positionsMap = {};

  // final GPassword _gPassword = GPassword(); // генератор пароля (библиотека)
  final Password _password = Password(length: 4);

  Future<void> fetchAreasAndStaff() async {
    await fetchAreas();
    fetchStaff();
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

  Future<void> fetchStaff() async {
    final staff = await _staffTable.selectByRegionId(regionId: activeAreaId);

    List<Staff> staffList = [];
    for (int i = 0; i < staff.length; i++) {
      StaffDTO staffDto = StaffDTO.fromMap(staff[i]);

      staffList.add(Staff(
          id: staffDto.id,
          login: staffDto.login,
          password: staffDto.password,
          userId: staffDto.userId,
          user: User(
              id: staffDto.user.id,
              fio: staffDto.user.fio,
              areaId: staffDto.user.areaId,
              positionId: staffDto.user.positionId,
              companyId: staffDto.user.companyId,
              photo: staffDto.user.photo,
              unitId: staffDto.user.unitId,
              positionModel: Position(
                  id: staffDto.user.position.id,
                  name: staffDto.user.position.name))));
    }

    emit(state.copyWith(staffList: staffList));
  }

  Future fetchDropDownsItems(
      {int? selectedRegionId, int? selectedPositionId}) async {
    await fetchAreas();

    final areasList = state.areasList;

    List<String> areasNamesList = [];

    for (int i = 0; i < areasList.length; i++) {
      String key = '${areasList[i].number} ${areasList[i].name}';
      areasNamesList.add(key);
      areasMap[key] = areasList[i].id;
    }

    if (selectedRegionId == null) {
      selectedArea = areasNamesList[0];
    } else {
      for (final element in areasMap.entries) {
        if (element.value == selectedRegionId) {
          selectedArea = element.key;
          break;
        }
      }
    }

    List<Position> positionsList = await fetchPositions();

    List<String> positionsNamesList = [];
    for (int i = 0; i < positionsList.length; i++) {
      String key = positionsList[i].name;
      positionsNamesList.add(key);
      positionsMap[key] = positionsList[i].id;
    }

    if (selectedPositionId == null) {
      selectedPosition = positionsNamesList[0];
    } else {
      for (final element in positionsMap.entries) {
        if (element.value == selectedPositionId) {
          selectedPosition = element.key;
          break;
        }
      }
    }

    emit(ChiefStaffAddPageState(
        positionsNamesList: positionsNamesList,
        areasNamesList: areasNamesList));
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
        positionId: positionsMap[selectedPosition]!,
        areaId: areasMap[selectedArea],
        companyId: 1,
        company: CompanyDTO.init(),
        position: PositionDTO(id: 0, name: ''),
        photo: imageUrl,
        unitId: null));

    await _staffTable.insert(StaffDTO(
        id: 0,
        login: numberController.text,
        password:
            passwordController.text == '' || passwordController.text == ' '
                 ? _password.generatePassword()

                : passwordController.text,
        userId: userId,
        user: UserDTO.empty));

    fioController.clear();
    numberController.clear();
    passwordController.clear();
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

  Future updateProfileImageFromGallery(
      {required String imageName,
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

  Future updateStaff({required Staff staffModel}) async {
    await _userTable.update(
        staffModel.user.id,
        UserDTO(
            id: staffModel.user.id,
            fio: fioController.text == ''
                ? staffModel.user.fio
                : fioController.text,
            positionId: positionsMap[selectedPosition] ?? 1,
            areaId: areasMap[selectedArea],
            companyId: staffModel.user.companyId,
            position: PositionDTO(id: 0, name: ''),
            photo: '',
            company: CompanyDTO(
              id: 0,
              name: '',
              code: '',
            )));

    await _staffTable.update(
        staffModel.id,
        StaffDTO(
            id: staffModel.id,
            login: numberController.text == ''
                ? staffModel.login
                : numberController.text,
            password: passwordController.text == ''
                ? staffModel.password
                : passwordController.text,
            userId: staffModel.userId,
            user: UserDTO.empty));
  }

  Future deleteStaff(
      {required int staffId,
      required int userId,
      required String? imagePath}) async {
    await _staffTable.delete(staffId);
    await _userTable.delete(userId);
    if (imagePath != null) {
      await imageStorage.remove(path: imagePath);
    }
  }
}
