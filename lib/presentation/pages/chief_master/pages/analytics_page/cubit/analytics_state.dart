part of 'analytics_cubit.dart';

enum AnalyticsPageStatus { initial, loading, success, failure }

class AnalyticsState extends Equatable {
  const AnalyticsState(
      {this.analyticsOperationsList = const [],
      this.stagesList = const [],
      this.status = AnalyticsPageStatus.success});

  final List<AnalyticsOperationModel> analyticsOperationsList;
  final List<ChiefStageForReportModel> stagesList;
  final AnalyticsPageStatus status;

  @override
  List<Object?> get props => [analyticsOperationsList, stagesList, status];

  AnalyticsState copyWith(
      {List<AnalyticsOperationModel>? analyticsOperationsList,
      List<ChiefStageForReportModel>? stagesList,
      AnalyticsPageStatus? status}) {
    return AnalyticsState(
        analyticsOperationsList:
            analyticsOperationsList ?? this.analyticsOperationsList,
        stagesList: stagesList ?? this.stagesList,
        status: status ?? this.status);
  }
}
