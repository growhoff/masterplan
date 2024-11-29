// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateTransferOperator extends Equatable {
  final int id;
  const StateTransferOperator({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateTransferOperator copyWith({
    int? id,
  }) {
    return StateTransferOperator(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
