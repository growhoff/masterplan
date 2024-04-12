// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateOperator extends Equatable {
  final bool isStart;
  const StateOperator({
    this.isStart = false,
  });

  @override
  List<Object> get props => [isStart];

  StateOperator copyWith({
    bool? isStart,
  }) {
    return StateOperator(
      isStart: isStart ?? this.isStart,
    );
  }

  @override
  bool get stringify => true;
}
