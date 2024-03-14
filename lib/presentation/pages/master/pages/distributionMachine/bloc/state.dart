// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateDistributionMachine extends Equatable {
  final int id;
  const StateDistributionMachine({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateDistributionMachine copyWith({
    int? id,
  }) {
    return StateDistributionMachine(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
