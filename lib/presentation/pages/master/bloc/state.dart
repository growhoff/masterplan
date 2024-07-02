// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';

class StateMaster extends Equatable {
  final int activePage;
  final bool isSaveOrder;
  final List<OptPathOperations>? list;
  const StateMaster({
    this.activePage = 0,
    this.isSaveOrder = false,
    this.list,
  });

  @override
  List<Object> get props => [activePage, isSaveOrder, list ?? []];

  StateMaster copyWith({
    int? activePage,
    bool? isSaveOrder,
    List<OptPathOperations>? list,
  }) {
    return StateMaster(
      activePage: activePage ?? this.activePage,
      isSaveOrder: isSaveOrder ?? this.isSaveOrder,
      list: list ?? this.list,
    );
  }

  @override
  bool get stringify => true;
}
