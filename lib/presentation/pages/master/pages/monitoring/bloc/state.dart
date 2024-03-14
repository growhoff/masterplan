// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateMonitoring extends Equatable {
  final int id;
  const StateMonitoring({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateMonitoring copyWith({
    int? id,
  }) {
    return StateMonitoring(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
