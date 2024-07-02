part of 'analytics_cubit.dart';

enum AnalyticsPageStatus { initial, loading, success, failure }

class ChiefAnalyticsState extends Equatable {
  const ChiefAnalyticsState(
      {this.stagesList = const [], this.status = AnalyticsPageStatus.initial});

  final List<ChiefStageForReportModel> stagesList;
  final AnalyticsPageStatus status;

  @override
  List<Object?> get props => [stagesList];

  ChiefAnalyticsState copyWith(
      {List<ChiefStageForReportModel>? stagesList,
      AnalyticsPageStatus? status}) {
    return ChiefAnalyticsState(
        stagesList: stagesList ?? this.stagesList,
        status: status ?? this.status);
  }
}
