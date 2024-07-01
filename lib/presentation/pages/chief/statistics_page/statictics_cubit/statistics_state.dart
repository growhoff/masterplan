part of 'statistics_cubit.dart';

class ChiefStatisticsState extends Equatable {
  const ChiefStatisticsState({this.stagesList = const []});

  final List<ChiefStageForReportModel> stagesList;

  @override
  List<Object?> get props => [stagesList];

  ChiefStatisticsState copyWith({List<ChiefStageForReportModel>? stagesList}) {
    return ChiefStatisticsState(stagesList: stagesList ?? this.stagesList);
  }
}
