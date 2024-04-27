import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitOperator extends Cubit<StateOperator> { 
  CubitOperator() : super(const StateOperator());

  void toggleBtn(bool isStarts){
    emit(state.copyWith(isStart: isStarts));
  }
}