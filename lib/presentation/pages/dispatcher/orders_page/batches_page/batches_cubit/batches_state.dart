part of 'batches_cubit.dart';

enum BatchesStatus { initial, loading, failure, success }

final class BatchesState extends Equatable {
  const BatchesState({this.status = BatchesStatus.initial,
    this.batchesList = const [],
    this.batchesArchiveList = const []});

  final List<Batch> batchesList;

  final BatchesStatus status;

  final List<BatchArchive> batchesArchiveList;

  BatchesState copyWith({
    List<Batch>? batchesList,
    BatchesStatus? status,
    List<BatchArchive>? batchesArchiveList
  }) {
    return BatchesState(
        batchesList: batchesList ?? this.batchesList,
        status: status ?? this.status,
        batchesArchiveList: batchesArchiveList ?? this.batchesArchiveList
    );
  }

  @override
  List<Object> get props =>
      [
        batchesList,
        status,
        batchesArchiveList
      ];
}
