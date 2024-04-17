import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'state.dart';

class CubitChoosingOperator extends Cubit<StateChoosingOperator> {
  final MachineDTO machine;
  final DateTime time;
  final int change;
  CubitChoosingOperator(this.change, this.machine, this.time) : super(StateChoosingOperator(change: change, machine: machine, time: time, user: -1));

  void saveUser(int userId){
    emit(state.copyWith(user: userId));
  }

  void insertTable(){
    final tableShifts = ShiftsDistributionTable();
    tableShifts.insert(ZShiftsDistributionDTO(id: 0, date: time, changeId: change, machineId: machine.id, userId: state.user, change: null, machine: null, user: null));
  }
}