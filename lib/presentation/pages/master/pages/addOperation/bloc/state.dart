// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateAddOperation extends Equatable {
  final int id;
  const StateAddOperation({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateAddOperation copyWith({
    int? id,
  }) {
    return StateAddOperation(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
