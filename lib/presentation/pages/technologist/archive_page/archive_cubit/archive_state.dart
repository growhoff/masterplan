part of 'archive_cubit.dart';

enum ArchiveStatus { initial, loading, success, failure }

class ArchiveState extends Equatable {
  const ArchiveState(
      {this.batchesList = const [], this.status = ArchiveStatus.initial});

  final List<Batch> batchesList;
  final ArchiveStatus status;

  ArchiveState copyWith({List<Batch>? batchesList, ArchiveStatus? status}) {
    return ArchiveState(
        batchesList: batchesList ?? this.batchesList,
        status: status ?? this.status);
  }

  @override
  List<Object> get props => [batchesList, status];
}
