part of 'dispatcher_archive_cubit.dart';

enum DispatcherArchiveStatus { initial, loading, success, failure }

class DispatcherArchiveState extends Equatable {
  const DispatcherArchiveState(
      {this.batchesList = const [],
      this.stagesList = const [],
      this.operationsList = const [],
        this.transfersList = const [],
      this.status = DispatcherArchiveStatus.initial});

  final List<BatchArchive> batchesList;
  final List<Stage> stagesList;
  final List<Operation> operationsList;
  final List<Transfer> transfersList;
  final DispatcherArchiveStatus status;

  DispatcherArchiveState copyWith(
      {List<BatchArchive>? batchesList,
      List<Stage>? stagesList,
      List<Operation>? operationsList,
        List<Transfer>? transfersList,
      DispatcherArchiveStatus? status}) {
    return DispatcherArchiveState(
        batchesList: batchesList ?? this.batchesList,
        stagesList: stagesList ?? this.stagesList,
        operationsList: operationsList ?? this.operationsList,
        transfersList: transfersList ?? this.transfersList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [batchesList, operationsList, transfersList,status];
}
