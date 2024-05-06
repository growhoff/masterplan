// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateOperator extends Equatable {
  final bool isStart;
  final int? idShifts;
  const StateOperator({
    this.isStart = false,
    this.idShifts,
  });

  @override
  List<Object> get props => [isStart, idShifts ?? 0];

  StateOperator copyWith({
    bool? isStart,
    int? idShifts,
  }) {
    return StateOperator(
      isStart: isStart ?? this.isStart,
      idShifts: idShifts ?? this.idShifts,
    );
  }

  @override
  bool get stringify => true;
}
