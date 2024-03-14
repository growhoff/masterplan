// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateChoosingOperator extends Equatable {
  final int id;
  const StateChoosingOperator({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateChoosingOperator copyWith({
    int? id,
  }) {
    return StateChoosingOperator(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
