// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateOperator extends Equatable {
  final bool isStart;
  final int? idShifts;
  final bool emptyStart;
  final bool emptyStop;
  final bool updateStart;
  final int? idUpdate;
  const StateOperator({
    this.isStart = false,
    this.idShifts,
    this.emptyStart = true,
    this.emptyStop = true,
    this.updateStart = false,
    this.idUpdate,
  });

  @override
  List<Object> get props => [isStart, idShifts ?? 0, emptyStart, emptyStop, updateStart, idUpdate ?? -1];

  StateOperator copyWith({
    bool? isStart,
    int? idShifts,
    bool? emptyStart,
    bool? emptyStop,
    bool? updateStart,
    int? idUpdate,
  }) {
    return StateOperator(
      isStart: isStart ?? this.isStart,
      idShifts: idShifts ?? this.idShifts,
      emptyStart: emptyStart ?? this.emptyStart,
      emptyStop: emptyStop ?? this.emptyStop,
      updateStart: updateStart ?? this.updateStart,
      idUpdate: idUpdate ?? this.idUpdate,
    );
  }

  @override
  bool get stringify => true;
}
