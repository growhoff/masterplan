// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateOperator extends Equatable {
  final int id;
  const StateOperator({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateOperator copyWith({
    int? id,
  }) {
    return StateOperator(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
