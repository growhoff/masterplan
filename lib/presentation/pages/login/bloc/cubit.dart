import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitLogin extends Cubit<StateLogin> { 
  CubitLogin() : super(StateLogin());

  void setBtn(){
    emit(state.copyWith(isSelect: !state.isSelect));
    Future.delayed(const Duration(seconds: 5)).then((value) => emit(state.copyWith(isSelect: !state.isSelect)));
  }
}