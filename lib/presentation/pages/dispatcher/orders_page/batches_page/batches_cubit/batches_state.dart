part of 'batches_cubit.dart';

enum BatchesStatus { initial, loading, failure, success }

final class BatchesState extends Equatable {
  const BatchesState({
    this.status = BatchesStatus.initial,
    this.batchesList = const [],
    this.stagesInBatchList = const [],
    this.batchesArchiveList = const [],
    this.operationsInStageList = const [],
  });

  final List<BatchModel> batchesList;

  final BatchesStatus status;

  final List<StageModel> stagesInBatchList;

  final List<OperationInStageModel> operationsInStageList;

  final List<BatchArchive> batchesArchiveList;

  BatchesState copyWith({
    List<BatchModel>? batchesList,
    BatchesStatus? status,
    List<StageModel>? stagesInBatchList,
    List<BatchArchive>? batchesArchiveList,
    List<OperationInStageModel>? operationsInStageList,
  }) {
    return BatchesState(
        batchesList: batchesList ?? this.batchesList,
        status: status ?? this.status,
        stagesInBatchList: stagesInBatchList ?? this.stagesInBatchList,
        batchesArchiveList: batchesArchiveList ?? this.batchesArchiveList,
        operationsInStageList:
            operationsInStageList ?? this.operationsInStageList,);
  }

  @override
  List<Object> get props => [
        batchesList,
        status,
        batchesArchiveList,
        stagesInBatchList,
      ];
}
