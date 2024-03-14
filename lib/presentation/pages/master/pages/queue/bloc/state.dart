// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateQueueMaster extends Equatable {
  final int id;
  const StateQueueMaster({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateQueueMaster copyWith({
    int? id,
  }) {
    return StateQueueMaster(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
