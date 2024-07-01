part of 'dispatcher_distribution_cubit.dart';

enum DispatcherDistributionStatus { initial, loading, success, failure }

final class DispatcherDistributionState extends Equatable {
  const DispatcherDistributionState(
      {this.status = DispatcherDistributionStatus.initial,
        this.unitsList = const [],
        this.distributionStagesList = const []});

  final List<DistributionStageModel> distributionStagesList;
  final List<Unit> unitsList;
  final DispatcherDistributionStatus status;

  @override
  List<Object> get props => [status, distributionStagesList, unitsList];

  DispatcherDistributionState copyWith({
    List<DistributionStageModel>? distributionStagesList,
    List<Unit>? unitsList,
    DispatcherDistributionStatus? status,
  }) {
    return DispatcherDistributionState(
        distributionStagesList:
        distributionStagesList ?? this.distributionStagesList,
        unitsList: unitsList ?? this.unitsList,
        status: status ?? this.status);
  }
}
