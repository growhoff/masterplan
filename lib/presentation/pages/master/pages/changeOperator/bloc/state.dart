// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';

class StateCubitChangeOperator extends Equatable {
  final int change;
  final DateTime days;
  final List<ShiftsMachine>? shiftsList;
  const StateCubitChangeOperator({
    this.change = 1,
    required this.days,
    this.shiftsList = const[]
  });

  @override
  List<Object> get props => [change, days, shiftsList ?? []];

  StateCubitChangeOperator copyWith({
    int? change,
    DateTime? days,
    List<ShiftsMachine>? shiftsList,
  }) {
    return StateCubitChangeOperator(
      change: change ?? this.change,
      days: days ?? this.days,
      shiftsList: shiftsList ?? this.shiftsList,
    );
  }

  @override
  bool get stringify => true;
}
