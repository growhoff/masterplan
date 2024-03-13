import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/details_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/equipment_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/region_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/company_table.dart';
import 'package:master_plan/data/repositories/supabase/service/details_table.dart';
import 'package:master_plan/data/repositories/supabase/service/equipment_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_table.dart';
import 'package:master_plan/data/repositories/supabase/service/region_table.dart';
import 'package:master_plan/data/repositories/supabase/service/status_table.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/details.dart';
import 'package:master_plan/domain/model/equipment.dart';
import 'package:master_plan/domain/model/operatoroperations.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/region.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';

class CubitMain extends Cubit<StateMain> { 
  CubitMain() : super(const StateMain());

    Future<String> save(String login, String password) async{
    final tableStaff = StaffTable();
    final query = await tableStaff.selectName(login: login);
    if (query == []) {
      //ошибка авторизации.нет пользователя
      return 'Error 1';
    } else{
      if (query[0]['password'] == password){
        //успешная авторизация
        
        await getUser(query[0]['id']);
        await getEquipment(state.region!.id, state.company!.id);
        await getStatus();
        await getDetails();
        await getOperatorOperations();

        // if (equipment == []) print('Пользователь не закреплен к станкам');
        return state.position!.name;
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }

  Future<void> getUser(int id) async{
    final tableUser = UserTable();
    final tableCompany = CompanyTable();
    final tableRegion = RegionTable();
    final tablePosition = PositionTable();

    final queryUser = await tableUser.selectId(id);
    final userDto = UserDTO.fromMap(queryUser[0]);

    final queryCompany = await tableCompany.selectId(userDto.companyId);
    final queryRegion = await tableRegion.selectId(userDto.regionId);
    final queryPosition = await tablePosition.selectId(userDto.positionId);

    final companyDto = CompanyDTO.fromMap(queryCompany[0]);
    final regionDto = RegionDTO.fromMap(queryRegion[0]);
    final positionDto = PositionDTO.fromMap(queryPosition[0]);

    final user = UserModel(id: userDto.id, fio: userDto.fio, position: positionDto.name, region: regionDto.name, company: companyDto.shortName);
    final company = Company(id: companyDto.id, name: companyDto.shortName, fullName: companyDto.fullName);
    final region = Region(id: regionDto.id, name: regionDto.name, number: regionDto.number);
    final position = Position(id: positionDto.id, name: positionDto.name);

    emit(state.copyWith(user: user, company: company, region: region, position: position));
  }

  Future<void> getEquipment(int regionId, int companyId) async{
    final tableEquipment = EquipmentTable(); 
    final queryEquipment = await tableEquipment.selectEq(regionId, companyId);
    List<EquipmentDTO> listEquipmentDto = [];
    for (var element in queryEquipment) {
      final dto = EquipmentDTO.fromMap(element);
      listEquipmentDto.add(dto);
    }

    List<Equipment> listEquipmentModel = [];
    for (var dto in listEquipmentDto) {
      listEquipmentModel.add(Equipment(id: dto.id, inventoryNumber: dto.inventoryNumber, name: dto.name, regionId: dto.regionId, companyId: dto.companyId, userId: dto.userId));
    }

    emit(state.copyWith(listEquipment: listEquipmentModel));
  }

  Future<void> getStatus() async{
    final tableStatus = StatusTable(); 
    final queryStatus = await tableStatus.select();
    List<StatusDTO> listStatusDto = [];
    for (var element in queryStatus) {
      final dto = StatusDTO.fromMap(element);
      listStatusDto.add(dto);
    }

    List<Status> listStatus = [];
    for (var dto in listStatusDto) {
      listStatus.add(Status(id: dto.id, name: dto.name));
    }

    emit(state.copyWith(listStatus: listStatus));
  }

  Future<void> getDetails() async{
    final tableDetails = DetailsTable(); 
    final queryDetails = await tableDetails.select();
    List<DetailsDTO> listDetailsDto = [];
    for (var element in queryDetails) {
      final dto = DetailsDTO.fromMap(element);
      listDetailsDto.add(dto);
    }

    List<Details> listDetails = [];
    for (var dto in listDetailsDto) {
      listDetails.add(Details(id: dto.id, planNumber: dto.planNumber, planName: dto.planName));
    }

    emit(state.copyWith(listDetails: listDetails));
  }

  Future<void> getOperatorOperations() async{
    final tableOperatorOperations = OperatorOperationsTable(); 
    final queryOperatorOperations = await tableOperatorOperations.select();
    List<OperatorOperationsDTO> listOperatorOperationsDto = [];
    for (var element in queryOperatorOperations) {
      final dto = OperatorOperationsDTO.fromMap(element);
      listOperatorOperationsDto.add(dto);
    }

    List<OperatorOperations> listOperatorOperations = [];
    for (var dto in listOperatorOperationsDto) {
      listOperatorOperations.add(OperatorOperations(id: dto.id, order: dto.order, region: dto.regionId.name, company: dto.companyId.shortName, time: dto.time, timeStart: dto.timeStart, timeWorking: dto.timeWorking, status: dto.statusId.name, stageOperationId: dto.stageOperationId, stageMasterOperationId: dto.stageMasterOperationId, equipment: dto.equipmentId.name, details: '${dto.detailsId.planNumber} ${dto.detailsId.planName}'));
    }

    emit(state.copyWith(operatorOperations: listOperatorOperations));
  }
}