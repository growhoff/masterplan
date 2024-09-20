// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';

class StateMaster extends Equatable {
  final int activePage;
  final bool isSaveOrder;
  final List<OptPathOperations>? list;
  final bool isActiveStream;
  final bool isThisMonitoring;
  final int isFilterDistribution;
  const StateMaster({
    this.activePage = 0,
    this.isSaveOrder = false,
    this.list,
    this.isActiveStream = true,
    this.isThisMonitoring = true,
    this.isFilterDistribution = 0,
  });

  @override
  List<Object> get props => [activePage, isSaveOrder, list ?? [], isActiveStream, isThisMonitoring, isFilterDistribution];

  StateMaster copyWith({
    int? activePage,
    bool? isSaveOrder,
    List<OptPathOperations>? list,
    bool? isActiveStream,
    bool? isThisMonitoring,
    int? isFilterDistribution,
  }) {
    return StateMaster(
      activePage: activePage ?? this.activePage,
      isSaveOrder: isSaveOrder ?? this.isSaveOrder,
      list: list ?? this.list,
      isActiveStream: isActiveStream ?? this.isActiveStream,
      isThisMonitoring: isThisMonitoring ?? this.isThisMonitoring,
      isFilterDistribution: isFilterDistribution ?? this.isFilterDistribution,
    );
  }

  @override
  bool get stringify => true;
}
