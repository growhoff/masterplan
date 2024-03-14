// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateMaster extends Equatable {
  final int change;
  const StateMaster({
    this.change = 0,
  });

  @override
  List<Object> get props => [change];

  StateMaster copyWith({
    int? change,
  }) {
    return StateMaster(
      change: change ?? this.change,
    );
  }

  @override
  bool get stringify => true;
}
