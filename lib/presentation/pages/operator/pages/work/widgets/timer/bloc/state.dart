// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class StateTimer extends Equatable {
  final List<int> listTick;
  final List<bool> listState;
  final List<String> listRes;
  const StateTimer({
    this.listTick = const [],
    this.listState = const [],
    this.listRes = const []
  });

  @override
  List<Object> get props => [listTick, listState, listRes];

  StateTimer copyWith({
    List<int>? listTick,
    List<bool>? listState,
    List<String>? listRes,
  }) {
    return StateTimer(
      listTick: listTick ?? this.listTick,
      listState: listState ?? this.listState,
      listRes:  listRes ?? this.listRes,
    );
  }
}
