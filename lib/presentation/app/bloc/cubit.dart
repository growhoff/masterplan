import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/user_table.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';
// import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';

class CubitMain extends Cubit<StateMain> { 
  CubitMain() : super(StateMain(user: UserModel(id: 0, fio: '', positionId: 0, regionId: 0, companyId: 0)));

    Future<String> save(String login, String password) async{
    final tableStaff = StaffTable();
    final tableUser = UserTable();
    final query = await tableStaff.selectName(login: login);
    if (query == []) {
      //ошибка авторизации.нет пользователя
      return 'Error 1';
    } else{
      if (query[0]['password'] == password){
        //успешная авторизация
        final queryUser = await tableUser.selectId(query[0]['id']);
        final userDto = UserDTO.fromMap(queryUser[0]);
        final user = UserModel(id: userDto.id, fio: userDto.fio, positionId: userDto.positionId, regionId: userDto.regionId, companyId: userDto.companyId);
        emit(state.copyWith(user: user));
        return '${user.positionId}';
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }

}