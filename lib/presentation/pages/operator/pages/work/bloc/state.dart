// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/operatoroperations.dart';

class StateWork extends Equatable {
    final List<OperatorOperations>? operatorOperations;
  const StateWork({
    this.operatorOperations,
  });

  StateWork copyWith({
    List<OperatorOperations>? operatorOperations,
  }) {
    return StateWork(
      operatorOperations: operatorOperations ?? this.operatorOperations,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [operatorOperations ?? []];
}
