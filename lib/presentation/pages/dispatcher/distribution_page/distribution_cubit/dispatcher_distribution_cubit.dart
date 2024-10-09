import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/domain/model/operation.dart';

import '../../../../../data/repositories/supabase/service/chief_operation_table.dart';
import '../../../../../data/repositories/supabase/service/operation_table.dart';
import '../../../../../data/repositories/supabase/service/unit_table.dart';
import '../../../../../domain/model/distribution_stage.dart';
import '../../../../../domain/model/unit.dart';
import '../distribution_stage_model.dart';

part 'dispatcher_distribution_state.dart';

class DispatcherDistributionCubit extends Cubit<DispatcherDistributionState> {
  DispatcherDistributionCubit() : super(const DispatcherDistributionState());

  final _distributionStageTable = DistributionStageTable();
  final _unitTable = UnitTable();
  final _operationTable = OperationTable();
  final _chiefOperationTable = ChiefOperationTable();
  final _chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
  List<DistributionStageModel> stagesForDistributionList = [];

  Future fetchStages() async {
    emit(state.copyWith(status: DispatcherDistributionStatus.loading));
    var fetchedList = await _distributionStageTable.selectNotDistributed();
    List<DistributionStageModel> distributionStagesList = [];
    List<DistributionStage> stagesList = [];
    for (var fetchedStage in fetchedList) {
      final stageDto = DistributionStageDto.fromMap(fetchedStage);

      final stage = DistributionStage.fromDto(stageDto);
      stagesList.add(stage);
    }

    var batchesMap = groupBy(stagesList, (stage) => stage.chiefBatch?.batchId);

    batchesMap.forEach((batchesKey, batchesValue) {
      var stagesMap = groupBy(batchesValue, (stage) => stage.stageId);

      stagesMap.forEach((stagesKey, stagesValue) {
        final distributionStage = DistributionStageModel(
            batch: stagesValue.first.chiefBatch?.batch ?? BatchDTO.empty,
            stageId: stagesValue.first.stageId,
            quantity: stagesValue.first.chiefBatch?.batch.count ?? 0,
            stageName: stagesValue.first.stage?.name ?? '',
            stageNumber: stagesValue.first.stage?.number ?? '',
            batchId: stagesValue.first.chiefBatch?.batchId ?? 0);

        stagesList = [];
        for (var stage in stagesValue) {
          stagesList.add(stage);
        }

        distributionStage.stagesList = stagesList;
        stagesList = [];

        distributionStagesList.add(distributionStage);
      });
    });

    emit(state.copyWith(
        distributionStagesList: distributionStagesList,
        status: DispatcherDistributionStatus.success));
  }

  Future fetchUnits() async {
    List<Unit> unitsList = [];
    var fetchedList = await _unitTable.select();
    for (var fetchedUnit in fetchedList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);
      final unit = Unit(
          id: unitDto.id,
          companyId: unitDto.companyId,
          name: unitDto.name,
          number: unitDto.number);
      unitsList.add(unit);
    }

    emit(state.copyWith(unitsList: unitsList));
  }

  Future distributeStagesNew(
      {required int quantity,
      required DistributionStageModel distributionStageModel,
      required int selectedUnitId}) async {
    emit(state.copyWith(status: DispatcherDistributionStatus.loading));

    List<Operation> operationsList = [];

    List<ChiefDistributionOperationsDTO> chiefDistributionOperationsDTOsList =
        [];

    final fetchedChiefDistributionOperationList =
        await _chiefDistributionOperationsTable.selectByBatchAndStageId(
            batchId: distributionStageModel.batchId,
            stageId: distributionStageModel.stageId);

    var fetchedOperationsList = await _operationTable.selectByStageId(
        stageId: distributionStageModel.stageId);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperationDTO.fromMap(fetchedOperation);
      final operation = Operation(
          id: operationDto.id,
          number: operationDto.number,
          name: operationDto.name,
          code: operationDto.code,
          timepz: operationDto.timepz,
          stageId: operationDto.stageId);
      operationsList.add(operation);
    }

    List<ChiefOperationDto> distributionOperationList = [];

    List<int> stagesIdForChangeStatusList = [];

    for (var operation in operationsList) {
      final chiefDistributionOperationDTO = ChiefDistributionOperationsDTO(
          unitId: selectedUnitId,
          id: 0,
          operationId: operation.id,
          stageId: distributionStageModel.stageId,
          stage: StageDTO.empty,
          operation: OperationDTO.empty,
          batchId: distributionStageModel.batchId,
          batch: BatchDTO.empty,
          quantity: quantity);

      chiefDistributionOperationsDTOsList.add(chiefDistributionOperationDTO);

      for (int i = 0; i < quantity; i++) {
        distributionOperationList.add(ChiefOperationDto(
            id: 0,
            operationId: operation.id,
            stageId: operation.stageId,
            distributionStageId: distributionStageModel.stagesList?[i].id,
            chiefBatchId:
                distributionStageModel.stagesList?[i].chiefBatchId ?? 0));
        if (!stagesIdForChangeStatusList
            .contains(distributionStageModel.stagesList?[i].id)) {
          stagesIdForChangeStatusList
              .add(distributionStageModel.stagesList?[i].id ?? 0);
          await _distributionStageTable.updateUnit(
              distributionStageModel.stagesList?[i].id ?? 0, selectedUnitId);
        }
      }
    }

    if (fetchedChiefDistributionOperationList.isNotEmpty) {
      for (var operation in fetchedChiefDistributionOperationList) {
        final chiefDistributionOperationDTO =
            ChiefDistributionOperationsDTO.fromMap(operation);

        await _chiefDistributionOperationsTable.updateQuantity(
            chiefOperationId: chiefDistributionOperationDTO.id,
            newQuantity: chiefDistributionOperationDTO.quantity + quantity);
      }
    } else {
      await _chiefDistributionOperationsTable
          .bulkInsert(chiefDistributionOperationsDTOsList);
    }

    await _chiefOperationTable.bulkInsert(dtosList: distributionOperationList);

    await _distributionStageTable.bulkUpdateStatusToExecuteAndUnit(
        stagesIdForChangeStatusList, selectedUnitId);

    await fetchStages();

    emit(state.copyWith(status: DispatcherDistributionStatus.success));
  }
}
