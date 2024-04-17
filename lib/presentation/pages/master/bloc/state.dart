// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateMaster extends Equatable {
  final int change;
  final DateTime days;
  const StateMaster({
    this.change = 1,
    required this.days,
  });

  @override
  List<Object> get props => [change, days];

  StateMaster copyWith({
    int? change,
    DateTime? days,
  }) {
    return StateMaster(
      change: change ?? this.change,
      days: days ?? this.days
    );
  }

  @override
  bool get stringify => true;
}
