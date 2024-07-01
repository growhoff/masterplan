part of 'archive_cubit.dart';

enum ArchiveStatus { initial, loading, success, failure }

class ArchiveState extends Equatable {
  const ArchiveState(
      {this.batchesList = const [],
      this.stagesList = const [],
      this.operationsList = const [],
        this.transfersList = const [],
      this.status = ArchiveStatus.initial});

  final List<Batch> batchesList;
  final List<Stage> stagesList;
  final List<Operation> operationsList;
  final List<Transfer> transfersList;
  final ArchiveStatus status;

  ArchiveState copyWith(
      {List<Batch>? batchesList,
      List<Stage>? stagesList,
      List<Operation>? operationsList,
        List<Transfer>? transfersList,
      ArchiveStatus? status}) {
    return ArchiveState(
        batchesList: batchesList ?? this.batchesList,
        stagesList: stagesList ?? this.stagesList,
        operationsList: operationsList ?? this.operationsList,
        transfersList: transfersList ?? this.transfersList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [batchesList, operationsList, transfersList,status];
}
