part of 'dispatcher_analytics_cubit.dart';

enum DispatcherAnalyticsStateStatus { initial, loading, failure, success }

class DispatcherAnalyticsState extends Equatable {
  const DispatcherAnalyticsState(
      {this.status = DispatcherAnalyticsStateStatus.initial,
      this.analyticsOperationsList = const [],
      this.totalNumberReadyOperationModelsList = const [],
      this.unitsList = const [],
      this.areasList = const []});

  final List<AnalyticsOperationModel> analyticsOperationsList;
  final List<TotalNumberReadyOperationModel>
      totalNumberReadyOperationModelsList;
  final List<Unit> unitsList;
  final DispatcherAnalyticsStateStatus status;
  final List<Area> areasList;

  @override
  List<Object?> get props => [
        analyticsOperationsList,
        unitsList,
        areasList,
        status,
        totalNumberReadyOperationModelsList
      ];

  DispatcherAnalyticsState copyWith(
      {List<AnalyticsOperationModel>? analyticsOperationsList,
      List<Unit>? unitsList,
      List<TotalNumberReadyOperationModel>? totalNumberReadyOperationModelsList,
      DispatcherAnalyticsStateStatus? status,
      List<Area>? areasList}) {
    return DispatcherAnalyticsState(
        analyticsOperationsList:
            analyticsOperationsList ?? this.analyticsOperationsList,
        totalNumberReadyOperationModelsList:
            totalNumberReadyOperationModelsList ??
                this.totalNumberReadyOperationModelsList,
        status: status ?? this.status,
        unitsList: unitsList ?? this.unitsList,
        areasList: areasList ?? this.areasList);
  }
}
