// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/page_item.dart';

class StateWork extends Equatable {
    final List<PageItem> pageData;
    final int activePage;
    final List<int> statusBtn;
    final int? monitorId;
    final List<bool> listStartBtn;
    final List<int> timeActive;
    final List<bool> listStartTime;
    final int count;
    final bool exit;
  const StateWork({
    this.pageData = const [],
    this.activePage = 0,
    this.statusBtn = const [],
    this.monitorId,
    this.listStartBtn = const [],
    this.timeActive = const [],
    this.listStartTime = const [],
    this.count = 0,
    this.exit = false,
  });

  @override
  List<Object> get props => [pageData, activePage, statusBtn, monitorId ?? 0, listStartBtn, timeActive, listStartTime, count, exit];

  StateWork copyWith({
    List<PageItem>? pageData,
    List<Timer>? timer,
    int? activePage,
    List<int>? statusBtn,
    int? monitorId,
    List<bool>? listStartBtn,
    List<int>? timeActive,
    List<bool>? listStartTime,
    int? count,
    bool? exit,
  }) {
    return StateWork(
      pageData: pageData ?? this.pageData,
      activePage: activePage ?? this.activePage,
      statusBtn: statusBtn ?? this.statusBtn,
      monitorId: monitorId ?? this.monitorId,
      listStartBtn: listStartBtn ?? this.listStartBtn,
      timeActive: timeActive ?? this.timeActive,
      listStartTime: listStartTime ?? this.listStartTime,
      count: count ?? this.count,
      exit: exit ?? this.exit,
    );
  }
}
