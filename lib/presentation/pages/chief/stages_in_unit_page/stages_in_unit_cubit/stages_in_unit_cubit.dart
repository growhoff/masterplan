import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/domain/model/operation.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:meta/meta.dart';

import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/dto/operator_operations_dto.dart';
import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/distribution_stage.dart';
import '../stages_in_unit_model.dart';

part 'stages_in_unit_state.dart';

class StagesInUnitCubit extends Cubit<StagesInUnitState> {
  StagesInUnitCubit() : super(StagesInUnitState());

  final _unitId = ChiefUnitService.instance.unitId;

  final _distributionStageTable = DistributionStageTable();

  final _operationTable = OperationTable();

  final _operatorOperationsTable = OperatorOperationsTable();

  final TextEditingController uploadStagesQuantityController =
      TextEditingController();

  Future fetchStages() async {
    List<DistributionStage> distributionStagesList = [];

    List<StagesInUnitModel> stagesList = [];

    Map<int, StagesInUnitModel> stagesMap = {};
    List<int> stagesIdList = [];

    var fetchedStagesList = await _distributionStageTable.select();
    DistributionStage prevDistributionStage =
        DistributionStage(id: 0, chiefBatchId: 0, stageId: 0, statusId: 0);

    for (var fetchedStage in fetchedStagesList) {
      var stageDto = DistributionStageDto.fromMap(fetchedStage);
      var stage = DistributionStage.fromDto(stageDto);

      distributionStagesList.add(stage);

      if ((!stagesMap.containsKey(stage.stageId)) && stage.unitId == _unitId) {
        final stageUnitModel = StagesInUnitModel(
            batchId: stage.chiefBatch?.batchId ?? 0,
            stageId: stage.stageId,
            stageNumber: stage.stage?.number ?? '',
            batchNumber: stage.chiefBatch?.batch.number ?? '',
            batchName: stage.chiefBatch?.batch.name ?? '',
            code: stage.chiefBatch?.batch.code ?? '',
            technologyNumber: stage.chiefBatch?.batch.technology ?? '',
            stageStatusName: stage.stageStatus?.name ?? '');

        stagesMap[stage.stageId] = stageUnitModel;

        stagesMap[stage.stageId]?.totalDetailsQuantity =
            stage.chiefBatch?.batch.count ?? 0;

        stagesIdList.add(stage.stageId);
      }

      switch (stage.statusId) {
        case 1:
          if (prevDistributionStage.chiefBatchId == stage.chiefBatchId) {
            stagesMap[stage.stageId]?.expectedDetailsQuantity++;
          }
          stagesMap[stage.stageId]?.inWorkDetailsQuantity++;
        case 2:
          if (prevDistributionStage.chiefBatchId == stage.chiefBatchId) {
            stagesMap[stage.stageId]?.expectedDetailsQuantity++;
          }
          stagesMap[stage.stageId]?.inWorkDetailsQuantity++;
        case 3:
          if (prevDistributionStage.chiefBatchId == stage.chiefBatchId) {
            stagesMap[stage.stageId]?.expectedDetailsQuantity++;
          }
          stagesMap[stage.stageId]?.stagesList.add(stage);
          stagesMap[stage.stageId]?.readyDetailsQuantity++;
        case 4:
          stagesMap[stage.stageId]?.uploadedDetailsQuantity++;
      }

      if (stage.unitId == _unitId) {
        stagesMap[stage.stageId]?.inUnitDetailsQuantity++;
      }

      prevDistributionStage = stage;
    }

    var batchesMap =
        groupBy(distributionStagesList, (stage) => stage.chiefBatchId);

    var fetchedOperationsList =
        await _operationTable.selectByStageIdList(stagesIdList);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperationDTO.fromMap(fetchedOperation);
      final operation = Operation(
          id: operationDto.id,
          number: operationDto.number,
          name: operationDto.name,
          code: operationDto.code,
          timepz: operationDto.timepz,
          stageId: operationDto.stageId);

      stagesMap[operation.stageId]?.operationsList.add(OperationInStageModel(
            name: operation.name,
            number: operation.number,
            operationId: operation.id,
            code: operation.code,
            stageId: operation.stageId,
          ));
      stagesMap[operation.stageId]?.operationsQuantity++;
    }

    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectOrderedByChiefBatchIdAndChiefOperationId();

    OperatorOperationsDTO prevOperation = OperatorOperationsDTO.empty;

    for (int i = 0; i < fetchedOperatorOperationsList.length; i++) {
      var operation = fetchedOperatorOperationsList[i];
      final operatorOperationsDto = OperatorOperationsDTO.fromMap(operation);
      print(operatorOperationsDto.id);
      final operationInList = stagesMap[operatorOperationsDto.stageId]
          ?.operationsList
          .firstWhere((element) =>
              element.operationId == operatorOperationsDto.operationId);

      operationInList?.areaNumber = operatorOperationsDto.area!.number;
      switch (operatorOperationsDto.statusId) {
        case 2:
          if (i == 0) {
            operationInList?.onDistribution++;
            stagesMap[operatorOperationsDto.stageId]
                ?.onDistributionOperationsQuantity++;
            print('1: ${operatorOperationsDto.id}');
          } else {
            if (operatorOperationsDto.chiefBatchId !=
                prevOperation.chiefBatchId) {
              operationInList?.onDistribution++;
              stagesMap[operatorOperationsDto.stageId]
                  ?.onDistributionOperationsQuantity++;

              print(
                  '2: ${operatorOperationsDto.chiefBatchId}    ${prevOperation.chiefBatchId}');
            } else {
              if ((operatorOperationsDto.modific == false ||
                      operatorOperationsDto.modific == null) &&
                  (prevOperation.statusId == 9)) {
                operationInList?.onDistribution++;
                stagesMap[operatorOperationsDto.stageId]
                    ?.onDistributionOperationsQuantity++;

                print('3: ${operatorOperationsDto.id}');
              }
            }
          }

        case 3:
          operationInList?.distributed++;
          stagesMap[operatorOperationsDto.stageId]
              ?.distributedOperationsQuantity++;
        case 4:
          operationInList?.modificationQuantity++;
          stagesMap[operatorOperationsDto.stageId]
              ?.modificationOperationsQuantity++;
        case 5:
          stagesMap[operatorOperationsDto.stageId]?.defectDetailsQuantity++;
          stagesMap[operatorOperationsDto.stageId]?.defectOperationsQuantity++;
          operationInList?.defectQuantity++;
        case 6:
          operationInList?.onCheckQuantity++;
          stagesMap[operatorOperationsDto.stageId]?.onCheckOperationQuantity++;
        case 7:
          stagesMap[operatorOperationsDto.stageId]
              ?.onMachinesOperationsQuantity++;
          operationInList?.onMachinesQuantity++;
        case 9:
          stagesMap[operatorOperationsDto.stageId]?.readyOperationsQuantity++;
          operationInList?.readyQuantity++;
      }
      prevOperation = operatorOperationsDto;
    }

    stagesMap.forEach((key, value) {
      int defectCount = 0;

      for (int i = 0; i < value.operationsList.length; i++) {
        defectCount = defectCount + value.operationsList[i].defectQuantity;

        value.operationsList[i].readyPercent =
            (value.operationsList[i].readyQuantity /
                    value.totalDetailsQuantity *
                    100)
                .round();
      }

      value.operationsQuantity =
          value.operationsQuantity * value.totalDetailsQuantity;

      value.readyOperationsPercent =
          ((value.readyOperationsQuantity / value.operationsQuantity) * 100)
              .round();

      value.semisQuantity =
          value.totalDetailsQuantity - value.defectDetailsQuantity;

      value.missingSemisQuantity =
          value.totalDetailsQuantity - value.semisQuantity;

      value.availableDetailsQuantity =
          value.totalDetailsQuantity - value.defectDetailsQuantity;

      value.readyDetailsPercent =
          ((value.readyDetailsQuantity + value.uploadedDetailsQuantity) /
                  value.availableDetailsQuantity *
                  100)
              .round();

      if (value.uploadedDetailsQuantity != value.totalDetailsQuantity) {
        stagesList.add(value);
      }
    });

    stagesList
        .sort((a, b) => a.readyDetailsPercent.compareTo(b.readyDetailsPercent));

    emit(state.copyWith(stagesList: stagesList.reversed.toList()));
  }

  Future uploadStages({
    required List<DistributionStage> stagesList,
  }) async {
    int quantity = 0;

    quantity = uploadStagesQuantityController.text != ''
        ? int.parse(uploadStagesQuantityController.text)
        : 0;

    List<int> stagesIdsList = [];
    for (int i = 0; i < quantity; i++) {
      stagesIdsList.add(stagesList[i].id);
    }

    await _distributionStageTable.bulkChangeStatusToDistributed(stagesIdsList);
    uploadStagesQuantityController.clear();
  }

// Future add() async {
//   List<int> operationsIdList = [
//     1984,
//     1985,
//     1986,
//     1987,
//     1988,
//     1989,
//     1990,
//     1991
//   ];
//   int batchId = 345;
//   int stageId = 632;
//   final chiefBatchTable = ChiefBatchTable();
//   final chiefOperationsTable = ChiefOperationTable();
//   for (int i = 0; i < 33; i++) {
//     print(i);
//     int chiefBatchId = await chiefBatchTable.insert(
//         ChiefBatchDTO(id: 0, batchId: batchId, batch: BatchDTO.empty));
//     for (int operationId in operationsIdList) {
//       await chiefOperationsTable.insert(ChiefOperationDto(
//           id: 0,
//           operationId: operationId,
//           stageId: stageId,
//           chiefBatchId: chiefBatchId));
//     }
//   }
// }
}
