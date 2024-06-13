// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
// import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import '../model/item_machine.dart';

class StateQueueMasterChM extends Equatable {
  // final List<ElementBarData>? listBar;
  final List<ItemMachine>? listMachine;
  final int activePage;
  const StateQueueMasterChM({
    this.listMachine = const [],
    this.activePage = 0,
  });

  @override
  List<Object> get props => [listMachine ?? [], activePage];

  StateQueueMasterChM copyWith({
    List<ItemMachine>? listMachine,
    int? activePage,
  }) {
    return StateQueueMasterChM(
      listMachine: listMachine ?? this.listMachine,
      activePage: activePage ?? this.activePage,
    );
  }

  @override
  bool get stringify => true;
}
