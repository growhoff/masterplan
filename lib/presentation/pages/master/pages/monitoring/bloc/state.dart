// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';

class StateMonitoring extends Equatable {
  final List<ElementBarData>? listBar;
  final DateTime days;
  final int change;
  const StateMonitoring({
    this.listBar = const[],
    required this.days,
    this.change = 1,
  });

  @override
  List<Object> get props => [listBar ?? [], days, change];

  StateMonitoring copyWith({
    List<ElementBarData>? listBar,
    DateTime? days,
    int? change,
  }) {
    return StateMonitoring(
      listBar: listBar ?? this.listBar,
      days: days ?? this.days,
      change: change ?? this.change,
    );
  }

  @override
  bool get stringify => true;
}
