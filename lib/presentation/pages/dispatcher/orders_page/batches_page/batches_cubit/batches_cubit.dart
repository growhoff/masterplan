import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_archive_table.dart';

import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';

import '../../../../../../data/repositories/supabase/dto/batch_archive_dto.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import '../../../../../../data/repositories/supabase/service/order_table.dart';
import '../../../../../../domain/model/batch.dart';
import '../../../../../../domain/model/batch_archive.dart';
import '../../../../../../domain/model/order.dart';
import '../../../../../../domain/model/stage.dart';

part 'batches_state.dart';

class BatchesCubit extends Cubit<BatchesState> {
  BatchesCubit(this.order) : super(const BatchesState());

  final Order? order;
  bool? isOrderFormed = false;

  final _batchTable = BatchTable();
  final _chiefBatchTable = ChiefBatchTable();
  final _batchArchiveTable = BatchArchiveTable();
  final _orderTable = OrderTable();
  final _distributionStageTable = DistributionStageTable();
  final _stageTable = StageTable();
  BatchArchive selectedBatch = BatchArchive.empty;
  TextEditingController quantityController = TextEditingController();
  TextEditingController optimalBatchController = TextEditingController();

  Future<void> fetchBatchesInOrder() async {
    if (order?.isFormed == true) {
      isOrderFormed = true;
    }
    List<Batch> batchesList = [];
    try {
      var fetchedList = await _batchTable.selectByOrderId(order?.id ?? 0);
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
            orderId: order?.id);
        batchesList.add(batch);
      }
      emit(state.copyWith(
          batchesList: batchesList, status: BatchesStatus.success));
    } catch (e) {
      emit(state.copyWith(status: BatchesStatus.failure));
    }
  }

  Future<void> fetchBatches() async {
    List<BatchArchive> batchesList = [];

    try {
      var fetchedList = await _batchArchiveTable.select();

      for (var fetchedBatch in fetchedList) {
        final batchDto = BatchArchiveDto.fromMap(fetchedBatch);
        final batchArchive = BatchArchive(
            id: batchDto.id,
            number: batchDto.number,
            name: batchDto.name,
            technologyNumber: batchDto.technologyNumber,
            companyId: batchDto.companyId);

        batchesList.add(batchArchive);
      }
      selectedBatch = batchesList.first;
      emit(state.copyWith(
        batchesArchiveList: batchesList,
        status: BatchesStatus.success,
      ));
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
        code: '',
        technology: selectedBatch.technologyNumber,
        orderId: order?.id,
        order: 0,
        batchArchiveId: selectedBatch.id,
        isready: false));

    await _chiefBatchTable.bulkInsert(
      batchId: batchId,
      quantity: int.parse(quantityController.text),
    );
  }

  Future<void> deleteBatch(int batchId) async {
    await _batchTable.delete(batchId);
  }

  Future formOrder() async {
    print('начали формировать');

    List<int> batchesIdList = [];
    List<int> batchesArchiveIdList = [];
    for (var batch in state.batchesList) {
      batchesIdList.add(batch.id);
      batchesArchiveIdList.add(batch.batchArchiveId ?? 0);
    }
    var fetchedChiefBatchedList =
        await _chiefBatchTable.selectByBatchesIdList(batchesIdList);

    List<ChiefBatch> chiefBatchesList = [];
    for (var fetchedChiefBatch in fetchedChiefBatchedList) {
      final chiefBatchDto = ChiefBatchDTO.fromMap(fetchedChiefBatch);
      final chiefBatch = ChiefBatch.fromDto(chiefBatchDto);
      chiefBatchesList.add(chiefBatch);
    }

    List<Stage> allStagesList = [];
    var fetchedLit =
        await _stageTable.selectByBatchesArchiveIdList(batchesArchiveIdList);

    for (var fetchedStage in fetchedLit) {
      final stageDto = StageDTO.fromMap(fetchedStage);
      final stage = Stage.fromDto(stageDto);

      allStagesList.add(stage);
    }

    var stagesMap = groupBy(allStagesList, (stage) => stage.batchArchiveId);

    List<DistributionStage> distributionStagesList = [];
    for (var batch in chiefBatchesList) {
      final stagesList = stagesMap[batch.batch.batchArchiveId];

      stagesList?.forEach((stage) {
        distributionStagesList.add(DistributionStage(
            id: 0, chiefBatchId: batch.id, stageId: stage.id, statusId: 1));
      });
    }
    await _distributionStageTable.bulkInsert(
        distributionStagesList: distributionStagesList);

    await _orderTable.changeIsFormedToTrue(order?.id ?? 0);

    List<int> chiefBatchesIdList = [];
    for (var batch in chiefBatchesList) {
      chiefBatchesIdList.add(batch.id);
    }

    await _chiefBatchTable.updateChiefBatchStatusToInWorkList(
        chiefBatchIdList: chiefBatchesIdList);

    isOrderFormed = true;

    // List<int> batchesArchiveIdList = [];
    // Map<int, int> batchIdToQuantityMap = {};
    // Map<int, int> batchArchiveIdToBatchIdMap = {};
    // for (var batch in state.batchesList) {
    //   batchesArchiveIdList.add(batch.batchArchiveId ?? 0);
    //   batchIdToQuantityMap[batch.batchArchiveId ?? 0] = batch.count;
    //   batchArchiveIdToBatchIdMap[batch.batchArchiveId ?? 0] = batch.id;
    // }
    //
    // List<Stage> stagesList = [];
    // var fetchedLit =
    //     await _stageTable.selectByBatchesArchiveIdList(batchesArchiveIdList);
    //
    // for (var fetchedStage in fetchedLit) {
    //   final stageDto = StageDTO.fromMap(fetchedStage);
    //   final stage = Stage.fromDto(stageDto);
    //
    //   stagesList.add(stage);
    // }
    //
    // var stagesMap = groupBy(stagesList, (stage) => stage.batchArchiveId);
    //
    // List<DistributionStage> distributionStagesList = [];
    //
    // stagesMap.forEach((key, value) {
    //   final int quantity = batchIdToQuantityMap[key] ?? 0;
    //
    //   for (int i = 0; i < quantity; i++) {
    //     for (var stage in value) {
    //       distributionStagesList.add(DistributionStage(
    //           id: 0,
    //           batchId: batchArchiveIdToBatchIdMap[stage.batchArchiveId] ?? 1,
    //           stageId: stage.id,
    //           statusId: 4,
    //           unitId: 1));
    //     }
    //   }
    // });
    // await _distributionStageTable.bulkInsert(
    //     distributionStagesList: distributionStagesList);
    //
    // await _orderTable.changeIsFormedToTrue(order?.id ?? 0);
    //
    // isOrderFormed = true;
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
