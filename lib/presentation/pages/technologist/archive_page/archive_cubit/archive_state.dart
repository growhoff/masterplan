part of 'archive_cubit.dart';

enum ArchiveStatus { initial, loading, success, failure }

class ArchiveState extends Equatable {
  const ArchiveState(
      {this.batchesList = const [],
      this.stagesList = const [],
      this.operationsList = const [],
        this.transfersList = const [],
      this.status = ArchiveStatus.initial});

  final List<BatchArchive> batchesList;
  final List<StageArchive> stagesList;
  final List<OperationArchive> operationsList;
  final List<TransferArchive> transfersList;
  final ArchiveStatus status;

  ArchiveState copyWith(
      {List<BatchArchive>? batchesList,
      List<StageArchive>? stagesList,
      List<OperationArchive>? operationsList,
        List<TransferArchive>? transfersList,
      ArchiveStatus? status}) {
    return ArchiveState(
        batchesList: batchesList ?? this.batchesList,
        stagesList: stagesList ?? this.stagesList,
        operationsList: operationsList ?? this.operationsList,
        transfersList: transfersList ?? this.transfersList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [batchesList, stagesList, operationsList, transfersList,status];
}
