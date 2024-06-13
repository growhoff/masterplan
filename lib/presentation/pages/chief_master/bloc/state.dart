// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateChiefMaster extends Equatable {
  final int activePage;
  const StateChiefMaster({
    this.activePage = 0,
  });

  @override
  List<Object> get props => [activePage];

  StateChiefMaster copyWith({
    int? activePage,
  }) {
    return StateChiefMaster(
      activePage: activePage ?? this.activePage,
    );
  }

  @override
  bool get stringify => true;
}
