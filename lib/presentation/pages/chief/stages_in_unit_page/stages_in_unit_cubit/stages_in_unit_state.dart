part of 'stages_in_unit_cubit.dart';

enum StagesInUnitStateStatus { initial, loading, success, failure }

class StagesInUnitState extends Equatable {
  const StagesInUnitState({
    this.stagesList = const [],
    this.status = StagesInUnitStateStatus.initial,
  });

  final List<StageModel> stagesList;
final StagesInUnitStateStatus status;

  @override
  List<Object?> get props => [
        stagesList,
    status
      ];

  StagesInUnitState copyWith({
    List<StageModel>? stagesList,
    StagesInUnitStateStatus? status,
  }) {
    return StagesInUnitState(
      stagesList: stagesList ?? this.stagesList,
      status: status ?? this.status,
    );
  }
}
