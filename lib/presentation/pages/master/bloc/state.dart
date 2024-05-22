// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateMaster extends Equatable {
  final int activePage;
  const StateMaster({
    this.activePage = 0,
  });

  @override
  List<Object> get props => [activePage];

  StateMaster copyWith({
    int? activePage,
  }) {
    return StateMaster(
      activePage: activePage ?? this.activePage,
    );
  }

  @override
  bool get stringify => true;
}
