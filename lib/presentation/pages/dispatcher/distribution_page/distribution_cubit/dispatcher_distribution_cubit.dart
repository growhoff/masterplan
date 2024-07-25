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
import 'package:meta/meta.dart';

import '../../../../../data/repositories/supabase/dto/position_staff_dto.dart';
import '../../../../../data/repositories/supabase/service/chief_operation_table.dart';
import '../../../../../data/repositories/supabase/service/operation_table.dart';
import '../../../../../data/repositories/supabase/service/position_staff_table.dart';
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
    print(fetchedList);
    List<DistributionStage> stagesList = [];
    for (var fetchedStage in fetchedList) {
      final stageDto = DistributionStageDto.fromMap(fetchedStage);

      final stage = DistributionStage.fromDto(stageDto);
      stagesList.add(stage);
    }

    var stagesMap = groupBy(stagesList, (stage) => stage.stageId);

    List<DistributionStageModel> distributionStagesList = [];
    stagesMap.forEach((key, value) {
      print('value batch id: ${value.first.chiefBatch?.batchId}');
      final distributionStage = DistributionStageModel(
          stageArchiveId: value.first.stageId,
          quantity: value.first.chiefBatch?.batch.count ?? 0,
          batchName: value.first.chiefBatch?.batch.name ?? '',
          batchNumber: value.first.chiefBatch?.batch.number ?? '',
          stageName: value.first.stage?.name ?? '',
          stageNumber: value.first.stage?.number ?? '',
          batchId: value.first.chiefBatch?.batchId ?? 0);

      List<DistributionStage> stagesList = [];
      for (var stage in value) {
        stagesList.add(stage);
      }
      distributionStage.stagesList = stagesList;

      distributionStagesList.add(distributionStage);
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

  Future distributeStages() async {
    List<int> stagesIdList = [];
    List<int> unitsIdForStageList = [];
    for (var stage in stagesForDistributionList) {
      stagesIdList.add(stage.stageArchiveId);
      unitsIdForStageList.add(stage.unitId ?? 0);
    }
    var fetchedOperationsList =
        await _operationTable.selectByStageIdList(stagesIdList);

    List<Operation> operationsList = [];

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

    var operationsMap =
        groupBy(operationsList, (operation) => operation.stageId);

    List<ChiefOperationDto> distributionOperationList = [];
    List<int> unitsIdForStagesList = [];

    List<int> stagesIdForChangeStatusList = [];

    for (var stage in stagesForDistributionList) {
      final operationList = operationsMap[stage.stageArchiveId];

      for (var operation in operationList!) {
        await _chiefDistributionOperationsTable.insert(
            ChiefDistributionOperationsDTO(
                unitId: stage.unitId,
                id: 0,
                operationId: operation.id,
                stageId: operation.stageId,
                stage: StageDTO.empty,
                operation: OperationDTO.empty,
                batchId: stage.batchId,
                batch: BatchDTO.empty,
                quantity: stage.quantity));

        for (int i = 0; i < stage.quantity; i++) {
          distributionOperationList.add(ChiefOperationDto(
              id: 0,
              operationId: operation.id,
              stageId: operation.stageId,
              distributionStageId: stage.stagesList?[i].id,
              chiefBatchId: stage.stagesList?[i].chiefBatchId ?? 0));
          if (!stagesIdForChangeStatusList.contains(stage.stagesList?[i].id)) {
            stagesIdForChangeStatusList.add(stage.stagesList?[i].id ?? 0);
            _distributionStageTable.updateUnit(
                stage.stagesList?[i].id ?? 0, stage.unitId ?? 0);
            unitsIdForStagesList.add(stage.unitId ?? 0);
          }
        }
      }
    }

    await _chiefOperationTable.bulkInsert(dtosList: distributionOperationList);
    await _distributionStageTable
        .bulkChangeStatusToInWork(stagesIdForChangeStatusList);

    stagesForDistributionList = [];
  }


}
