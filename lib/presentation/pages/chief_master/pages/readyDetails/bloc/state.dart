// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import '../model/item_machine.dart';
import '../model/status_next.dart';

class StateReadyDetailsChM extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activePage;
  final List<List<StatusNext>> statusList;
  final int count;
  const StateReadyDetailsChM({
    this.listMachine = const [],
    this.activePage = 0,
    this.statusList = const [],
    this.count = 0,
  });

  @override
  List<Object> get props => [listMachine ?? [], activePage, statusList, count];

  StateReadyDetailsChM copyWith({
    List<ItemMachine>? listMachine,
    int? activePage,
    List<List<StatusNext>>? statusList,
    int? count,
  }) {
    return StateReadyDetailsChM(
      listMachine: listMachine ?? this.listMachine,
      activePage: activePage ?? this.activePage,
      statusList: statusList ?? this.statusList,
      count: count ?? this.count,
    );
  }

  @override
  bool get stringify => true;
}
