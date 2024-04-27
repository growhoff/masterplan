// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';

class StateReadyDetails extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activePage;
  final List<List<int>> doubleList;
  final int count;
  const StateReadyDetails({
    this.listMachine,
    this.activePage = 0,
    this.doubleList = const [],
    this.count = 0,
  });

  @override
  List<Object> get props => [listMachine ?? [], activePage, doubleList, count];

  StateReadyDetails copyWith({
    List<ItemMachine>? listMachine,
    int? activePage,
    List<List<int>>? doubleList,
    int? count,
  }) {
    return StateReadyDetails(
      listMachine: listMachine ?? this.listMachine,
      activePage: activePage ?? this.activePage,
      doubleList: doubleList ?? this.doubleList,
      count: count ?? this.count,
    );
  }

  @override
  bool get stringify => true;
}
