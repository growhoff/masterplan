import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';

import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/stage_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_archive_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_archive_table.dart';

import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
// import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
// import 'package:master_plan/data/repositories/supabase/service/stage_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_archive_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_table.dart';
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
import '../../../../../../domain/model/status.dart';
import '../batch_model.dart';

part 'batches_state.dart';

class BatchesCubit extends Cubit<BatchesState> {
  final bool positionMaster;
  final String areaNumber;
  BatchesCubit(this.positionMaster, this.areaNumber, {this.order, this.selectedStageId}): super(const BatchesState());

  final Order? order;
  final int? selectedStageId;

  final _batchTable = BatchTable();
  final _chiefBatchTable = ChiefBatchTable();
  final _batchArchiveTable = BatchArchiveTable();
  final _orderTable = OrderTable();
  final _distributionStageTable = DistributionStageTable();
  final _stageTable = StageTable();
  final _operatorOperationsTable = OperatorOperationsTable();
  // final _stageArchiveTable = StageArchiveTable();
  final _operationArchiveTable = OperationArchiveTable();
  final _operationTable = OperationTable();
  final _transferTable = TransferTable();
  final _transferArchiveTable = TransferArchiveTable();

  ExcelService _excelService = ExcelService();

  BatchArchive selectedBatch = BatchArchive.empty;
  TextEditingController quantityController = TextEditingController();
  TextEditingController optimalBatchController = TextEditingController();

  Future<void> fetchBatchesInOrder(int? orderId) async {
    emit(state.copyWith(status: BatchesStatus.loading));

    List<BatchModel> batchesList = [];
    List<int> batchesIdsList = [];
    try {
      var fetchedList = await _batchTable.selectByOrderId(orderId ?? 0);

      for (var fetchedBatch in fetchedList) {
        final batchDto = BatchDTO.fromMap(fetchedBatch);
        final batch = Batch(
            id: batchDto.id,
            numberRS: batchDto.numberRS,
            name: batchDto.name,
            number: batchDto.number,
            count: batchDto.count,
            status: Status(
                id: batchDto.status?.id ?? 0,
                name: batchDto.status?.name ?? ''),
            batchStatusId: batchDto.batchStatusId,
            code: batchDto.code,
            technology: batchDto.technology,
            order: Order(
                id: batchDto.order?.id ?? 0,
                number: batchDto.order?.number ?? '',
                priority: batchDto.order?.priority ?? 0,
                statusId: batchDto.order?.statusId ?? 0),
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
      print('batchesList: $batchesList');
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

  Future<void> addBatch({int? orderId}) async {
    final int batchNumber = await _batchTable
            .fetchBatchesInOrderQuantity(orderId ?? order?.id ?? 0) +
        1;

    int batchId = await _batchTable.insert(BatchDTO(
        id: 0,
        numberRS: selectedBatch.number,
        name: selectedBatch.name,
        number: batchNumber.toString(),
        count: int.parse(quantityController.text),
        code: selectedBatch.code ?? '',
        technology: selectedBatch.technologyNumber,
        orderId: orderId ?? order?.id ?? 0,
        isready: false));

    var fetchedOperationsArchiveList =
        await _operationArchiveTable.selectByBatchArchiveId(selectedBatch.id);

    int stageArchiveId = 0;

    int stageId = 0;

    for (var operation in fetchedOperationsArchiveList) {
      final operationArchiveDto = OperationArchiveDto.fromMap(operation);
      if (operationArchiveDto.stageArchiveId != stageArchiveId) {
        stageArchiveId = operationArchiveDto.stageArchiveId;

        stageId = await _stageTable.insert(StageDTO(
            id: operationArchiveDto.stageArchiveDTO?.id ?? 0,
            number: operationArchiveDto.stageArchiveDTO?.number ?? '',
            name: operationArchiveDto.stageArchiveDTO?.name ?? '',
            batchId: batchId));
      }

      int operationId = await _operationTable.insert(OperationDTO(
          id: 0,
          number: operationArchiveDto.number,
          name: operationArchiveDto.name,
          code: operationArchiveDto.code,
          timepz: operationArchiveDto.timepz,
          stageId: stageId,
          timeSH: operationArchiveDto.timeSH));

      var fetchedTransfersArchiveList = await _transferArchiveTable
          .selectByOperationArchiveId(operationArchiveDto.id);

      if (fetchedTransfersArchiveList.isNotEmpty) {
        for (var transfer in fetchedTransfersArchiveList) {
          final transferArchiveDto = TransferArchiveDto.fromMap(transfer);
          await _transferTable.insert(TransferDTO(
              id: 0,
              name: transferArchiveDto.name,
              code: transferArchiveDto.code,
              timesh: transferArchiveDto.timeSH,
              operationId: operationId));
        }
      }
    }

    await _chiefBatchTable.bulkInsert(
      batchId: batchId,
      quantity: int.parse(quantityController.text),
    );
  }

  Future<void> editBatch(Batch batch) async {
    if (batch.numberRS != selectedBatch.number ||
        batch.name != selectedBatch.name) {
      print(
          'batch numberRS: ${batch.numberRS}   selectedBatch number : ${selectedBatch.number}');

      print(
          'batch name: ${batch.name}   selectedBatch name : ${selectedBatch.name}');

      await _stageTable.bulkDeleteByBatchId(batch.id);

      await _chiefBatchTable.bulkDeleteByBatchId(batch.id);

      await _batchTable.updateWithoutNumber(
          batch.id,
          BatchDTO(
            id: 0,
            numberRS: selectedBatch.number,
            name: selectedBatch.name,
            code: selectedBatch.code ?? '',
            technology: selectedBatch.technologyNumber,
            count: int.parse(quantityController.text),
            companyId: 0,
            number: '',
            isready: false,
          ));

      var fetchedOperationsArchiveList =
          await _operationArchiveTable.selectByBatchArchiveId(selectedBatch.id);

      int stageArchiveId = 0;

      int stageId = 0;

      for (var operation in fetchedOperationsArchiveList) {
        final operationArchiveDto = OperationArchiveDto.fromMap(operation);
        if (operationArchiveDto.stageArchiveId != stageArchiveId) {
          stageArchiveId = operationArchiveDto.stageArchiveId;

          stageId = await _stageTable.insert(StageDTO(
              id: operationArchiveDto.stageArchiveDTO?.id ?? 0,
              number: operationArchiveDto.stageArchiveDTO?.number ?? '',
              name: operationArchiveDto.stageArchiveDTO?.name ?? '',
              batchId: batch.id));
        }

        int operationId = await _operationTable.insert(OperationDTO(
            id: 0,
            number: operationArchiveDto.number,
            name: operationArchiveDto.name,
            code: operationArchiveDto.code,
            timepz: operationArchiveDto.timepz,
            stageId: stageId,
            timeSH: operationArchiveDto.timeSH));

        var fetchedTransfersArchiveList = await _transferArchiveTable
            .selectByOperationArchiveId(operationArchiveDto.id);

        if (fetchedTransfersArchiveList.isNotEmpty) {
          for (var transfer in fetchedTransfersArchiveList) {
            final transferArchiveDto = TransferArchiveDto.fromMap(transfer);
            await _transferTable.insert(TransferDTO(
                id: 0,
                name: transferArchiveDto.name,
                code: transferArchiveDto.code,
                timesh: transferArchiveDto.timeSH,
                operationId: operationId));
          }
        }
      }

      await _chiefBatchTable.bulkInsert(
        batchId: batch.id,
        quantity: int.parse(quantityController.text),
      );
    } else {
      await _batchTable.updateCount(
          batch.id, int.parse(quantityController.text));

      await _chiefBatchTable.bulkDeleteByBatchId(batch.id);

      await _chiefBatchTable.bulkInsert(
        batchId: batch.id,
        quantity: int.parse(quantityController.text),
      );
    }
  }

  Future<void> deleteBatch(Batch batch) async {
    if ((batch.order?.statusId == 1) &&
        (batch.batchStatusId == 5 || batch.batchStatusId == 6)) {
      await _batchTable.delete(batch.id);
      await fetchBatchesInOrder(batch.orderId);
    }
  }

  Future formBatch(Batch batch) async {
    var fetchedChiefBatchedList =
        await _chiefBatchTable.selectByBatchId(batch.id);

    List<ChiefBatch> chiefBatchesList = [];
    for (var fetchedChiefBatch in fetchedChiefBatchedList) {
      final chiefBatchDto = ChiefBatchDTO.fromMap(fetchedChiefBatch);
      final chiefBatch = ChiefBatch.fromDto(chiefBatchDto);
      chiefBatchesList.add(chiefBatch);
    }

    print('chief batches list : $chiefBatchesList');

    List<Stage> allStagesList = [];
    var fetchedList = await _stageTable.selectByBatchId(batch.id);

    for (var fetchedStage in fetchedList) {
      final stageDto = StageDTO.fromMap(fetchedStage);
      final stage = Stage.fromDto(stageDto);
      allStagesList.add(stage);
    }

    // var stagesMap = groupBy(allStagesList, (stage) => stage.batchId);

    List<DistributionStage> distributionStagesList = [];
    for (var batch in chiefBatchesList) {
      //final stagesList = stagesMap[batch.batchId];

      allStagesList.forEach((stage) {
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

    List<int> chiefBatchesIdList = [];
    for (var batch in chiefBatchesList) {
      chiefBatchesIdList.add(batch.id);
    }

    await _chiefBatchTable.updateChiefBatchStatusToIsFormedByList(
        chiefBatchIdList: chiefBatchesIdList);

    await _batchTable.updateStatusToIsFormedByBatchId(batch.id);

    print('сформировали');
  }

  Future disbandBatch(Batch batch) async {
    List<ChiefBatch> chiefBatchesList = [];
    List<int> chiefBatchesIdList = [];
    List<int> distributionStagesIdsList = [];

    await _batchTable.updateStatusToFormingByBatchId(batch.id);

    var fetchedChiefBatchedList =
        await _chiefBatchTable.selectByBatchId(batch.id);

    for (var fetchedChiefBatch in fetchedChiefBatchedList) {
      final chiefBatchDto = ChiefBatchDTO.fromMap(fetchedChiefBatch);
      final chiefBatch = ChiefBatch.fromDto(chiefBatchDto);
      chiefBatchesList.add(chiefBatch);
      chiefBatchesIdList.add(chiefBatch.id);
    }

    var fetchedDistributionStagesList =
        await _distributionStageTable.selectByBatchId(batch.id);

    for (var stage in fetchedDistributionStagesList) {
      final distributionStageDto = DistributionStageDto.fromMap(stage);
      distributionStagesIdsList.add(distributionStageDto.id);
    }

    await _distributionStageTable
        .bulkDeleteByIdsList(distributionStagesIdsList);

    await _chiefBatchTable.updateChiefBatchStatusToIsFormedByList(
        chiefBatchIdList: chiefBatchesIdList);

    print('расформировали');
  }

  Future formOrder() async {
    emit(state.copyWith(status: BatchesStatus.loading));
    print('начали формировать');

    List<int> batchesIdList = [];

    for (var batch in state.batchesList) {
      if (batch.batch.batchStatusId == 5) {
        batchesIdList.add(batch.batch.id);
      }
    }
    var fetchedChiefBatchedList =
        await _chiefBatchTable.selectByBatchesIdList(batchesIdList);

    List<ChiefBatch> chiefBatchesList = [];
    for (var fetchedChiefBatch in fetchedChiefBatchedList) {
      final chiefBatchDto = ChiefBatchDTO.fromMap(fetchedChiefBatch);
      final chiefBatch = ChiefBatch.fromDto(chiefBatchDto);
      chiefBatchesList.add(chiefBatch);
    }

    print('chief batches list : $chiefBatchesList');

    List<Stage> allStagesList = [];
    var fetchedList = await _stageTable.selectByBatchesIdsList(batchesIdList);

    for (var fetchedStage in fetchedList) {
      final stageDto = StageDTO.fromMap(fetchedStage);
      final stage = Stage.fromDto(stageDto);
      print('stage batch : ${stage.batchId}');
      allStagesList.add(stage);
    }

    var stagesMap = groupBy(allStagesList, (stage) => stage.batchId);

    List<DistributionStage> distributionStagesList = [];
    for (var batch in chiefBatchesList) {
      print('batch: ${batch.batchId}');
      final stagesList = stagesMap[batch.batchId];

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

    await _batchTable.updateStatusToIsFormedByBatchesIdsList(batchesIdList);

    emit(state.copyWith(status: BatchesStatus.success));
  }

  Future initEditBatchPage(Batch batch) async {
    await fetchBatches();

    quantityController.text = batch.count.toString();

    selectedBatch = state.batchesArchiveList.firstWhere((batchInList) =>
        (batchInList.name == batch.name &&
            batchInList.number == batch.numberRS));
  }

  Future fetchStagesInBatch(int batchId) async {
    List<DistributionStage> distributionStagesList = [];
    List<StageModel> stagesInBatchModelList = [];
    List<int> distributionStagesIdsList = [];
    List<int> stagesIdsList = [];
    List<OperatorOperationsDTO> operatorOperationsList = [];
    Map<int, int> operationsInStageQuantityMap = {};
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
      distributionStagesIdsList.add(distributionStage.id);
      stagesIdsList.add(distributionStage.stageId);
    }

    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectByDistributionStagesIdsListAndNotDefectDistributionStage(
            distributionStagesIdsList);

    for (var operatorOperation in fetchedOperatorOperationsList) {
      final operatorOperationDto =
          OperatorOperationsDTO.fromMap(operatorOperation);

      operatorOperationsList.add(operatorOperationDto);
    }

    var fetchedOperationsList =
        await _operationTable.selectByStageIdList(stagesIdsList);

    for (var operation in fetchedOperationsList) {
      final operationDto = OperationDTO.fromMap(operation);

      if (operationsInStageQuantityMap.containsKey(operationDto.stageId)) {
        operationsInStageQuantityMap[operationDto.stageId] =
            (operationsInStageQuantityMap[operationDto.stageId]! + 1);
      } else {
        operationsInStageQuantityMap[operationDto.stageId] = 1;
      }
    }

    var batchesMap =
        groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      var stagesMap = groupBy(distributionStagesList, (stage) => stage.stageId);

      StageModel prevStageInBatch = StageModel(
          stageId: 0,
          stageNumber: '',
          stageName: '',
          batch: Batch.empty,
          unitNumber: '',
          operationsQuantity: 0);

      stagesMap.forEach((stageKey, stageValue) {
        var operatorOperationsInStageList = operatorOperationsList.where(
            (operation) =>
                operation.batchId == batchKey && operation.stageId == stageKey);

        int readyOperationsQuantity = 0;
        for (var operation in operatorOperationsInStageList) {
          if (operation.statusId == 9) {
            readyOperationsQuantity++;
          }
        }
        final stageInBatchModel = StageModel(
            batch: Batch(
                id: stageValue.first.chiefBatch?.batch.id ?? 0,
                numberRS: stageValue.first.chiefBatch?.batch.numberRS ?? '',
                name: stageValue.first.chiefBatch?.batch.name ?? '',
                order: Order(
                    id: stageValue.first.chiefBatch?.batch.order?.id ?? 0,
                    number:
                        stageValue.first.chiefBatch?.batch.order?.number ?? '',
                    priority:
                        stageValue.first.chiefBatch?.batch.order?.priority ?? 0,
                    statusId:
                        stageValue.first.chiefBatch?.batch.order?.statusId ??
                            0),
                count: stageValue.first.chiefBatch?.batch.count ?? 0,
                code: stageValue.first.chiefBatch?.batch.code ?? '',
                technology: stageValue.first.chiefBatch?.batch.technology ?? '',
                isready: stageValue.first.chiefBatch?.batch.isready ?? false,
                orderId: stageValue.first.chiefBatch?.batch.orderId),
            stageId: stageValue.first.stageId,
            stageNumber: stageValue.first.stage?.number ?? '',
            stageName: stageValue.first.stage?.name ?? '',
            unitNumber: stageValue.first.unit?.number ?? '',
            operationsQuantity:
                operationsInStageQuantityMap[stageValue.first.stageId] ?? 0);

        print(stageInBatchModel.batch.order?.number);

        //stageInBatchModel.status = value.last.stageStatus?.name ?? '';
        List<int> stageIdsStatusesList = [];
        for (var stage in stageValue) {
          stageInBatchModel.distributionStagesList.add(stage);
          stageIdsStatusesList.add(stage.statusId);

          switch (stage.statusId) {
            case 2:
              print('inWork: ${stageInBatchModel.inWorkQuantity}');
              print('prevUpload: ${prevStageInBatch.uploadedQuantity}');
              print('prev batch id : ${prevStageInBatch.batch.id}');
              if (stageInBatchModel.inWorkQuantity <
                      prevStageInBatch.uploadedQuantity ||
                  prevStageInBatch.batch.id == 0) {
                stageInBatchModel.inWorkQuantity++;
              }
            case 3:
              stageInBatchModel.readyToUploadQuantity++;

            case 4:
              stageInBatchModel.uploadedQuantity++;
            case 5:
              stageInBatchModel.defectQuantity++;
            case 6:
              if (stageInBatchModel.inWorkQuantity <
                      prevStageInBatch.uploadedQuantity ||
                  prevStageInBatch.batch.id == 0) {
                stageInBatchModel.inWorkQuantity++;
              }
          }
        }

        print(stageIdsStatusesList);

        if (stageIdsStatusesList.contains(1)) {
          stageInBatchModel.status = 'на распределении';
        } else {
          if (stageIdsStatusesList.contains(2)) {
            stageInBatchModel.status = 'выполняется';
          } else {
            if (stageIdsStatusesList.contains(3)) {
              stageInBatchModel.status = 'готов';
            } else {
              if (stageIdsStatusesList.contains(4)) {
                stageInBatchModel.status = 'выгружен';
              } else {
                if (stageIdsStatusesList.contains(6)) {
                  stageInBatchModel.status = 'к выполнению';
                }
              }
            }
          }
        }

        stageInBatchModel.allOnStageQuantity =
            stageInBatchModel.inWorkQuantity +
                stageInBatchModel.readyToUploadQuantity;

        stageInBatchModel.readyQuantity =
            stageInBatchModel.readyToUploadQuantity +
                stageInBatchModel.uploadedQuantity;
        stagesInBatchModelList.add(stageInBatchModel);

        int totalQuantity = batchValue.first.chiefBatch?.batch.count ?? 0;

        stageInBatchModel.readyQuantity =
            stageInBatchModel.readyToUploadQuantity +
                stageInBatchModel.uploadedQuantity;

        print(
            '${stageInBatchModel.stageNumber} ${stageInBatchModel.stageName}  detail: ${stageInBatchModel.batch.id}');

        print('total quantity: ${totalQuantity}');
        print('operationsQuantity: ${stageInBatchModel.operationsQuantity}');
        print('defect quantity: ${stageInBatchModel.defectQuantity}');
        if (stageInBatchModel.operationsQuantity != 0) {
          stageInBatchModel.readyPercent = ((readyOperationsQuantity /
                      (stageInBatchModel.operationsQuantity *
                          (totalQuantity - stageInBatchModel.defectQuantity))) *
                  100)
              .round();
        }

        stageInBatchModel.availableQuantity =
            stageInBatchModel.readyToUploadQuantity +
                stageInBatchModel.inWorkQuantity;

        stageInBatchModel.waitFromPrevStagesQuantity =
            prevStageInBatch.availableQuantity +
                prevStageInBatch.waitFromPrevStagesQuantity;

        prevStageInBatch = stageInBatchModel;
      });
    });

    emit(state.copyWith(stagesInBatchList: stagesInBatchModelList));
  }

  Future fetchOperationsInStage(StageModel stageInBatch) async {
    List<OperationInStageModel> operationsInStageList = [];
    List<int> operationsIdsList = [];
    print(stageInBatch.stageId);
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

    List<int> distributionStagesIdsList = [];

    stageInBatch.distributionStagesList
        .forEach((stage) => distributionStagesIdsList.add(stage.id));

    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectByOperationIdListAndDistributionStagesIdList(
            operationsIdsList: operationsIdsList,
            distributionStageIdsList: distributionStagesIdsList);

    OperatorOperationsDTO prevOperation = OperatorOperationsDTO.empty;

    for (int i = 0; i < fetchedOperatorOperationsList.length; i++) {
      var operation = fetchedOperatorOperationsList[i];
      final operatorOperationsDto = OperatorOperationsDTO.fromMap(operation);
      // print(
      //   'ID : ${operatorOperationsDto.id}  , name: ${operatorOperationsDto.operation.name}  ,  status: ${operatorOperationsDto.statusId}');
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

  Future loadOrder() async {
    await _excelService.dispatcherLoadOrder();
  }
}
