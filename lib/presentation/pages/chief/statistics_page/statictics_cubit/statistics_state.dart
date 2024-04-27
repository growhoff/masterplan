part of 'statistics_cubit.dart';

class ChiefStatisticsState extends Equatable {
  const ChiefStatisticsState(
      {this.areasList = const [], this.stagesList = const []});

  final List<Area> areasList;
  final List<StatisticsStageModel> stagesList;

  @override
  List<Object?> get props => [areasList, stagesList];

  ChiefStatisticsState copyWith(
      {List<Area>? areasList, List<StatisticsStageModel>? stagesList}) {
    return ChiefStatisticsState(
        areasList: areasList ?? this.areasList,
        stagesList: stagesList ?? this.stagesList);
  }
}
