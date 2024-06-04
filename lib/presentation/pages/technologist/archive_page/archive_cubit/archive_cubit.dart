import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/domain/model/batch.dart';

part 'archive_state.dart';

class ArchiveCubit extends Cubit<ArchiveState> {
  ArchiveCubit() : super(const ArchiveState()) {
    _batchTable.stream().listen((list) {
      fetchDataFromStream(list);
    });
  }

  final _batchTable = BatchTable();

  fetchDataFromStream(dynamic fetchedList) {
    List<Batch> batchesList = [];

    try {
      for (var fetchedBatch in fetchedList) {
        final batchDto = BatchDTO.fromMap(fetchedBatch);

        final batch = convertDtoToModel(batchDto);

        batchesList.add(batch);
      }

      emit(state.copyWith(
          batchesList: batchesList, status: ArchiveStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ArchiveStatus.failure));
    }
  }

  convertDtoToModel(BatchDTO dto) {
    return Batch(
        id: dto.id,
        number: dto.number,
        name: dto.name,
        count: dto.count,
        code: dto.code,
        technology: dto.technology,
        order: dto.order,
        isready: dto.isready,
        packageId: dto.packageId);
  }
}
