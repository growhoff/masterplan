part of 'dispatcher_analytics_cubit.dart';

enum DispatcherAnalyticsStateStatus { initial, loading, failure, success }

class DispatcherAnalyticsState extends Equatable {
  const DispatcherAnalyticsState({
    this.status = DispatcherAnalyticsStateStatus.initial,
    this.analyticsOperationsList = const [],
    this.totalNumberReadyOperationModelsList = const [],
    this.monitoringStatusesModelsList = const [],
    this.unitsList = const [],
    this.areasList = const [],
    this.machinesList = const [],
  });

  final List<AnalyticsOperationModel> analyticsOperationsList;
  final List<TotalNumberReadyOperationModel>
      totalNumberReadyOperationModelsList;
  final List<MonitoringStatusesModel> monitoringStatusesModelsList;
  final List<Unit> unitsList;
  final DispatcherAnalyticsStateStatus status;
  final List<Area> areasList;
  final List<Machine> machinesList;

  @override
  List<Object?> get props => [
        analyticsOperationsList,
        unitsList,
        areasList,
        machinesList,
        status,
        totalNumberReadyOperationModelsList,
        monitoringStatusesModelsList,
      ];

  DispatcherAnalyticsState copyWith(
      {List<AnalyticsOperationModel>? analyticsOperationsList,
      List<Unit>? unitsList,
      List<TotalNumberReadyOperationModel>? totalNumberReadyOperationModelsList,
      DispatcherAnalyticsStateStatus? status,
      List<MonitoringStatusesModel>? monitoringStatusesModelsList,
      List<Machine>? machinesList,
      List<Area>? areasList}) {
    return DispatcherAnalyticsState(
        analyticsOperationsList:
            analyticsOperationsList ?? this.analyticsOperationsList,
        totalNumberReadyOperationModelsList:
            totalNumberReadyOperationModelsList ??
                this.totalNumberReadyOperationModelsList,
        status: status ?? this.status,
        monitoringStatusesModelsList:
            monitoringStatusesModelsList ?? this.monitoringStatusesModelsList,
        unitsList: unitsList ?? this.unitsList,
        areasList: areasList ?? this.areasList,
        machinesList: machinesList ?? this.machinesList);
  }
}
