// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';

class StateMonitoring extends Equatable {
  final List<ElementBarData>? listBar;
  const StateMonitoring({
    this.listBar = const[],
  });

  @override
  List<Object> get props => [listBar ?? []];

  StateMonitoring copyWith({
    List<ElementBarData>? listBar,
  }) {
    return StateMonitoring(
      listBar: listBar ?? this.listBar,
    );
  }

  @override
  bool get stringify => true;
}
