import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/local/service/sher_pref.dart';
import 'state.dart';

class CubitLogin extends Cubit<StateLogin> {
  SharedPreferencesCustom shPr = SharedPreferencesCustom();
  CubitLogin() : super(StateLogin()){
    // String login =  '';
    // String password =  '';
    // String company =  '';
    shPr.getLogin().then((value) => emit(state.copyWith(login: value)));
    shPr.getPass().then((value) => emit(state.copyWith(password: value)));
    shPr.getCompany().then((value) => emit(state.copyWith(company: value)));
    // emit(state.copyWith(login: login, password: password, company: company));
  }

  void changeLogin(String value){
    emit(state.copyWith(login: value));
  }

  void changePassword(String value){
    emit(state.copyWith(password: value));
  }

  void changeCompany(String value){
    emit(state.copyWith(company: value));
  }

  void setBtn(String login, String password, String company){
    shPr.set(login: login, password: password,company: company);
    emit(state.copyWith(isSelect: !state.isSelect, login: login, password: password, company: company));
    Future.delayed(const Duration(seconds: 4)).then((value) => emit(state.copyWith(isSelect: !state.isSelect)));
  }
}