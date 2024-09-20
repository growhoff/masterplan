import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
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
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/distribution_operation_model.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/operation_for_distribution_model.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../data/repositories/supabase/dto/batch_dto.dart';
import '../../../../../data/repositories/supabase/dto/operation_dto.dart';
import '../../../../../data/repositories/supabase/dto/stage_dto.dart';
import '../../../../../data/repositories/supabase/dto/status_dto.dart';
import '../../../../../domain/model/area.dart';
import '../../../../../domain/model/unit.dart';
import '../../../../../domain/repositories/area_repository.dart';
import '../chief_distribution_stage_model.dart';

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

  Future initChiefDistributionPage() async {
    List<ChiefDistributionStageModel> stagesList = [];

    final unitsList = await _unitRepository.getUnitList([_unitId ?? 0]);
    selectedUnit = unitsList.first;

    final distributionStagesList = await _distributionStageRepository
        .fetchChiefDistributionStagesByUnitIdOrderedByPriority(
            selectedUnit?.id ?? 0);

    var batchesMap =
        groupBy(distributionStagesList, (stage) => stage.chiefBatch?.batchId);

    batchesMap.forEach((batchKey, batchValue) {
      var stagesMap = groupBy(batchValue, (stage) => stage.stageId);

      stagesMap.forEach((stageKey, stageValue) {
        final chiefDistributionStageModel = ChiefDistributionStageModel(
            stageNumber:
                '${stageValue.first.chiefBatch?.batch.order?.number}.${stageValue.first.chiefBatch?.batch.number}.${stageValue.first.stage?.number}',
            planName: stageValue.first.chiefBatch?.batch.name ?? '',
            planNumber: stageValue.first.chiefBatch?.batch.numberRS ?? '',
            batchId: stageValue.first.chiefBatch?.batchId ?? 0,
            stageId: stageValue.first.stageId,
            unitId: stageValue.first.unitId ?? 0,
            stageName: stageValue.first.stage?.name ?? '',
            priority: stageValue.first.chiefBatch?.batch.order?.priority ?? 4);

        chiefDistributionStageModel.receivedQuantity = stageValue.length;

        chiefDistributionStageModel.waitingQuantity =
            (stageValue.first.chiefBatch!.batch.count -
                chiefDistributionStageModel.receivedQuantity);

        stagesList.add(chiefDistributionStageModel);
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
        await _chiefDistributionOperationsRepository
            .fetchChiefDistributionOperationsByBatchAndStageId(
                batchId: batchId, stageId: stageId);

    for (var operation in chiefDistributionOperationsList) {
      final distributionOperationModel = DistributionOperationModel(
          chiefDistributionOperation: operation,
          operationName: operation.operation.name,
          operationNumber: operation.operation.number,
          timeSH: operation.operation.timeSH,
          timePZ: operation.operation.timepz,
          timeSHC: '0');

      final operationForDistributionModel = OperationForDistributionModel();
      operationForDistributionModel.quantity = operation.quantity;

      operationsForDistributionsList.add(operationForDistributionModel);
      distributionOperationModel.availableQuantity = operation.quantity;
      distributionOperationModel.totalQuantity = operation.batch.count;

      operationsList.add(distributionOperationModel);
    }

    emit(OperationsOfStagePageSuccess(
        operationsList: operationsList, areasList: areasList));
  }

  Future distributeOperation(
      {required int quantity,
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

  Future distributeAll() async {
    int operationsWithSelectedAreaQuantity = operationsForDistributionsList
        .indexWhere((operation) => operation.area.id != 0);

    if (operationsWithSelectedAreaQuantity ==
        operationsForDistributionsList.length) {

      for (var operation in operationsForDistributionsList){

        

      }

    }
  }
}
