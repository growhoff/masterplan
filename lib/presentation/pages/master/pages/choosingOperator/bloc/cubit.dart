import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/shifts_distribution.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/user.dart';
import 'state.dart';

class CubitChoosingOperator extends Cubit<StateChoosingOperator> {
  final Machine machine;
  final DateTime time;
  final int change;
  final List<User> operatorList;
  CubitChoosingOperator(this.change, this.machine, this.time, this.operatorList) : super(StateChoosingOperator(change: change, machine: machine, time: time, user: -1, operatorList: operatorList));

  void saveUser(int userId){
    emit(state.copyWith(user: userId));
  }

  Future<void> insertTable()async{
    final tableShifts = ShiftsDistributionTable();
    final quere = await tableShifts.selectEqMachineTimeChange(machine.id, time, change);
    if (quere.isEmpty){await tableShifts.insert(ShiftsDistributionDTO(id: 0, date: time, changeId: change, machineId: machine.id, userId: state.user, change: null, machine: null, user: null));}
    else {await tableShifts.updateUser(quere.first['id'], state.user);}
  }
}