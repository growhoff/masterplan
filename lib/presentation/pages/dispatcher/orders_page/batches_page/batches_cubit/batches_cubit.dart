import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_archive_table.dart';

import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';
import 'package:master_plan/domain/model/operation.dart';

import '../../../../../../data/repositories/supabase/dto/batch_archive_dto.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import '../../../../../../data/repositories/supabase/service/order_table.dart';
import '../../../../../../domain/model/batch.dart';
import '../../../../../../domain/model/batch_archive.dart';
import '../../../../../../domain/model/order.dart';
import '../../../../../../domain/model/stage.dart';
import '../batch_model.dart';

part 'batches_state.dart';

class BatchesCubit extends Cubit<BatchesState> {
  BatchesCubit({
    this.order,
  }) : super(const BatchesState());

  final Order? order;

  final _batchTable = BatchTable();
  final _chiefBatchTable = ChiefBatchTable();
  final _batchArchiveTable = BatchArchiveTable();
  final _orderTable = OrderTable();
  final _distributionStageTable = DistributionStageTable();
  final _stageTable = StageTable();
  final _operatorOperationsTable = OperatorOperationsTable();
  final _operationTable = OperationTable();
  BatchArchive selectedBatch = BatchArchive.empty;
  TextEditingController quantityController = TextEditingController();
  TextEditingController optimalBatchController = TextEditingController();

  Future<void> fetchBatchesInOrder() async {
    List<BatchModel> batchesList = [];
    List<int> batchesIdsList = [];
    try {
      var fetchedList = await _batchTable.selectByOrderId(order?.id ?? 0);

      for (var fetchedBatch in fetchedList) {
        final batchDto = BatchDTO.fromMap(fetchedBatch);
        final batch = Batch(
            id: batchDto.id,
            numberRS: batchDto.numberRS,
            name: batchDto.name,
            number: batchDto.number,
            count: batchDto.count,
            batchStatusName: statusNameFromId(batchDto.batchStatusId),
            batchStatusId: batchDto.batchStatusId,
            code: batchDto.code,
            technology: batchDto.technology,
            order: Order(
                id: batchDto.order?.id ?? 0,
                number: batchDto.order?.number ?? '',
                priority: batchDto.order?.priority ?? 0,
                statusId: batchDto.order?.statusId ?? 0),
            batchArchiveId: batchDto.batchArchiveId,
            isready: batchDto.isready,
            orderId: order?.id);
        batchesList.add(BatchModel(batch: batch));
        batchesIdsList.add(batch.id);
      }

      var fetchedChiefBatchesList =
          await _chiefBatchTable.selectByBatchesIdList(batchesIdsList);

      for (var fetchedChiefBatch in fetchedChiefBatchesList) {
        final chiefBatchDto = ChiefBatchDTO.fromMap(fetchedChiefBatch);

        final chiefBatch = ChiefBatch.fromDto(chiefBatchDto);

        final batchModel = batchesList
            .firstWhere((batch) => batch.batch.id == chiefBatch.batchId);

        switch (chiefBatch.batchStatusId) {
          case 1:
            batchModel.inWorkQuantity++;
          case 2:
            batchModel.readyQuantity++;

          case 3:
            batchModel.defectQuantity++;

          case 4:
            batchModel.readyQuantity++;
        }
        if (batchModel.readyQuantity != 0 && batchModel.batch.count != 0) {
          batchModel.readyPercent =
              ((batchModel.readyQuantity / batchModel.batch.count) * 100)
                  .round();
        }
      }

      emit(state.copyWith(
          batchesList: batchesList, status: BatchesStatus.success));
      print(batchesList);
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
            code: batchDto.code,
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
    final int batchNumber =
        await _batchTable.fetchBatchesInOrderQuantity(order?.id ?? 0) + 1;

    print('batchNumber : $batchNumber');
    int batchId = await _batchTable.insert(BatchDTO(
        id: 0,
        numberRS: selectedBatch.number,
        name: selectedBatch.name,
        number: batchNumber.toString(),
        count: int.parse(quantityController.text),
        code: '',
        technology: selectedBatch.technologyNumber,
        orderId: order?.id,
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
      batchesIdList.add(batch.batch.id);
      batchesArchiveIdList.add(batch.batch.batchArchiveId ?? 0);
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
          id: 0,
          chiefBatchId: batch.id,
          stageId: stage.id,
          statusId: 1,
        ));
      });
    }
    await _distributionStageTable.bulkInsert(
        distributionStagesList: distributionStagesList);

    print('вставили: $distributionStagesList');
    await _orderTable.changeStatusToFormed(order?.id ?? 0);

    List<int> chiefBatchesIdList = [];
    for (var batch in chiefBatchesList) {
      chiefBatchesIdList.add(batch.id);
    }

    await _chiefBatchTable.updateChiefBatchStatusToInWorkList(
        chiefBatchIdList: chiefBatchesIdList);
  }

  Future fetchStagesInBatch(int batchId) async {
    List<DistributionStage> distributionStagesList = [];
    List<StageInBatchModel> stagesInBatchModelList = [];
    var fetchedChiefBatchesList =
        await _chiefBatchTable.selectByBatchesIdList([batchId]);
    List<int> chiefBatchesIdsList = [];
    for (var fetchedChiefBatch in fetchedChiefBatchesList) {
      final chiefBatchDto = ChiefBatchDTO.fromMap(fetchedChiefBatch);
      chiefBatchesIdsList.add(chiefBatchDto.id);
    }

    var fetchedStagesList = await _distributionStageTable
        .selectByChiefBatchIdsList(chiefBatchesIdsList);

    for (var fetchedStage in fetchedStagesList) {
      final fetchedStageDto = DistributionStageDto.fromMap(fetchedStage);

      final distributionStage = DistributionStage.fromDto(fetchedStageDto);

      distributionStagesList.add(distributionStage);
    }

    var stagesMap = groupBy(distributionStagesList, (stage) => stage.stageId);

    stagesMap.forEach((key, value) {
      final stageInBatchModel = StageInBatchModel(
          stageId: value.first.stageId,
          stageNumber: value.first.stage?.number ?? '',
          stageName: value.first.stage?.name ?? '');

      stageInBatchModel.status = statusNameFromId(value.last.statusId);

      for (var stage in value) {
        stageInBatchModel.distributionStagesIdsList.add(stage.id);

        switch (stage.statusId) {
          case 2:
            stageInBatchModel.inWorkQuantity++;
          case 3:
            stageInBatchModel.readyToUploadQuantity++;

          case 4:
            stageInBatchModel.uploadedQuantity++;
          case 5:
            stageInBatchModel.defectQuantity++;
        }
      }

      stageInBatchModel.allOnStageQuantity = stageInBatchModel.inWorkQuantity +
          stageInBatchModel.readyToUploadQuantity;

      stageInBatchModel.readyQuantity =
          stageInBatchModel.readyToUploadQuantity +
              stageInBatchModel.uploadedQuantity;
      stagesInBatchModelList.add(stageInBatchModel);

      if (stageInBatchModel.uploadedQuantity != 0 &&
          stageInBatchModel.readyQuantity != 0) {
        stageInBatchModel.readyPercent = ((stageInBatchModel.uploadedQuantity /
                    stageInBatchModel.readyQuantity) *
                100)
            .round();
      }

      emit(state.copyWith(stagesInBatchList: stagesInBatchModelList));
    });
  }

  Future fetchOperationsInStage(StageInBatchModel stageInBatch) async {
    List<OperationInStageModel> operationsInStageList = [];
    List<int> operationsIdsList = [];

    var fetchedOperationsList =
        await _operationTable.selectByStageId(stageId: stageInBatch.stageId);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperationDTO.fromMap(fetchedOperation);

      final operation = Operation(
          id: operationDto.id,
          number: operationDto.number,
          name: operationDto.name,
          code: operationDto.code,
          timepz: operationDto.timepz,
          stageId: operationDto.stageId);

      final operationInStage = OperationInStageModel(operation: operation);
      operationsInStageList.add(operationInStage);
      operationsIdsList.add(operation.id);
    }

    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectByOperationIdListAndDistributionStagesIdList(
            operationsIdsList: operationsIdsList,
            distributionStageIdsList: stageInBatch.distributionStagesIdsList);

    OperatorOperationsDTO prevOperation = OperatorOperationsDTO.empty;

    for (int i = 0; i < fetchedOperatorOperationsList.length; i++) {
      var operation = fetchedOperatorOperationsList[i];
      final operatorOperationsDto = OperatorOperationsDTO.fromMap(operation);
      final operationInStage = operationsInStageList.firstWhere((operation) =>
          operation.operation.id == operatorOperationsDto.operationId);

      operationInStage.areaNumber = operatorOperationsDto.area?.number ?? '_';

      operationInStage.totalOperationsQuantity++;

      switch (operatorOperationsDto.statusId) {
        case 2:
          if (i == 0) {
            operationInStage.onDistribution++;

            print('1: ${operatorOperationsDto.id}');
          } else {
            if (operatorOperationsDto.chiefBatchId !=
                prevOperation.chiefBatchId) {
              operationInStage.onDistribution++;

              print(
                  '2: ${operatorOperationsDto.chiefBatchId}    ${prevOperation.chiefBatchId}');
            } else {
              if ((operatorOperationsDto.modific == false ||
                      operatorOperationsDto.modific == null) &&
                  (prevOperation.statusId == 9)) {
                operationInStage.onDistribution++;

                print('3: ${operatorOperationsDto.id}');
              }
            }
          }
        case 3:
          operationInStage.distributed++;

        case 4:
          operationInStage.modificationQuantity++;

        case 5:
          operationInStage.defectQuantity++;
        case 6:
          operationInStage.onCheckQuantity++;

        case 7:
          operationInStage.onMachinesQuantity++;
        case 9:
          operationInStage.readyQuantity++;
      }
      prevOperation = operatorOperationsDto;
    }

    for (var operation in operationsInStageList) {
      if (operation.readyQuantity != 0 &&
          operation.totalOperationsQuantity != 0) {
        operation.readyPercent =
            ((operation.readyQuantity / operation.totalOperationsQuantity) *
                    100)
                .round();
      }
    }

    emit(state.copyWith(operationsInStageList: operationsInStageList));
  }

  String statusNameFromId(statusId) {
    String statusName = '';
    switch (statusId) {
      case 1:
        statusName = 'В работе';
      case 2:
        statusName = 'Готово';
      case 3:
        statusName = 'Брак';
      case 4:
        statusName = 'Выгружен диспетчеру';
      case 5:
        statusName = 'Выполняется';
      case 6:
        statusName = 'Дефицит';
      case 7:
        statusName = 'Выполнена';
      case 8:
        statusName = 'Выполнена (с дефицитом)';
    }
    return statusName;
  }
}
