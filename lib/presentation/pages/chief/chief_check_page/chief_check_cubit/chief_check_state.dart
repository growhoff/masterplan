part of 'chief_check_cubit.dart';

class ChiefCheckState extends Equatable {
  const ChiefCheckState({this.stagesList = const []});

  final List<ZStage> stagesList;

  @override
  List<Object?> get props => [stagesList];

  ChiefCheckState copyWith({List<ZStage>? stagesList}) {
    return ChiefCheckState(stagesList: stagesList ?? this.stagesList);
  }
}
