part of 'stages_in_unit_cubit.dart';

class StagesInUnitState extends Equatable {
  const StagesInUnitState({this.stagesList = const []});

  final List<StageInUnitModel> stagesList;

  @override
  List<Object?> get props => [stagesList];

  StagesInUnitState copyWith({
    List<StageInUnitModel>? stagesList,
  }) {
    return StagesInUnitState(stagesList: stagesList ?? this.stagesList);
  }
}
