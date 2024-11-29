part of 'chief_distribution_cubit.dart';

enum DistributionPageStatus { initial, loading, success }

class ChiefDistributionState extends Equatable {
  const ChiefDistributionState(
      {this.chiefOperationsList = const [],
      this.areasList = const [],
      this.status = DistributionPageStatus.initial});

  final List<ChiefDistributionOperation> chiefOperationsList;
  final List<String> areasList;
  final DistributionPageStatus status;

  @override
  List<Object?> get props => [chiefOperationsList, areasList, status];

  ChiefDistributionState copyWith({
    List<String>? areasList,
    List<ChiefDistributionOperation>? chiefOperationsList,
    DistributionPageStatus? status,
  }) {
    return ChiefDistributionState(
        areasList: areasList ?? this.areasList,
        chiefOperationsList: chiefOperationsList ?? this.chiefOperationsList,
        status: status ?? this.status);
  }
}
