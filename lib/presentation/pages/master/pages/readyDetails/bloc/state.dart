// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/status_next.dart';

class StateReadyDetails extends Equatable {
  final List<ItemMachine>? listMachine;
  final int activePage;
  final List<List<StatusNext>> statusList;
  final int count;
  final bool isLoading;

  const StateReadyDetails({
    this.listMachine = const [],
    this.activePage = 0,
    this.statusList = const [],
    this.count = 0,
    this.isLoading = false,
  });

  @override
  List<Object> get props => [listMachine ?? [], activePage, statusList, count, isLoading];

  StateReadyDetails copyWith({
    List<ItemMachine>? listMachine,
    int? activePage,
    List<List<StatusNext>>? statusList,
    int? count,
    bool? isLoading,
  }) {
    return StateReadyDetails(
      listMachine: listMachine ?? this.listMachine,
      activePage: activePage ?? this.activePage,
      statusList: statusList ?? this.statusList,
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  bool get stringify => true;
}
