import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitMaster extends Cubit<StateMaster> { 
  CubitMaster() : super(const StateMaster());

  void setChange(int change){
    emit(state.copyWith(change: change));
  }
}