import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';

import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';

import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/order_table.dart';

import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';

import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/service/operation_table.dart';
import '../../../../../data/repositories/supabase/service/stage_table.dart';
import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/distribution_stage.dart';

import '../../../../../domain/model/status.dart';
import '../../../dispatcher/orders_page/batches_page/batch_model.dart'
    hide OperationInStageModel;
import '../stages_in_unit_model.dart';

part 'stages_in_unit_state.dart';

class StagesInUnitCubit extends Cubit<StagesInUnitState> {
  StagesInUnitCubit() : super(StagesInUnitState());

  final _unitId = ChiefUnitService.instance.unitId;

  final _distributionStageTable = DistributionStageTable();
  final _batchTable = BatchTable();
  final _orderTable = OrderTable();
  final _stageTable = StageTable();
  final _chiefBatchTable = ChiefBatchTable();
  final _operatorOperationsTable = OperatorOperationsTable();

  final _operationTable = OperationTable();

  final TextEditingController uploadStagesQuantityController =
      TextEditingController();

  Future fetchStages() async {
    emit(state.copyWith(status: StagesInUnitStateStatus.loading));
    List<DistributionStage> distributionStagesList = [];
    List<int> stagesIdsList = [];
    List<int> distributionStagesIdsList = [];
    Map<int, int> operationsInStageQuantityMap = {};
    List<OperatorOperationsDTO> operatorOperationsList = [];
    List<StageModel> stagesInBatchModelList = [];

    var fetchedStagesList =
        await _distributionStageTable.selectByUnitId(_unitId ?? 0);

    for (var fetchedStage in fetchedStagesList) {
      final fetchedStageDto = DistributionStageDto.fromMap(fetchedStage);

      final distributionStage = DistributionStage.fromDto(fetchedStageDto);

      distributionStagesList.add(distributionStage);
      distributionStagesIdsList.add(distributionStage.id);
      stagesIdsList.add(distributionStage.stageId);
      //print('получили стейджи');
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
     // print('получили операции');
    }

    distributionStagesIdsList.toSet();

    var halfList = distributionStagesIdsList
        .skip((distributionStagesIdsList.length / 2).round());

   // print('начали получать ОПОП');
    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectByDistributionStagesIdsListAndNotDefectDistributionStage(
        halfList.toList());



   // print('получили ОПОП');
    for (var operatorOperation in fetchedOperatorOperationsList) {
      final operatorOperationDto =
          OperatorOperationsDTO.fromMap(operatorOperation);

      print(operatorOperationDto.id);
      operatorOperationsList.add(operatorOperationDto);
    }

    var lastList = distributionStagesIdsList.getRange(0, halfList.length);

    fetchedOperatorOperationsList.addAll(await _operatorOperationsTable
        .selectByDistributionStagesIdsListAndNotDefectDistributionStage(
        lastList.toList()));

    //print('запросы получили');
    var batchesMap =
        groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      var stagesMap = groupBy(batchValue, (stage) => stage.stageId);

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

        final stageModel = StageModel(
          batch: Batch(
              order: Order(
                  id: stageValue.first.chiefBatch?.batch.order?.id ?? 0,
                  number:
                      stageValue.first.chiefBatch?.batch.order?.number ?? '',
                  priority:
                      stageValue.first.chiefBatch?.batch.order?.priority ?? 0,
                  statusId:
                      stageValue.first.chiefBatch?.batch.order?.statusId ?? 0),
              id: stageValue.first.chiefBatch?.batch.id ?? 0,
              numberRS: stageValue.first.chiefBatch?.batch.numberRS ?? '',
              number: stageValue.first.chiefBatch?.batch.number,
              name: stageValue.first.chiefBatch?.batch.name ?? '',
              count: stageValue.first.chiefBatch?.batch.count ?? 0,
              code: stageValue.first.chiefBatch?.batch.code ?? '',
              technology: stageValue.first.chiefBatch?.batch.technology ?? '',

              orderId: stageValue.first.chiefBatch?.batch.orderId),
          stageId: stageValue.first.stageId,
          operationsQuantity:
              operationsInStageQuantityMap[stageValue.first.stageId] ?? 0,
          stageNumber: stageValue.first.stage?.number ?? '',
          stageName: stageValue.first.stage?.name ?? '',
          unitNumber: stageValue.first.unit?.number ?? '',
        );

        stageModel.status = stageValue.last.stageStatus;

        List<int> stagesStatusesIdsList = [];
        for (var stage in stageValue) {
          stagesStatusesIdsList.add(stage.statusId);
          switch (stage.statusId) {
            case 2:
              stageModel.inWorkQuantity++;
            case 3:
              stageModel.readyToUploadQuantity++;
              stageModel.distributionStagesList.add(stage);
            case 4:
              stageModel.uploadedQuantity++;
            case 5:
              stageModel.defectQuantity++;

            case 6:
              stageModel.onDistributionQuantity++;
          }
        }

        int totalQuantity = batchValue.first.chiefBatch?.batch.count ?? 0;

        stageModel.allOnStageQuantity =
            stageModel.inWorkQuantity + stageModel.readyToUploadQuantity;

        stageModel.readyQuantity =
            stageModel.readyToUploadQuantity + stageModel.uploadedQuantity;

        print(
            '${stageModel.stageNumber} ${stageModel.stageName}  detail: ${stageModel.batch.id}');

        if (stageModel.operationsQuantity != 0) {
          stageModel.readyPercent = ((readyOperationsQuantity /
                      (stageModel.operationsQuantity *
                          (totalQuantity - stageModel.defectQuantity))) *
                  100)
              .round();
        }

        stageModel.availableQuantity = totalQuantity -
            stageModel.defectQuantity -
            stageModel.uploadedQuantity;

        if (stagesStatusesIdsList.contains(1)) {
          stageModel.status = Status(id: 1, name: 'на распределении');
        } else {
          if (stagesStatusesIdsList.contains(2)) {
            stageModel.status = Status(id: 2, name: 'выполняется');
          } else {
            if (stagesStatusesIdsList.contains(3)) {
              stageModel.status = Status(id: 3, name: 'готов');
            } else {
              if (stagesStatusesIdsList.contains(4)) {
                stageModel.status = Status(id: 4, name: 'выгружен');
              } else {
                if (stagesStatusesIdsList.contains(6)) {
                  stageModel.status = Status(id: 6, name: 'к выполнению');
                }
              }
            }
          }
        }

        if (stageModel.uploadedQuantity != totalQuantity) {
          stagesInBatchModelList.add(stageModel);
        }

        prevStageInBatch = stageModel;
      });
    });
    stagesInBatchModelList
        .sort((a, b) => a.readyPercent.compareTo(b.readyPercent));
    emit(state.copyWith(
        stagesList: stagesInBatchModelList.reversed.toList(),
        status: StagesInUnitStateStatus.success));
  }

  Future uploadStages({
    required StageModel stageModel,
  }) async {
    int quantity = 0;

    quantity = uploadStagesQuantityController.text != ''
        ? int.parse(uploadStagesQuantityController.text)
        : 0;

    List<DistributionStage> uploadedDistributionStagesList =
        stageModel.distributionStagesList.sublist(0, quantity);

    List<int> uploadedDistributionStagesIdsList = [];

    uploadedDistributionStagesList
        .forEach((stage) => uploadedDistributionStagesIdsList.add(stage.id));

    await _distributionStageTable
        .bulkChangeStatusToDistributed(uploadedDistributionStagesIdsList);

    var fetchedStagesList =
        await _stageTable.selectByBatchId(stageModel.batch.id);

    final lastStage = StageDTO.fromMap(fetchedStagesList.last);

    ///если этап последний в детали
    if (lastStage.id == stageModel.stageId) {
      List<int> chiefBatchesIdsList = [];
      uploadedDistributionStagesList
          .forEach((stage) => chiefBatchesIdsList.add(stage.chiefBatchId));

      ///поменять статус у всех chiefBatch
      await _chiefBatchTable.updateStatusReady(chiefBatchesIdsList);

      ///если выгружают все оставшиеся последние этапы, статус партии меняется на готово
      if (quantity == stageModel.distributionStagesList.length) {
        await _batchTable.updateStatusReady([stageModel.batch.id]);
      }

      var fetchedBatchesInOrderList =
          await _batchTable.selectByOrderId(stageModel.batch.orderId ?? 0);

      int readyBatchesQuantity = 0;

      for (var batch in fetchedBatchesInOrderList) {
        final batchDto = BatchDTO.fromMap(batch);
        if (batchDto.batchStatusId == 2) {
          readyBatchesQuantity++;
        }
      }

      if (readyBatchesQuantity == fetchedBatchesInOrderList.length) {
        await _orderTable.updateStatusReady([stageModel.batch.orderId ?? 0]);
      }
    }

    uploadStagesQuantityController.clear();
  }
}
