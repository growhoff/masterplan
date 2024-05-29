// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';

class StateWork extends Equatable {
    final List<PageItem> pageData;
    final int activePage;
    final List<int> statusBtn;
    final int? monitorId;
    final List<bool> setStart;
    final List<int> timeActive;
  const StateWork({
    this.pageData = const [],
    this.activePage = 0,
    this.statusBtn = const [],
    this.monitorId,
    this.setStart = const [],
    this.timeActive = const [],
  });

  @override
  List<Object> get props => [pageData, activePage, statusBtn, monitorId ?? 0, setStart, timeActive];

  StateWork copyWith({
    List<PageItem>? pageData,
    List<Timer>? timer,
    int? activePage,
    List<int>? statusBtn,
    int? monitorId,
    List<bool>? setStart,
    List<int>? timeActive,
  }) {
    return StateWork(
      pageData: pageData ?? this.pageData,
      activePage: activePage ?? this.activePage,
      statusBtn: statusBtn ?? this.statusBtn,
      monitorId: monitorId ?? this.monitorId,
      setStart: setStart ?? this.setStart,
      timeActive: timeActive ?? this.timeActive,
    );
  }
}
