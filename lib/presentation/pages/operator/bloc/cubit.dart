import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_table.dart';
import 'state.dart';

class CubitOperator extends Cubit<StateOperator> {
  CubitOperator() : super(const StateOperator());
  final tableShifts = ShiftsTable();

  void toggleBtn(int userId){
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