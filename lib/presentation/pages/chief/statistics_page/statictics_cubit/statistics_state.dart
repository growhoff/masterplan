part of 'statistics_cubit.dart';

class ChiefStatisticsState extends Equatable {
  const ChiefStatisticsState({this.stagesList = const []});

  final List<StatisticsStageModel> stagesList;

  @override
  List<Object?> get props => [stagesList];

  ChiefStatisticsState copyWith({List<StatisticsStageModel>? stagesList}) {
    return ChiefStatisticsState(stagesList: stagesList ?? this.stagesList);
  }
}
