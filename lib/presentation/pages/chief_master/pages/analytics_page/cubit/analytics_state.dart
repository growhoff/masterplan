part of 'analytics_cubit.dart';

class AnalyticsState extends Equatable {
  const AnalyticsState({this.analyticsOperationsList = const []});

  final List<AnalyticsOperationModel> analyticsOperationsList;

  @override
  List<Object?> get props => [analyticsOperationsList];

  AnalyticsState copyWith(
      {List<AnalyticsOperationModel>? analyticsOperationsList}) {
    return AnalyticsState(
        analyticsOperationsList:
            analyticsOperationsList ?? this.analyticsOperationsList);
  }
}
