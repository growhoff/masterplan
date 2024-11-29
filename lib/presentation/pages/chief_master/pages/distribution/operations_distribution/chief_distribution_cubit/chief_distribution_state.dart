part of 'chief_distribution_cubit.dart';

enum DistributionPageStatus { initial, loading, success }

class ChiefDistributionChMState extends Equatable {
  const ChiefDistributionChMState(
      {this.chiefOperationsList = const [],
      this.areasList = const [],
      this.status = DistributionPageStatus.initial});

  final List<ChiefDistributionOperation> chiefOperationsList;
  final List<String> areasList;
  final DistributionPageStatus status;

  @override
  List<Object?> get props => [chiefOperationsList, areasList, status];

  ChiefDistributionChMState copyWith({
    List<String>? areasList,
    List<ChiefDistributionOperation>? chiefOperationsList,
    DistributionPageStatus? status,
  }) {
    return ChiefDistributionChMState(
        areasList: areasList ?? this.areasList,
        chiefOperationsList: chiefOperationsList ?? this.chiefOperationsList,
        status: status ?? this.status);
  }
}
