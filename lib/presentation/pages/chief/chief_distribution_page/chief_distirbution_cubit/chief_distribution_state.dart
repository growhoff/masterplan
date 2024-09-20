part of 'chief_distribution_cubit.dart';

@immutable
sealed class ChiefDistributionState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ChiefDistributionInitial extends ChiefDistributionState {}

final class ChiefDistributionLoading extends ChiefDistributionState {}

final class ChiefDistributionSuccess extends ChiefDistributionState {
  ChiefDistributionSuccess({required this.unitsList, required this.stagesList});

  final List<ChiefDistributionStageModel> stagesList;
  final List<Unit> unitsList;

  @override
  List<Object?> get props => [unitsList, stagesList];
}

final class OperationsOfStagePageSuccess extends ChiefDistributionState {
  OperationsOfStagePageSuccess(
      {required this.operationsList, required this.areasList});

  final List<DistributionOperationModel> operationsList;
  final List<Area> areasList;

  @override
  List<Object?> get props => [operationsList, areasList];
}
