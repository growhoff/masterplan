import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/control_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shift_schedule_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/type_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/view_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/control_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shift_schedule_table.dart';

// import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/data/repositories/supabase/service/type_machine_table.dart';
import 'package:master_plan/data/repositories/supabase/service/version_table.dart';
import 'package:master_plan/data/repositories/supabase/service/view_machine_table.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/area_machine.dart';
// import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/machine.dart';
// import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/staff.dart';
import 'package:master_plan/domain/model/unit.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/domain/usecase/areas_list_service.dart';
import 'package:master_plan/domain/usecase/change_logic.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/domain/usecase/convert_dto_model.dart';
import 'package:path/path.dart';
import '../../../domain/usecase/company_service.dart';
import 'state.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:collection/collection.dart';

class CubitMain extends Cubit<StateMain> {
  CubitMain() : super(const StateMain());

  Future<String> save(String login, String password, String companyS) async {
    final tableVersion = VersionTable();
    final queryVersion = await tableVersion.select();
    if (!equals(queryVersion.first['version'], state.version)) {
      emit(state.copyWith(link: queryVersion.first['link_update']));
      return 'Ошибка_версий';
    } else {
      final tableStaff = StaffTable();
      final query =
          await tableStaff.selectName(login: login, company: companyS);
      if (query == null) {
        return 'Ошибка_авторизации_1'; //ошибка авторизации.нет пользователя
      } else {
        final userModel = StaffDTO.fromMap(query);
        if (userModel.password == password) {
          await getUserNew(userModel);
          switch (state.user!.position.id) {
            //начальник
            case 2:
              await fetchUnitId(state.user!.id);
              List<int> listAreaId = await getAreaForStaff(query['id']);
              await getMachineToUnit(listAreaId);
              await getListsMachine();
              break;
            //мастер
            case 3:
              await getMachineToArea(state.user!.area!);
              // await getMachineToUnit([state.user!.area!.id]);
              await fetchAreasList(state.user!.id);
             // print(AreasListService.instance.areasIdsList);
              // await getOperators(); v21 пока убрал
              final staffModel = Staff.fromDTO(StaffDTO.fromMap(query));
              emit(state.copyWith(staff: staffModel));
              print('Master staffId : ${state.staff?.id}');
              break;
            //оператор
            case 4:
              await getMachineOperatorZ(state.user!.id);
              break;
            //начальник мастер
            case 7:
              await fetchUnitId(query['id']);
              List<int> listAreaId = await getAreaForStaff(query['id']);
              await getMachineToUnit(listAreaId);
              // await getOperatorsToUnit();
              break;
            //ИНАЧЕ
            default:
              break;
          }
          CompanyService.instance.companyId = state.user?.companyId;

          final String result;
          if (state.user?.company.isPaid == false) {
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

  Future<void> getListsMachine()async{
    final typeMachineTable = TypeMachineTable();
    final viewMachineTable = ViewMachineTable();
    final controlMachineTable = ControlMachineTable();
    final shiftScheduleTable = ShiftScheduleTable();

    final queueType = await typeMachineTable.select();
    final queueView = await viewMachineTable.select();
    final queueControl = await controlMachineTable.select();
    final queueShift = await shiftScheduleTable.select();

    List<TypeMachineDTO> listType = [];
    List<ViewMachineDTO> listView = [];
    List<ControlMachineDTO> listControl = [];
    List<ShiftScheduleDTO> listShift = [];
    
    for (var e in queueType) {
      listType.add(TypeMachineDTO.fromMap(e));
    }
    for (var e in queueView) {
      listView.add(ViewMachineDTO.fromMap(e));
    }
    for (var e in queueControl) {
      listControl.add(ControlMachineDTO.fromMap(e));
    }
    for (var e in queueShift) {
      listShift.add(ShiftScheduleDTO.fromMap(e));
    }

    emit(state.copyWith(typeMachineList: listType, viewMachineList: listView, controlMachineList: listControl, shiftScheduleList: listShift));
  }

  //get user
  Future<void> getUserNew(StaffDTO dto) async {
    final list = await getStaffPosition(dto.id);
    Unit? unit;
    Area? area;
    for (var element in list) {
      // if (element.positionId != 7) {
        
      // }
      unit = Unit.fromDTO(element.unit!);
      area = Area.fromDTO(element.area!);
    }
    final userDto = User.fromDTO(dto, unit, area);
    emit(state.copyWith(user: userDto));
  }

  Future fetchUnitId(int staffId) async {
    //
    final positionStaffTable = PositionStaffTable();
    var fetchedList =
        await positionStaffTable.selectByStaffId(staffId: staffId);
    final positionStaffDto = PositionStaffDTO.fromMap(fetchedList.first);
    print('posStaffDto: ${positionStaffDto.unitId}');
    final int unitId = positionStaffDto.unitId ?? 1;
    ChiefUnitService.instance.unitId = unitId;
  }

  // master
  Future<void> getMachineToArea(Area area) async {
    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectMachineToArea(area.id);
    List<Machine> listMachine = [];
    for (var machine in machineQuery) {
      final model = MachineDTO.fromMap(machine);
      listMachine.add(ConvertDtoModel.converterToMachine(model));
    }
    List<int> listId = [];
    for (var machine in listMachine) {
      listId.add(machine.id);
    }

    List<AreaMachine> listAreaMachine = [
      AreaMachine(
        area: Area(
            id: area.id,
            name: area.name,
            number: area.number,
            unitId: area.unitId),
        listMachine: listMachine,
        idListMachine: listId,
      )
    ];

    emit(state.copyWith(machineList: listMachine,machineIdList: listId,listAreaMachine: listAreaMachine));
  }

  // chief && chief-master
  Future<void> getMachineToUnit(List<int> listAreaId) async {
    final areaTable = AreaTable();
    final queruArea = await areaTable.selectUnitId(state.user!.unit!.id);
    List<int> listIdArea = [];
    List<Area> listArea = [];
    for (var maps in queruArea) {
      final model = AreaDTO.fromMap(maps);
      listIdArea.add(model.id);
      listArea.add(Area(
          id: model.id,
          name: model.name,
          number: model.number,
          unitId: model.unitId));
    }
    final machineTable = MachineTable();
    final machineQuery = await machineTable.selectMachineToAreaList(listIdArea);
    List<Machine> listMachine = [];
    for (var machine in machineQuery) {
      final model = MachineDTO.fromMap(machine);
      listMachine.add(ConvertDtoModel.converterToMachine(model));
    }
    List<int> listId = [];
    for (var machine in listMachine) {
      listId.add(machine.id);
    }

    List<AreaMachine> listAreaMachine = [];
    var newMapAreaMach = groupBy(listMachine, (el) => el.areaId);
    newMapAreaMach.forEach((key, value) {
      listAreaMachine.add(AreaMachine(
          area: listArea.firstWhere((element) => element.id == key),
          listMachine: value,
          idListMachine: value.map((e) => e.id).toList()));
    });
    List<AreaMachine> listAreaMachineUser = [];
    for (var areaMachine in listAreaMachine) {
      for (var id in listAreaId) {
        if (areaMachine.area.id == id) listAreaMachineUser.add(areaMachine);
      }
    }

    emit(state.copyWith(
      machineList: listMachine,
      machineIdList: listId,
      listAreaId: listIdArea,
      listArea: listArea,
      listAreaMachine: listAreaMachine,
      listAreaMachineUser: listAreaMachineUser,
    ));
  }

  Future<List<int>> getAreaForStaff(int staffId) async {
    final posStaffTable = PositionStaffTable();
    final posStafQuery = await posStaffTable.selectByStaffId(staffId: staffId);
    Set<int> listIdArea = {};
    for (var pos in posStafQuery) {
      final model = PositionStaffDTO.fromMap(pos);
      listIdArea.add(model.areaId!);
    }
    return listIdArea.toList();
  }

  Future<List<PositionStaffDTO>> getStaffPosition(int staffId) async {
    final posStaffTable = PositionStaffTable();
    final posStafQuery = await posStaffTable.selectByStaffId(staffId: staffId);
    List<PositionStaffDTO> listIdArea = [];
    for (var pos in posStafQuery) {
      final model = PositionStaffDTO.fromMap(pos);
      listIdArea.add(model);
    }
    return listIdArea;
  }

  // chief-master
  // Future<void> getOperatorsToUnit() async {
  //   final staffTable = PositionStaffTable();
  //   int areaID = state.user!.area != null
  //       ? state.user!.area!.id
  //       : state.listAreaId!.first;
  //   final userQuery = await staffTable.selectOperatorsOnArea(areaId: areaID);
  //   List<PositionStaffDTO> userListDto = [];
  //   for (var userDto in userQuery) {
  //     userListDto.add(PositionStaffDTO.fromMap(userDto));
  //   }
  //   List<User> userList = [];
  //   for (var user in userListDto) {
  //     userList.add(User.fromDTO(user.staff, user.unit == null ? null : Unit.fromDTO(user.unit!), user.area == null ? null : Area.fromDTO(user.area!)));
  //   }
  //   emit(state.copyWith(operatorList: userList));
  // }

  Future fetchAreasList(int staffId) async {
    final positionStaffTable = PositionStaffTable();

    List<int> areasIdsList = [];

    var fetchedList = await positionStaffTable.selectAreasForMaster(staffId);
    for (var positionStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(positionStaff);

      areasIdsList.add(positionStaffDto.areaId ?? 0);
    }

    AreasListService.instance.areasIdsList = areasIdsList;
  }

  //master
  // Future<void> getOperators() async {
  //   final staffTable = PositionStaffTable();
  //   int areaID = state.user!.area != null
  //       ? state.user!.area!.id
  //       : state.listAreaId!.first;
  //   final userQuery = await staffTable.selectOperatorsOnArea(areaId: areaID);
  //   List<PositionStaffDTO> userListDto = [];
  //   for (var userDto in userQuery) {
  //     userListDto.add(PositionStaffDTO.fromMap(userDto));
  //   }
  //   List<User> userList = [];
  //   for (var user in userListDto) {
  //     userList.add(User.fromDTO(user.staff, user.unit == null ? null : Unit.fromDTO(user.unit!), user.area == null ? null : Area.fromDTO(user.area!)));
  //   }
  //   emit(state.copyWith(operatorList: userList));
  // }

  //оператор
  Future<void> getMachineOperatorZ(int userId) async {
    // final dateNow = DateTime.now();
    // final dateLast = DateTime(dateNow.year, dateNow.month, dateNow.day - 1);

    // final dateChange1St =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 0);
    // final dateChange1End =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 0);

    // final dateShift1St =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 7, 50);
    // final dateShift1End =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 10);

    // final dateShift2St =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 19, 50);
    // final dateShift2End =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 10);

    // final dateChange2St =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 20, 0);
    // final dateChange2End =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 23, 59);

    // final dateChange2St2 =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 0, 0);
    // final dateChange2End2 =
    // DateTime(dateNow.year, dateNow.month, dateNow.day, 8, 0);

    // DateTime time = dateNow;
    // int change = 1;

    // if (dateNow.isAfter(dateChange1St) && dateNow.isBefore(dateChange1End)) {
    //   print('1 change');
    // }
    // if (dateNow.isAfter(dateChange2St) && dateNow.isBefore(dateChange2End)) {
    //   print('2 change');
    //   change = 2;
    // }
    // if (dateNow.isAfter(dateChange2St2) && dateNow.isBefore(dateChange2End2)) {
    //   print('2 change');
    //   time = dateLast;
    //   change = 2;
    // }
    // if (dateNow.isAfter(dateShift1St) && dateNow.isBefore(dateShift1End)) {
    //   print('1 shift');
    // }
    // if (dateNow.isAfter(dateShift2St) && dateNow.isBefore(dateShift2End)) {
    //   print('2 shift');
    // }

    final changeLog = ChangeLogic(count: 2, firstTime: 8);
    int change = changeLog.getChange();
    DateTime time = changeLog.getDayChange();

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
        machine: ConvertDtoModel.converterToMachine(model.machine!),
        user: User.fromDTO(model.user!, null, null),
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
