// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';

class StateWork extends Equatable {
    final List<PageItem> pageData;
    final int activePage;
    final List<int> statusBtn;
  const StateWork({
    this.pageData = const [],
    this.activePage = 0,
    this.statusBtn = const [],
  });

  @override
  List<Object> get props => [pageData, activePage, statusBtn];

  StateWork copyWith({
    List<PageItem>? pageData,
    List<Timer>? timer,
    int? activePage,
    List<int>? statusBtn,
  }) {
    return StateWork(
      pageData: pageData ?? this.pageData,
      activePage: activePage ?? this.activePage,
      statusBtn: statusBtn ?? this.statusBtn,
    );
  }
}
