import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'state.dart';

class CubitMaster extends Cubit<StateMaster> { 
  CubitMaster() : super(StateMaster(days: DateTime.now()));

  void setChange(int change){
    emit(state.copyWith(change: change));
  }

  void setDate(DateTime date){
    emit(state.copyWith(days: date));
  }

  void deleteShifts(int id){
    final shiftsDistributionTable = ShiftsDistributionTable();
    shiftsDistributionTable.delete(id);
  }
}