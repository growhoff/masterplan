// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/model/table_model.dart';

class StateTableInfo extends Equatable {
  final int? activeItem;
  final List<TableModel>? listTable;
  const StateTableInfo({
    this.activeItem,
    this.listTable,
  });

  @override
  List<Object> get props => [activeItem ?? 0, listTable ?? []];

  StateTableInfo copyWith({
    int? activeItem,
    List<TableModel>? listTable,
  }) {
    return StateTableInfo(
      activeItem: activeItem ?? this.activeItem,
      listTable: listTable ?? this.listTable,
    );
  }

  @override
  bool get stringify => true;
}
