part of 'stages_in_unit_cubit.dart';

class StagesInUnitState extends Equatable {
  const StagesInUnitState({
    this.stagesList = const [],
    this.stagesInBatchList = const [],
  });

  final List<StageInUnitModel> stagesList;
  final List<StageInBatchModel> stagesInBatchList;

  @override
  List<Object?> get props => [stagesList, stagesInBatchList, ];

  StagesInUnitState copyWith({
    List<StageInUnitModel>? stagesList,
    List<StageInBatchModel>? stagesInBatchList,
  }) {
    return StagesInUnitState(
        stagesList: stagesList ?? this.stagesList,
        stagesInBatchList: stagesInBatchList ?? this.stagesInBatchList);
  }
}
