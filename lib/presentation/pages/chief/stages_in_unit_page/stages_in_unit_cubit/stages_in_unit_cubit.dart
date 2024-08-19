import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';

import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';

import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/distribution_stage.dart';

import '../../../dispatcher/orders_page/batches_page/batch_model.dart'
    hide OperationInStageModel;
import '../stages_in_unit_model.dart';

part 'stages_in_unit_state.dart';

class StagesInUnitCubit extends Cubit<StagesInUnitState> {
  StagesInUnitCubit() : super(StagesInUnitState());

  final _unitId = ChiefUnitService.instance.unitId;

  final _distributionStageTable = DistributionStageTable();

  final TextEditingController uploadStagesQuantityController =
      TextEditingController();

  Future fetchStages() async {
    List<DistributionStage> distributionStagesList = [];
    List<StageModel> stagesInBatchModelList = [];

    var fetchedStagesList =
        await _distributionStageTable.selectByUnitId(_unitId ?? 0);

    for (var fetchedStage in fetchedStagesList) {
      final fetchedStageDto = DistributionStageDto.fromMap(fetchedStage);

      final distributionStage = DistributionStage.fromDto(fetchedStageDto);

      distributionStagesList.add(distributionStage);
    }

    var batchesMap =
        groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      var stagesMap = groupBy(batchValue, (stage) => stage.stageId);

      stagesMap.forEach((stageKey, stageValue) {


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
              isready: stageValue.first.chiefBatch?.batch.isready ?? false,
              orderId: stageValue.first.chiefBatch?.batch.orderId),
          stageId: stageValue.first.stageId,
          stageNumber: stageValue.first.stage?.number ?? '',
          stageName: stageValue.first.stage?.name ?? '',
          unitNumber: stageValue.first.unit?.number ?? '',
        );

        stageModel.status = stageValue.last.stageStatus?.name ?? '';

        List<int> stagesStatusesIdsList = [];
        for (var stage in stageValue) {
          stagesStatusesIdsList.add(stage.statusId);
          switch (stage.statusId) {
            case 2:
              stageModel.inWorkQuantity++;
            case 3:
              stageModel.readyToUploadQuantity++;
              stageModel.distributionStagesIdsList.add(stage.id);
            case 4:
              stageModel.uploadedQuantity++;

            case 5:
              stageModel.defectQuantity++;
          }
        }

        int totalQuantity = batchValue.first.chiefBatch?.batch.count ?? 0;

        stageModel.allOnStageQuantity =
            stageModel.inWorkQuantity + stageModel.readyToUploadQuantity;

        stageModel.readyQuantity =
            stageModel.readyToUploadQuantity + stageModel.uploadedQuantity;

        if (stageModel.uploadedQuantity != 0 && stageModel.readyQuantity != 0) {
          stageModel.readyPercent =
              ((stageModel.uploadedQuantity / stageModel.readyQuantity) * 100)
                  .round();
        }

        stageModel.availableQuantity =
            totalQuantity - stageModel.defectQuantity;

        if (stagesStatusesIdsList.contains(1)) {
          stageModel.status = 'На распределении';
        } else {
          if (stagesStatusesIdsList.contains(2)) {
            stageModel.status = 'Выполняется';
          } else {
            if (stagesStatusesIdsList.contains(3)) {
              stageModel.status = 'Частично готов';
            } else {
              if (stagesStatusesIdsList.contains(4)) {
                stageModel.status = 'Готов';
              }
            }
          }
        }

        stagesInBatchModelList.add(stageModel);

        stagesInBatchModelList
            .sort((a, b) => a.readyPercent.compareTo(b.readyPercent));
      });
    });

    emit(state.copyWith(stagesList: stagesInBatchModelList.reversed.toList()));
  }

  Future uploadStages({
    required List<int> distributionStagesIdsList,
  }) async {
    int quantity = 0;

    quantity = uploadStagesQuantityController.text != ''
        ? int.parse(uploadStagesQuantityController.text)
        : 0;

    List<int> stagesIdsList = distributionStagesIdsList.sublist(0, quantity);

    await _distributionStageTable.bulkChangeStatusToDistributed(stagesIdsList);

    uploadStagesQuantityController.clear();
  }
}
