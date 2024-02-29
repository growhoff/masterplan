import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/staff_table.dart';
import 'dart:js_interop';

class CubitMain extends Cubit<StateMain> { 
  CubitMain() : super(StateMain(user: UserModel(number: 'none', fio: 'none', region: 0, position: 'none', company: 'none')));

    Future<String> save(String login, String password) async{
    final table = StaffTable();
    final query = await table.selectName(login: login);
    if (query.isNull) {
      //ошибка авторизации.нет пользователя
      return 'Error 1';
    } else{
      if (query[0]['password'] == password){
        //успешная авторизация
        final staff = StaffDTO.fromMap(query[0]);
        final users = UserModel(number: staff.number, fio: staff.fio, region: staff.region, position: staff.position, company: staff.company);
        emit(state.copyWith(user: users));
        return users.position;
      } else {
        //ошибка. неверный пароль
        return 'Error 2';
      }
    }
  }

}