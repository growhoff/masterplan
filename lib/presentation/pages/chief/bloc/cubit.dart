import 'package:flutter_bloc/flutter_bloc.dart';
import 'state.dart';

class CubitChief extends Cubit<StateChief> { 
  CubitChief() : super(const StateChief());

  void setPage(int index){
    emit(state.copyWith(activePage: index));
  }

  void toggleMonitor(){
    emit(state.copyWith(isThisMonitoring: !state.isThisMonitoring));
  }
}