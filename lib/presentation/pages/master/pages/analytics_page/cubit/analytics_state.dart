part of 'analytics_cubit.dart';

class AnalyticsState extends Equatable {
  const AnalyticsState(
      {this.analyticsOperationsList = const [],
      this.totalNumberReadyOperationModelsList = const []});

  final List<TotalNumberReadyOperationModel>
      totalNumberReadyOperationModelsList;
  final List<AnalyticsOperationModel> analyticsOperationsList;

  @override
  List<Object?> get props =>
      [analyticsOperationsList, totalNumberReadyOperationModelsList];

  AnalyticsState copyWith({
    List<AnalyticsOperationModel>? analyticsOperationsList,
    List<TotalNumberReadyOperationModel>? totalNumberReadyOperationModelsList,
  }) {
    return AnalyticsState(
        analyticsOperationsList:
            analyticsOperationsList ?? this.analyticsOperationsList,
        totalNumberReadyOperationModelsList:
            totalNumberReadyOperationModelsList ??
                this.totalNumberReadyOperationModelsList);
  }
}
