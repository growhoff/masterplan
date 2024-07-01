import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitChiefMaster extends Cubit<StateChiefMaster> { 
  CubitChiefMaster() : super(const StateChiefMaster());

  void setPage(int index){
    emit(state.copyWith(activePage: index));
  }
}