part of 'batches_cubit.dart';

enum BatchesStatus { initial, loading, failure, success }

final class BatchesState extends Equatable {
  const BatchesState(
      {this.batchesNamesList = const [],
      this.status = BatchesStatus.initial,
      this.batchesList = const []});

  final List<Batch> batchesList;
  final List<String> batchesNamesList;
  final BatchesStatus status;

  BatchesState copyWith(
      {List<Batch>? batchesList,
      BatchesStatus? status,
      List<String>? batchesNamesList}) {
    return BatchesState(
        batchesList: batchesList ?? this.batchesList,
        status: status ?? this.status,
        batchesNamesList: batchesNamesList ?? this.batchesNamesList);
  }

  @override
  List<Object> get props => [batchesList, status, batchesNamesList];
}
