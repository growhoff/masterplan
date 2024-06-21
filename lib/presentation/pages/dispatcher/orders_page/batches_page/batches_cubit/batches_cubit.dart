import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';

import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import '../../../../../../domain/model/batch.dart';


part 'batches_state.dart';

class BatchesCubit extends Cubit<BatchesState> {
  BatchesCubit(this.orderId) : super(const BatchesState());

  final int? orderId;
  final _batchTable = BatchTable();
  final _chiefBatchTable = ChiefBatchTable();
  Batch selectedBatch = Batch.empty;
  TextEditingController quantityController = TextEditingController();
  TextEditingController optimalBatchController = TextEditingController();

  Future<void> fetchBatchesInOrder() async {
    List<Batch> batchesList = [];
    try {
      var fetchedList = await _batchTable.selectByOrderId(orderId ?? 0);
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
            batchArchiveId: batchDto.batchArchiveId,
            isready: batchDto.isready,
            orderId: orderId);
        batchesList.add(batch);
      }
      emit(state.copyWith(
          batchesList: batchesList, status: BatchesStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BatchesStatus.failure));
    }
  }

  Future<void> fetchBatches() async {
    List<Batch> batchesList = [];
    List<String> bathesNamesList = [];

    try {
      var fetchedList = await _batchTable.select();

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
            batchArchiveId: batchDto.batchArchiveId,
            orderId: batchDto.orderId);
        batchesList.add(batch);
        bathesNamesList.add('${batch.number} ${batch.name}');
      }
      selectedBatch = batchesList.first;
      emit(state.copyWith(
          batchesList: batchesList,
          status: BatchesStatus.success,
          batchesNamesList: bathesNamesList));
    } catch (e) {
      emit(state.copyWith(status: BatchesStatus.failure));
    }
  }

  Future<void> addBatch() async {
    int batchId = await _batchTable.insert(BatchDTO(
        id: 0,
        number: selectedBatch.number,
        name: selectedBatch.name,
        count: int.parse(quantityController.text),
        code: selectedBatch.code,
        technology: selectedBatch.technology,
        orderId: orderId,
        order: selectedBatch.order,
        batchArchiveId: selectedBatch.batchArchiveId,
        isready: selectedBatch.isready));

    await _chiefBatchTable.bulkInsert(
      batchId: batchId,
      quantity: int.parse(quantityController.text),
    );
  }

  Future<void> deleteBatch(int batchId) async {
    await _batchTable.delete(batchId);
  }

  // Future<void> addDetail() async {
  //   final chiefOperationTable = ChiefOperationTable();
  //   int batchId = 236;
  //   int stageId = 574;
  //   List<int> operationsIdsList = [1776, 1777, 1778];
  //   List<int> chiefDistributionOperationsList = [1557, 1558, 1559];
  //   for (int i = 0; i < 34; i++) {
  //     print(i);
  //     int chiefBatchId = await _chiefBatchTable.insert(
  //         ChiefBatchDTO(id: 0, batchId: batchId, batch: BatchDTO.empty));
  //     for (int j = 0; j < operationsIdsList.length; j++) {
  //       chiefOperationTable.insert(ChiefOperationDto(
  //           id: 0,
  //           operationId: operationsIdsList[j],
  //           stageId: stageId,
  //           chiefBatchId: chiefBatchId));
  //     }
  //   }
  //   print('закончили');
  // }
}
