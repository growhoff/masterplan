import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/domain/repositories/chief_distribution_operations_repository.dart';
import 'package:master_plan/domain/repositories/chief_operation_repository.dart';
import 'package:master_plan/domain/repositories/distribution_stage_repository.dart';
import 'package:master_plan/domain/repositories/unit_repository.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/models/distribution_operation_model.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/models/operation_for_distribution_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/distribution_page/distribution_stage_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../data/repositories/supabase/dto/batch_dto.dart';
import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/dto/stage_dto.dart';
import '../../../../../data/repositories/supabase/dto/status_dto.dart';
import '../../../../../domain/model/area.dart';
import '../../../../../domain/model/chief_operation.dart';
import '../../../../../domain/model/unit.dart';
import '../../../../../domain/repositories/area_repository.dart';
import '../models/chief_distribution_stage_model.dart';

part 'chief_distribution_state.dart';

class ChiefDistributionCubit extends Cubit<ChiefDistributionState> {
  ChiefDistributionCubit() : super(ChiefDistributionInitial());

  final _unitRepository = UnitRepository();
  final _areaRepository = AreaRepository();
  final _chiefOperationRepository = ChiefOperationRepository();
  final _chiefOperationTable = ChiefOperationTable();
  final _unitId = ChiefUnitService.instance.unitId;
  final _distributionStageRepository = DistributionStageRepository();
  final _chiefDistributionOperationsRepository =
  ChiefDistributionOperationsRepository();

  Unit? selectedUnit = Unit.empty;

  List<OperationForDistributionModel> operationsForDistributionsList = [];

  Future initChiefDistributionPageNew() async {
    emit(ChiefDistributionLoading());

    final unitsList = await _unitRepository.getUnitList([_unitId ?? 0]);
    selectedUnit = unitsList.first;

    List<ChiefDistributionStageModel> stagesList = [];

    operationsForDistributionsList = [];

    final distributionStagesListOnUnit = await _distributionStageRepository
        .fetchChiefDistributionStagesByUnitIdOrderedByPriority(
        selectedUnit?.id ?? 0);

    List<int> batchesIdsList = [];
    List<int> stagesIdsList = [];

    for (final distributionStage in distributionStagesListOnUnit) {
      batchesIdsList.add(distributionStage.chiefBatch?.batchId ?? 0);
    }

    List<ChiefDistributionOperation> operationsList = [];

    var chiefDistributionOperationsList =
    await _chiefDistributionOperationsRepository.fetchByBatchesIdsList(
        batchesIdsList);

    ChiefDistributionOperation prevOperation = ChiefDistributionOperation(
        id: 0,
        operationId: 0,
        stageId: 0,
        stage: StageDTO.empty,
        operation: OperationDTO.empty,
        batchId: 0,
        batch: BatchDTO.empty,
        quantity: 0);

    bool isAnotherStage = false;
    int? prevStageUploadedQuantity;
    for (var operation in chiefDistributionOperationsList) {
      print(
          '${operation.id} : ${operation.operation.number} ${operation.operation
              .name}');

      if (operation.stageId != prevOperation.stageId && prevOperation.id != 0) {
        isAnotherStage = true;
        prevStageUploadedQuantity = await _distributionStageRepository
            .fetchQuantityOfUploadedDistributionStagesByBatchAndStageId(
            batchId: prevOperation.batchId, stageId: prevOperation.stageId);
      }

      final distributionOperationModel = DistributionOperationModel(
          chiefDistributionOperation: operation,
          operationName: operation.operation.name,
          operationNumber: operation.operation.number,
          timeSH: operation.operation.timeSH,
          timePZ: operation.operation.timepz,
          timeSHC:
          '${operation.operation.timeSH +
              operation.operation.timepz / operation.batch.count}');

      final operationForDistributionModel = OperationForDistributionModel(
          chiefDistributionOperation: operation,
          oldQuantity: operation.quantity);
      operationForDistributionModel.quantity = operation.quantity;

      if (isAnotherStage) {
        if (prevStageUploadedQuantity != null) {
          distributionOperationModel.availableQuantity =
              operation.quantity - prevStageUploadedQuantity;
        }
      } else {
        distributionOperationModel.availableQuantity = operation.quantity;
      }
      distributionOperationModel.totalQuantity = operation.batch.count;

      if (distributionOperationModel.availableQuantity != 0 &&
          operation.quantity != 0) {
        operationsList.add(operation);
        stagesIdsList.add(operation.stageId);
      }

      prevOperation = operation;
    }

    final distributionStagesList = await _distributionStageRepository
        .fetchDistributionStagesByBatchesAndStagesIdsList(
        batchesIdsList: batchesIdsList, stagesIdsList: stagesIdsList
    );

    final batchesMap =
    groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);


    final operationsMap =
    groupBy(operationsList, (operation) => operation.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      final stagesMap = groupBy(batchValue, (stage) => stage.stageId);

      stagesMap.forEach((stageKey, stageValue) {
        print('stage key : ${stageKey}');
        if ((operationsMap[stageValue.first.chiefBatch?.batchId] != null &&
            operationsMap[stageValue.first.chiefBatch?.batchId]!.any(
                    (operation) =>
                operation.stageId == stageValue.first.stageId))) {
          final chiefDistributionStageModel = ChiefDistributionStageModel(
              stageNumber:
              '${stageValue.first.chiefBatch?.batch.order?.number}.${stageValue
                  .first.chiefBatch?.batch.number}.${stageValue.first.stage
                  ?.number}',
              planName: stageValue.first.chiefBatch?.batch.name ?? '',
              planNumber: stageValue.first.chiefBatch?.batch.numberRS ?? '',
              technologyNumber:
              stageValue.first.chiefBatch?.batch.technology ?? '',
              batchId: stageValue.first.chiefBatch?.batchId ?? 0,
              stageId: stageValue.first.stageId,
              unitId: stageValue.first.unitId ?? 0,
              stageName: stageValue.first.stage?.name ?? '',
              priority:
              stageValue.first.chiefBatch?.batch.order?.priority ?? 4);

          chiefDistributionStageModel.receivedQuantity = stageValue.length;

          chiefDistributionStageModel.waitingQuantity =
          (stageValue.first.chiefBatch!.batch.count -
              chiefDistributionStageModel.receivedQuantity);

          stagesList.add(chiefDistributionStageModel);
        }
      });
    });

    stagesList.sort((a, b) => a.priority.compareTo(b.priority));

    emit(
        ChiefDistributionSuccess(unitsList: unitsList, stagesList: stagesList));
  }

  Future initChiefDistributionPage() async {
    emit(ChiefDistributionLoading());
    List<ChiefDistributionStageModel> stagesList = [];

    List<int> chiefBatchesIdsList = [];

    final unitsList = await _unitRepository.getUnitList([_unitId ?? 0]);
    selectedUnit = unitsList.first;

    final distributionStagesList = await _distributionStageRepository
        .fetchChiefDistributionStagesByUnitIdOrderedByPriority(
        selectedUnit?.id ?? 0);

    var batchesMap =
    groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);

    List<int> batchesIdsList = [];
    List<int> stagesIdsList = [];

    for (var stage in distributionStagesList) {
      batchesIdsList.add(stage.chiefBatch?.batchId ?? 0);
      stagesIdsList.add(stage.stageId);
    }

    final fetchedChiefOperationsList =
    await _chiefDistributionOperationsRepository
        .fetchByBathesAndStagesIdsLists(batchesIdsList: batchesIdsList);

    var operationsMap =
    groupBy(fetchedChiefOperationsList, (operation) => operation.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      var stagesMap = groupBy(batchValue, (stage) => stage.stageId);

      stagesMap.forEach((stageKey, stageValue) {
        print('stage key : ${stageKey}');
        if ((operationsMap[stageValue.first.chiefBatch?.batchId] != null &&
            operationsMap[stageValue.first.chiefBatch?.batchId]!.any(
                    (operation) =>
                operation.stageId == stageValue.first.stageId))) {
          final chiefDistributionStageModel = ChiefDistributionStageModel(
              stageNumber:
              '${stageValue.first.chiefBatch?.batch.order?.number}.${stageValue
                  .first.chiefBatch?.batch.number}.${stageValue.first.stage
                  ?.number}',
              planName: stageValue.first.chiefBatch?.batch.name ?? '',
              planNumber: stageValue.first.chiefBatch?.batch.numberRS ?? '',
              technologyNumber:
              stageValue.first.chiefBatch?.batch.technology ?? '',
              batchId: stageValue.first.chiefBatch?.batchId ?? 0,
              stageId: stageValue.first.stageId,
              unitId: stageValue.first.unitId ?? 0,
              stageName: stageValue.first.stage?.name ?? '',
              priority:
              stageValue.first.chiefBatch?.batch.order?.priority ?? 4);

          chiefDistributionStageModel.receivedQuantity = stageValue.length;

          chiefDistributionStageModel.waitingQuantity =
          (stageValue.first.chiefBatch!.batch.count -
              chiefDistributionStageModel.receivedQuantity);

          stagesList.add(chiefDistributionStageModel);
        }
      });
    });

    stagesList.sort((a, b) => a.priority.compareTo(b.priority));

    emit(
        ChiefDistributionSuccess(unitsList: unitsList, stagesList: stagesList));
  }

  Future initOperationsOfStagePage(
      {required int batchId, required int stageId, required int unitId}) async {
    emit(ChiefDistributionLoading());

    operationsForDistributionsList = [];

    final areasList =
    await _areaRepository.getAreasListByUnitId(unitId: unitId);

    List<DistributionOperationModel> operationsList = [];

    var chiefDistributionOperationsList =
    await _chiefDistributionOperationsRepository.fetchByBatchId(batchId);

    ChiefDistributionOperation prevOperation = ChiefDistributionOperation(
        id: 0,
        operationId: 0,
        stageId: 0,
        stage: StageDTO.empty,
        operation: OperationDTO.empty,
        batchId: 0,
        batch: BatchDTO.empty,
        quantity: 0);

    bool isAnotherStage = false;
    int? prevStageUploadedQuantity;
    for (var operation in chiefDistributionOperationsList) {
      print(
          '${operation.id} : ${operation.operation.number} ${operation.operation
              .name}');

      if (operation.stageId != prevOperation.stageId && prevOperation.id != 0) {
        isAnotherStage = true;
        prevStageUploadedQuantity = await _distributionStageRepository
            .fetchQuantityOfUploadedDistributionStagesByBatchAndStageId(
            batchId: prevOperation.batchId, stageId: prevOperation.stageId);
      }

      final distributionOperationModel = DistributionOperationModel(
          chiefDistributionOperation: operation,
          operationName: operation.operation.name,
          operationNumber: operation.operation.number,
          timeSH: operation.operation.timeSH,
          timePZ: operation.operation.timepz,
          timeSHC:
          '${operation.operation.timeSH +
              operation.operation.timepz / operation.batch.count}');

      final operationForDistributionModel = OperationForDistributionModel(
          chiefDistributionOperation: operation,
          oldQuantity: operation.quantity);
      operationForDistributionModel.quantity = operation.quantity;

      if (isAnotherStage) {
        if (prevStageUploadedQuantity != null) {
          distributionOperationModel.availableQuantity =
              operation.quantity - prevStageUploadedQuantity;
        }
      } else {
        distributionOperationModel.availableQuantity = operation.quantity;
      }
      distributionOperationModel.totalQuantity = operation.batch.count;

      if (distributionOperationModel.availableQuantity != 0 &&
          operation.quantity != 0 &&
          operation.stageId == stageId) {
        operationsList.add(distributionOperationModel);
        operationsForDistributionsList.add(operationForDistributionModel);
      }

      prevOperation = operation;
    }

    emit(OperationsOfStagePageSuccess(
        operationsList: operationsList, areasList: areasList));
  }

  Future distributeOperation({required int quantity,
    required Area area,
    required ChiefDistributionOperation chiefDistributionOperation}) async {
    final chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
    final operatorOperationsTable = OperatorOperationsTable();

    List<int> chiefOperationsIdsList = [];
    List<OperatorOperationsDTO> operatorOperationsDtosList = [];

    final chiefOperationList =
    await _chiefOperationRepository.fetchOperationsByOperationIdWithLimit(
        quantity: quantity,
        operationId: chiefDistributionOperation.operationId);

    int orderNumber = 1;
    for (var chiefOperation in chiefOperationList) {
      chiefOperationsIdsList.add(chiefOperation.id);
      operatorOperationsDtosList.add(OperatorOperationsDTO(
          id: 0,
          timeplan: chiefDistributionOperation.operation.timeSH,
          timeFirstStart: 0,
          statusId: 2,
          status: StatusDTO(id: 0, name: ''),
          batchId: chiefDistributionOperation.batchId,
          order: orderNumber,
          batch: BatchDTO.empty,
          distributionStageId: chiefOperation.distributionStageId,
          stageId: chiefDistributionOperation.operation.stageId,
          stage: StageDTO.empty,
          operationId: chiefDistributionOperation.operation.id,
          operation: OperationDTO.empty,
          areaId: area.id,
          chiefOperationId: chiefOperation.id,
          chiefBatchId: chiefOperation.chiefBatchId,
          area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
      orderNumber++;
    }

    await chiefDistributionOperationsTable.updateQuantity(
        chiefOperationId: chiefDistributionOperation.id,
        newQuantity: chiefDistributionOperation.quantity - quantity);

    await operatorOperationsTable.bulkInsert(
        operationsList: operatorOperationsDtosList);

    await initOperationsOfStagePage(
        batchId: chiefDistributionOperation.batchId,
        stageId: chiefDistributionOperation.stageId,
        unitId: area.unitId);

    _chiefOperationTable.changeIsDistributed(
        operationsIdList: chiefOperationsIdsList);
  }

  Future distributeAll({required int unitId}) async {
    emit(ChiefDistributionLoading());
    print('start distribute all');
    final chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
    final operatorOperationsTable = OperatorOperationsTable();

    int operationsWithSelectedAreaQuantity = 0;

    for (var operation in operationsForDistributionsList) {
      if (operation.area.id != 0) {
        operationsWithSelectedAreaQuantity++;
      }
    }

    print(
        'operationsWithSelectedAreaQuantity : $operationsWithSelectedAreaQuantity');

    List<ChiefOperation> allChiefOperationsList = [];
    List<int> chiefOperationsIdsList = [];
    List<OperatorOperationsDTO> operatorOperationsDtosList = [];

    if (operationsWithSelectedAreaQuantity ==
        operationsForDistributionsList.length) {
      for (var operation in operationsForDistributionsList) {
        print(
            'chiefDistributionOperationId: ${operation
                .chiefDistributionOperation.id}');
        print('quantity : ${operation.quantity}');
        final chiefOperationList = await _chiefOperationRepository
            .fetchOperationsByOperationIdWithLimit(
            quantity: operation.quantity,
            operationId: operation.chiefDistributionOperation.operationId);
        //allChiefOperationsList.addAll(chiefOperationList);
        int orderNumber = 1;
        for (var chiefOperation in chiefOperationList) {
          print('allChiefOperationsList id: ${chiefOperation.id}');
          chiefOperationsIdsList.add(chiefOperation.id);
          operatorOperationsDtosList.add(OperatorOperationsDTO(
              id: 0,
              timeplan: chiefOperation.operation.timeSH,
              timeFirstStart: 0,
              statusId: 2,
              status: StatusDTO(id: 0, name: ''),
              batchId: chiefOperation.chiefBatch.batchId,
              order: orderNumber,
              batch: BatchDTO.empty,
              distributionStageId: chiefOperation.distributionStageId,
              stageId: chiefOperation.stageId,
              stage: StageDTO.empty,
              operationId: chiefOperation.operationId,
              operation: OperationDTO.empty,
              areaId: (operationsForDistributionsList.firstWhere((operation) =>
              operation.chiefDistributionOperation.operationId ==
                  chiefOperation.operationId)).area.id,
              chiefOperationId: chiefOperation.id,
              chiefBatchId: chiefOperation.chiefBatchId,
              area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
          orderNumber++;
        }

        for (var operation in operationsForDistributionsList) {
          await chiefDistributionOperationsTable.updateQuantity(
              chiefOperationId: operation.chiefDistributionOperation.id,
              newQuantity: operation.oldQuantity - operation.quantity);
        }
      }

      await operatorOperationsTable.bulkInsert(
          operationsList: operatorOperationsDtosList);

      await initOperationsOfStagePage(
          batchId: operationsForDistributionsList
              .first.chiefDistributionOperation.batchId,
          stageId: operationsForDistributionsList
              .first.chiefDistributionOperation.stageId,
          unitId: unitId);

      _chiefOperationTable.changeIsDistributed(
          operationsIdList: chiefOperationsIdsList);
    }

    operationsForDistributionsList = [];
    print('end');
  }

  changeDistributionOperationQuantity(
      {required int indexInList, required newQuantity}) {
    operationsForDistributionsList[indexInList].quantity = newQuantity;
  }
}
