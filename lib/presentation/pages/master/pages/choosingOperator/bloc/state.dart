// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';

class StateChoosingOperator extends Equatable {
  final MachineDTO machine;
  final DateTime time;
  final int change;
  final int user;
  const StateChoosingOperator({
    required this.machine,
    required this.time,
    required this.change,
    required this.user,
  });

  StateChoosingOperator copyWith({
    MachineDTO? machine,
    DateTime? time,
    int? change,
    int? user,
  }) {
    return StateChoosingOperator(
      machine: machine ?? this.machine,
      time: time ?? this.time,
      change: change ?? this.change,
      user: user ?? this.user,
    );
  }


  @override
  bool get stringify => true;

  @override
  List<Object> get props => [machine, time, change, user];
}
