// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateChiefMaster extends Equatable {
  final int activePage;
  final bool isThisMonitoring;
  const StateChiefMaster({
    this.activePage = 0,
    this.isThisMonitoring = true,
  });

  @override
  List<Object> get props => [activePage, isThisMonitoring];

  StateChiefMaster copyWith({
    int? activePage,
    bool? isThisMonitoring,
  }) {
    return StateChiefMaster(
      activePage: activePage ?? this.activePage,
      isThisMonitoring: isThisMonitoring ?? this.isThisMonitoring,
    );
  }

  @override
  bool get stringify => true;
}
