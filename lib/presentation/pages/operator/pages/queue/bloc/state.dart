// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateEqueueOperator extends Equatable {
  final int id;
  const StateEqueueOperator({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateEqueueOperator copyWith({
    int? id,
  }) {
    return StateEqueueOperator(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
