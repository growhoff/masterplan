import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_table.dart';
import 'state.dart';
import 'dart:async';

class CubitOperator extends Cubit<StateOperator> {
  final tableShifts = ShiftsTable();
  final int userId;
  late Timer periodicTimer;
  CubitOperator(this.userId) : super(const StateOperator()){
    //таймер
    periodicTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      final date = DateTime.now();
      if ((date.hour == 20 || date.hour == 8) && date.minute == 0) toggleBtn();
    });
  }
  
  void toggleBtn(){
    emit(state.copyWith(isStart: !state.isStart));
    setTable(userId);
  }

  Future<void> setTable(int userId)async{
    
    if (state.isStart){
      final id = await tableShifts.insertToInt(ShiftsDTO(id: 0, userId: userId, timeStart: DateTime.now(), timeEnd: DateTime.now()));
      emit(state.copyWith(idShifts: id));
    } else {
      await tableShifts.updateId(state.idShifts!,DateTime.now());
    }
  }
}