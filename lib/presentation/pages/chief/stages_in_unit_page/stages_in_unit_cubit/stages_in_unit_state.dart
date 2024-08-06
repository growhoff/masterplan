part of 'stages_in_unit_cubit.dart';

class StagesInUnitState extends Equatable {
  const StagesInUnitState({
    this.stagesList = const [],
    this.stagesInBatchList = const [],
  });

  final List<StageModel> stagesList;
  final List<StageModel> stagesInBatchList;

  @override
  List<Object?> get props => [stagesList, stagesInBatchList, ];

  StagesInUnitState copyWith({
    List<StageModel>? stagesList,
    List<StageModel>? stagesInBatchList,
  }) {
    return StagesInUnitState(
        stagesList: stagesList ?? this.stagesList,
        stagesInBatchList: stagesInBatchList ?? this.stagesInBatchList);
  }
}
