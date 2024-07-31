part of 'queue_stages_cubit.dart';

enum QueueStagesPageStatus { initial, loading, success, failure }

class QueueStagesState extends Equatable {
  QueueStagesState(
      {this.stagesList = const [],
      this.unitsList = const [],
      this.status = QueueStagesPageStatus.initial});

  final List<StageInUnitModel> stagesList;

  final List<Unit> unitsList;

  final QueueStagesPageStatus status;

  @override
  List<Object?> get props => [stagesList, unitsList, status];

  QueueStagesState copyWith({
    List<StageInUnitModel>? stagesList,
    List<Unit>? unitsList,
    QueueStagesPageStatus? status,
  }) {
    return QueueStagesState(
      stagesList: stagesList ?? this.stagesList,
      unitsList: unitsList ?? this.unitsList,
      status: status ?? this.status,
    );
  }
}
