// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateTableInfo extends Equatable {
  final int count;
  const StateTableInfo({
    this.count = 0,
  });

  @override
  List<Object> get props => [count];

  StateTableInfo copyWith({
    int? count,
  }) {
    return StateTableInfo(
      count: count ?? this.count,
    );
  }

  @override
  bool get stringify => true;
}
