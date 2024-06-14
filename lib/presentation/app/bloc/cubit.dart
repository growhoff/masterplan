import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/version_table.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/staff.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:path/path.dart';
import '../../../domain/usecase/company_service.dart';
import 'state.dart';
import 'package:url_launcher/url_launcher.dart';

class CubitMain extends Cubit<StateMain> {
  CubitMain() : super(const StateMain());

  Future<String> save(String login, String password) async {
    final tableVersion = VersionTable();
    final queryVersion = await tableVersion.select();
    if (!equals(queryVersion.first['version'], state.version)) {
      emit(state.copyWith(link: queryVersion.first['link_update']));
      return 'Ошибка_версий';
    } else {
      final tableStaff = StaffTable();
      final query = await tableStaff.selectName(login: login);
      if (query.isEmpty) {
        return 'Ошибка_авторизации_1'; //ошибка авторизации.нет пользователя
      } else {
        if (query.first['password'] == password) {
          await getUserNew(query.first['user_id']); //ошибка. неверный пароль

          switch (state.user!.position.id) {
            //начальник
            case 2:
              break;
            //мастер
            case 3:
              await getMachineToArea(state.user!.area!.id);
              await getOperators();
              final staffDto = StaffDTO.fromMap(query.first);
              final staffModel = Staff(
                  id: staffDto.id,
                  login: staffDto.login,
                  user: User.empty,
                  userId: staffDto.userId,
                  password: staffDto.password);
              emit(state.copyWith(staff: staffModel));
              print('staffId : ${state.staff?.id}');
              break;
            //оператор
            case 4:
              await getMachineOperatorZ(state.user!.id);
              break;
            //начальник мастер
            case 7:
              await getMachineToUnit();
              // await getOperators();
              break;
            //ИНАЧЕ
            default:
              break;
          }
          CompanyService.instance.companyId = state.user?.companyId;

          final String result;
          if (state.user?.company?.isPaid == false) {
            result = 'не оплачено';
          } else {
            result = state.user!.position.name;
          }

          return result;
        } else {
          return 'Ошибка_авторизации_2'; //ошибка. неверный пароль
        }
      }
    }
  }

  //get user
  Future<void> getUserNew(int id) async {
    final userTable = UserTable();
    final userQuery = await userTable.selectId(id);
    final userDto = UserDTO.fromMap(userQuery.first);
    emit(state.copyWith(user: userDto));
  }

  // master
  Future<void> getMachineToArea(int areaId) async {
    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectMachineToArea(areaId);
    List<Machine> listMachine = [];
    for (var machine in machineQuery) {
      final model = MachineDTO.fromMap(machine);
      listMachine.add(Machine(
          id: model.id,
          inventoryNumber: model.inventoryNumber,
          name: model.name,
          areaId: model.areaId));
    }
    List<int> listId = [];
    for (var machine in listMachine) {
      listId.add(machine.id);
    }
    emit(state.copyWith(machineList: listMachine, machineIdList: listId));
  }

  // chief-master
  Future<void> getMachineToUnit() async {
    final areaTable = AreaTable();
    final queruArea = await areaTable.selectUnitId(state.user!.unit!.id);
    List<int> listIdArea = [];
    for (var maps in queruArea) {
      listIdArea.add(maps['id']);
    }
    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectMachineToAreaList(listIdArea);
    List<Machine> listMachine = [];
    for (var machine in machineQuery) {
      final model = MachineDTO.fromMap(machine);
      listMachine.add(Machine(
          id: model.id,
          inventoryNumber: model.inventoryNumber,
          name: model.name,
          areaId: model.areaId));
    }
    List<int> listId = [];
    for (var machine in listMachine) {
      listId.add(machine.id);
    }

    final userTable = UserTable();
    final userQuery = await userTable.selectEqOperatorList(
        listAreaId: listIdArea, companyId: state.user!.companyId);
    List<UserDTO> userListDto = [];
    for (var userDto in userQuery) {
      userListDto.add(UserDTO.fromMap(userDto));
    }
    List<User> userList = [];
    for (var user in userListDto) {
      userList.add(User(
          id: user.id,
          fio: user.fio,
          positionId: user.positionId,
          companyId: user.companyId,
          unitId: user.unitId,
          areaId: user.areaId,
          photo: user.photo,
          positionModel:
              Position(id: user.position.id, name: user.position.name)));
    }
    emit(state.copyWith(
        machineList: listMachine,
        machineIdList: listId,
        operatorList: userList,
        listAreaId: listIdArea));
  }

  //master
  Future<void> getOperators() async {
    final userTable = UserTable();
    final userQuery = await userTable.selectEqOperator(
        areaId: state.user!.areaId!, companyId: state.user!.companyId);
    List<UserDTO> userListDto = [];
    for (var userDto in userQuery) {
      userListDto.add(UserDTO.fromMap(userDto));
    }
    List<User> userList = [];
    for (var user in userListDto) {
      userList.add(User(
          id: user.id,
          fio: user.fio,
          positionId: user.positionId,
          companyId: user.companyId,
          unitId: user.unitId,
          areaId: user.areaId,
          photo: user.photo,
          positionModel:
              Position(id: user.position.id, name: user.position.name)));
    }
    emit(state.copyWith(operatorList: userList));
  }

  //оператор
  Future<void> getMachineOperatorZ(int userId) async {
    final dateNow = DateTime.now();
    final dateLast = DateTime(dateNow.year, dateNow.month, dateNow.day - 1);

    final dateChange1St =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 0);
    final dateChange1End =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 0);

    final dateShift1St =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 7, 50);
    final dateShift1End =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 10);

    final dateShift2St =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 19, 50);
    final dateShift2End =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 10);

    final dateChange2St =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 0);
    final dateChange2End =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 23, 59);

    final dateChange2St2 =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 0, 0);
    final dateChange2End2 =
        DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 0);

    DateTime time = dateNow;
    int change = 1;

    if (dateNow.isAfter(dateChange1St) && dateNow.isBefore(dateChange1End)) {
      print('1 change');
    }
    if (dateNow.isAfter(dateChange2St) && dateNow.isBefore(dateChange2End)) {
      print('2 change');
      change = 2;
    }
    if (dateNow.isAfter(dateChange2St2) && dateNow.isBefore(dateChange2End2)) {
      print('2 change');
      time = dateLast;
      change = 2;
    }
    if (dateNow.isAfter(dateShift1St) && dateNow.isBefore(dateShift1End)) {
      print('1 shift');
    }
    if (dateNow.isAfter(dateShift2St) && dateNow.isBefore(dateShift2End)) {
      print('2 shift');
    }

    final zshiftsDistributionTable = ShiftsDistributionTable();
    final zshiftsDistributionQuery =
        await zshiftsDistributionTable.selectEqUser(userId, time, change);
    List<ShiftsDistribution> zshiftsDistributionList = [];
    List<int> machineListId = [];
    for (var shiftsDistr in zshiftsDistributionQuery) {
      final model = ShiftsDistributionDTO.fromMap(shiftsDistr);
      zshiftsDistributionList.add(convertToShiftsDistribution(model));
      machineListId.add(model.machine!.id);
    }

    emit(state.copyWith(
        zshiftsDistributionList: zshiftsDistributionList,
        machineIdList: machineListId,
        change: change));
  }

  ShiftsDistribution convertToShiftsDistribution(ShiftsDistributionDTO model) {
    return ShiftsDistribution(
        id: model.id,
        date: model.date,
        machine: Machine(
            id: model.machine!.id,
            inventoryNumber: model.machine!.inventoryNumber,
            name: model.machine!.name,
            areaId: model.machine!.areaId),
        user: User(
            id: model.user!.id,
            fio: model.user!.fio,
            positionId: model.user!.positionId,
            companyId: model.user!.companyId,
            unitId: model.user!.unitId,
            areaId: model.user!.areaId,
            photo: model.user!.photo,
            positionModel: Position(
                id: model.user!.position.id, name: model.user!.position.name)),
        change: model.change!);
  }

  Future<void> goToLink() async {
    final Uri url = Uri.parse(state.link);
    if (!await launchUrl(url)) {
      throw Exception(
          'Ошибка. Не получилось подключиться по данному адресу $url');
    }
  }
}
