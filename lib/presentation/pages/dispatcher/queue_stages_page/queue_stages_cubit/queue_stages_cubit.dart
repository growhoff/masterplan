import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:meta/meta.dart';

import '../../../../../data/repositories/supabase/dto/distribution_stage_dto.dart';
import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/dto/operator_operations_dto.dart';
import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/distribution_stage.dart';
import '../../../../../domain/model/operation.dart';
import '../../../../../domain/model/unit.dart';
import '../../../chief/stages_in_unit_page/stages_in_unit_model.dart';
import '../../orders_page/batches_page/batch_model.dart';

part 'queue_stages_state.dart';

class QueueStagesCubit extends Cubit<QueueStagesState> {
  QueueStagesCubit()
      : super(QueueStagesState(status: QueueStagesPageStatus.initial));

  final _distributionStageTable = DistributionStageTable();
  final _chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
  final _chiefOperationsTable = ChiefOperationTable();
  final _operationTable = OperationTable();
  final _operatorOperationsTable = OperatorOperationsTable();

  final _unitTable = UnitTable();

  Unit selectedUnit = Unit(id: 0, companyId: 0);

  Future fetchUnits() async {
    List<Unit> unitsList = [];

    var fetchedUnitsList = await _unitTable.select();

    for (var fetchedUnit in fetchedUnitsList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);

      final unit = Unit(
          id: unitDto.id,
          companyId: unitDto.companyId,
          name: unitDto.name,
          number: unitDto.number);

      unitsList.add(unit);
    }

    selectedUnit = unitsList.first;

    emit(state.copyWith(unitsList: unitsList));
  }

  Future fetchStages() async {
    emit(state.copyWith(status: QueueStagesPageStatus.loading));
    List<DistributionStage> distributionStagesList = [];
    List<StageModel> stagesInBatchModelList = [];
    List<int> stagesIdsList = [];
    List<int> distributionStagesIdsList = [];
    Map<int, int> operationsInStageQuantityMap = {};
    List<OperatorOperationsDTO> operatorOperationsList = [];


    var fetchedStagesList =
        await _distributionStageTable.selectByUnitId(selectedUnit.id);

    for (var fetchedStage in fetchedStagesList) {
      final fetchedStageDto = DistributionStageDto.fromMap(fetchedStage);

      final distributionStage = DistributionStage.fromDto(fetchedStageDto);

      distributionStagesList.add(distributionStage);
      distributionStagesIdsList.add(distributionStage.id);
      stagesIdsList.add(distributionStage.stageId);
      print('получили стейджи');
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
      print('получили операции');
    }
    print('начали получать ОПОП');
    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectByDistributionStagesIdsListAndNotDefectDistributionStage(
        distributionStagesIdsList);
    print('получили ОПОП');


    for (var operatorOperation in fetchedOperatorOperationsList) {
      print('зашли в цикл');
      final operatorOperationDto =
      OperatorOperationsDTO.fromMap(operatorOperation);

      print('operatorOperation id : ${operatorOperationDto.id}');
      operatorOperationsList.add(operatorOperationDto);

    }

    print('запросы получили');
    var batchesMap =
    groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      print('batchKey : $batchKey');
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
              isready: stageValue.first.chiefBatch?.batch.isready ?? false,
              orderId: stageValue.first.chiefBatch?.batch.orderId),
          stageId: stageValue.first.stageId,
          operationsQuantity:
          operationsInStageQuantityMap[stageValue.first.stageId] ?? 0,
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
          stageModel.status = 'на распределении';
        } else {
          if (stagesStatusesIdsList.contains(2)) {
            stageModel.status = 'выполняется';
          } else {
            if (stagesStatusesIdsList.contains(3)) {
              stageModel.status = 'готов';
            } else {
              if (stagesStatusesIdsList.contains(4)) {
                stageModel.status = 'выгружен';
              } else {
                if (stagesStatusesIdsList.contains(6)) {
                  stageModel.status = 'к выполнению';
                }
              }
            }
          }
        }

        if (stageModel.uploadedQuantity != totalQuantity){
          stagesInBatchModelList.add(stageModel);
        }

        prevStageInBatch = stageModel;
      });
    });
    stagesInBatchModelList
        .sort((a, b) => a.readyPercent.compareTo(b.readyPercent));
    emit(state.copyWith(stagesList: stagesInBatchModelList.reversed.toList(), status: QueueStagesPageStatus.success));
  }

  Future redistribute(StageModel stageModel) async {
    List<int> chiefDistributionOperationsIdsList = [];

    var fetchedChiefDistributionOperations =
        await _chiefDistributionOperationsTable.selectByBatchAndStageId(
            batchId: stageModel.batch.id, stageId: stageModel.stageId);

    List<int> distributionStagesIdsList = [];

    stageModel.distributionStagesList
        .forEach((stage) => distributionStagesIdsList.add(stage.id));

    for (var chiefDistributionOperation in fetchedChiefDistributionOperations) {
      final chiefDistributionOperationDto =
          ChiefDistributionOperationsDTO.fromMap(chiefDistributionOperation);
      chiefDistributionOperationsIdsList.add(chiefDistributionOperationDto.id);
    }

     await _chiefDistributionOperationsTable
      .bulkDelete(chiefDistributionOperationsIdsList);

    await _chiefOperationsTable.deleteByDistributionStagesIdsList(
        distributionStagesIdsList);

    await _distributionStageTable.bulkUpdateUnitOnNullAndStatusToOnDistribution(
        distributionStagesIdsList);
  }

  Future initQueueStagesPage() async {
    await fetchUnits();
    await fetchStages();
  }
}
