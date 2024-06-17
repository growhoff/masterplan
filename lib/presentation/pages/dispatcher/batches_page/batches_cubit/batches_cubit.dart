import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';

import '../../../../../domain/model/batch.dart';

part 'batches_state.dart';

class BatchesCubit extends Cubit<BatchesState> {
  BatchesCubit(this.orderId) : super(const BatchesState());

  final int orderId;
  final _batchTable = BatchTable();

  Future<void> fetchBatches() async {
    List<Batch> batchesList = [];

    try {
      var fetchedList = await _batchTable.selectByOrderId(orderId);

      for (var fetchedBatch in fetchedList) {
        final batchDto = BatchDTO.fromMap(fetchedBatch);
        final batch = Batch(
            id: batchDto.id,
            number: batchDto.number,
            name: batchDto.name,
            count: batchDto.count,
            code: batchDto.code,
            technology: batchDto.technology,
            order: batchDto.order,
            isready: batchDto.isready,
            orderId: batchDto.orderId);
        batchesList.add(batch);
      }

      emit(state.copyWith(
          batchesList: batchesList, status: BatchesStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BatchesStatus.failure));
    }
  }
}
