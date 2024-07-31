import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:meta/meta.dart';

import '../../../../../data/repositories/supabase/dto/distribution_stage_dto.dart';
import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/dto/operator_operations_dto.dart';
import '../../../../../domain/model/distribution_stage.dart';
import '../../../../../domain/model/operation.dart';
import '../../../../../domain/model/unit.dart';
import '../../../chief/stages_in_unit_page/stages_in_unit_model.dart';

part 'queue_stages_state.dart';

class QueueStagesCubit extends Cubit<QueueStagesState> {
  QueueStagesCubit()
      : super(QueueStagesState(status: QueueStagesPageStatus.initial));

  final _distributionStageTable = DistributionStageTable();
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

    List<StageInUnitModel> stagesList = [];

    Map<int, StageInUnitModel> stagesMap = {};
    List<int> stagesIdList = [];

    var fetchedStagesList = await _distributionStageTable.select();

    DistributionStage prevDistributionStage =
        DistributionStage(id: 0, chiefBatchId: 0, stageId: 0, statusId: 0);

    for (var fetchedStage in fetchedStagesList) {
      print(fetchedStage);
      var stageDto = DistributionStageDto.fromMap(fetchedStage);
      var stage = DistributionStage.fromDto(stageDto);

      distributionStagesList.add(stage);

      if ((!stagesMap.containsKey(stage.stageId)) &&
          stage.unitId == selectedUnit.id) {
        final stageUnitModel = StageInUnitModel(
            batchId: stage.chiefBatch?.batchId ?? 0,
            stageId: stage.stageId,
            stageNumber: stage.stage?.number ?? '',
            batchNumber: stage.chiefBatch?.batch.numberRS ?? '',
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

      if (stage.unitId == selectedUnit.id) {
        stagesMap[stage.stageId]?.inUnitDetailsQuantity++;
      }

      prevDistributionStage = stage;
    }


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
        .selectByUnitOrderedByChiefOperation(selectedUnit.id);

    OperatorOperationsDTO prevOperation = OperatorOperationsDTO.empty;

    for (int i = 0; i < fetchedOperatorOperationsList.length; i++) {
      var operation = fetchedOperatorOperationsList[i];

      final operatorOperationsDto = OperatorOperationsDTO.fromMap(operation);

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

      for (int i = 0; i < value.stagesList.length; i++) {}

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

      stagesList.add(value);
    });

    stagesList
        .sort((a, b) => a.readyDetailsPercent.compareTo(b.readyDetailsPercent));

    emit(state.copyWith(
        status: QueueStagesPageStatus.success,
        stagesList: stagesList.reversed.toList()));
  }

  Future initQueueStagesPage() async {
    await fetchUnits();
    fetchStages();
  }
}
