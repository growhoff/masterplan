// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateDistributionDetails extends Equatable {
  final int id;
  const StateDistributionDetails({
    this.id = 0,
  });

  @override
  List<Object> get props => [id];

  StateDistributionDetails copyWith({
    int? id,
  }) {
    return StateDistributionDetails(
      id: id ?? this.id,
    );
  }

  @override
  bool get stringify => true;
}
