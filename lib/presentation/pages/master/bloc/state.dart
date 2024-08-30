// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';

class StateMaster extends Equatable {
  final int activePage;
  final bool isSaveOrder;
  final List<OptPathOperations>? list;
  final bool isActiveStream;
  final bool isThisMonitoring;
  const StateMaster({
    this.activePage = 0,
    this.isSaveOrder = false,
    this.list,
    this.isActiveStream = true,
    this.isThisMonitoring = true,
  });

  @override
  List<Object> get props => [activePage, isSaveOrder, list ?? [], isActiveStream, isThisMonitoring];

  StateMaster copyWith({
    int? activePage,
    bool? isSaveOrder,
    List<OptPathOperations>? list,
    bool? isActiveStream,
    bool? isThisMonitoring,
  }) {
    return StateMaster(
      activePage: activePage ?? this.activePage,
      isSaveOrder: isSaveOrder ?? this.isSaveOrder,
      list: list ?? this.list,
      isActiveStream: isActiveStream ?? this.isActiveStream,
      isThisMonitoring: isThisMonitoring ?? this.isThisMonitoring,
    );
  }

  @override
  bool get stringify => true;
}
