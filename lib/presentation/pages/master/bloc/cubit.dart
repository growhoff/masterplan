import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitMaster extends Cubit<StateMaster> { 
  CubitMaster() : super(const StateMaster());

  void setPage(int index){
    emit(state.copyWith(activePage: index));
  }
}