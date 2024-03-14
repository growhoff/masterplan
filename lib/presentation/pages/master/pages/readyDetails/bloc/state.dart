// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateReadyDetails extends Equatable {
  final int id;
  const StateReadyDetails({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateReadyDetails copyWith({
    int? id,
  }) {
    return StateReadyDetails(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
