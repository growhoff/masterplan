part of 'batches_cubit.dart';

enum BatchesStatus { initial, loading, failure, success }

final class BatchesState extends Equatable {
  const BatchesState(
      {this.status = BatchesStatus.initial, this.batchesList = const []});

  final List<Batch> batchesList;
  final BatchesStatus status;

  BatchesState copyWith({List<Batch>? batchesList, BatchesStatus? status}) {
    return BatchesState(
        batchesList: batchesList ?? this.batchesList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [batchesList, status];
}
