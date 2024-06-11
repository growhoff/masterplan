// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';

class StateMonitoring extends Equatable {
  final List<ItemMachineMonitorMaster>? listBar;
  final DateTime days;
  final int change;
  final int activePage;
  const StateMonitoring({
    this.listBar = const[],
    required this.days,
    this.change = 1,
    this.activePage = 0,
  });

  @override
  List<Object> get props => [listBar ?? [], days, change, activePage];

  StateMonitoring copyWith({
    List<ItemMachineMonitorMaster>? listBar,
    DateTime? days,
    int? change,
    int? activePage,
  }) {
    return StateMonitoring(
      listBar: listBar ?? this.listBar,
      days: days ?? this.days,
      change: change ?? this.change,
      activePage: activePage ?? this.activePage,
    );
  }

  @override
  bool get stringify => true;
}
