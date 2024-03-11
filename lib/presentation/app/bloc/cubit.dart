import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/region_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/company_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_table.dart';
import 'package:master_plan/data/repositories/supabase/service/region_table.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';
// import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';

class CubitMain extends Cubit<StateMain> { 
  CubitMain() : super(StateMain(user: UserModel(id: 0, fio: '', position: '', region: '', company: '')));

    Future<String> save(String login, String password) async{

    final tableStaff = StaffTable();
    // final tableUser = UserTable();
    // final tableCompany = CompanyTable();
    // final tableRegion = RegionTable();
    // final tablePosition = PositionTable();

    final query = await tableStaff.selectName(login: login);
    if (query == []) {
      //ошибка авторизации.нет пользователя
      return 'Error 1';
    } else{
      if (query[0]['password'] == password){
        //успешная авторизация
        final user = await getUser(query[0]['id']);
        emit(state.copyWith(user: user));
        return user.position;
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }

  Future<UserModel> getUser(int id) async{
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

    return UserModel(id: userDto.id, fio: userDto.fio, position: positionDto.name, region: regionDto.name, company: companyDto.shortName);
        
  }

}