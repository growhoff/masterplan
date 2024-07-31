import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';

import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/presentation/pages/chief/model/distribution_operation_model.dart';

import '../../../../../domain/model/chief_distribution_operations_model.dart';

part 'chief_distribution_state.dart';

class ChiefDistributionCubit extends Cubit<ChiefDistributionState> {
  ChiefDistributionCubit() : super(const ChiefDistributionState()) {
    _chiefDistributionOperationsTable.table
        .stream(primaryKey: ['id'])
        .neq('quantity', 0)
        .listen((event) {
          fetchChiefOperations();
        });
  }

  final int? unitId = ChiefUnitService.instance.unitId;

  final OperatorOperationsTable _operatorOperationsTable =
      OperatorOperationsTable();

  final AreaTable _areaTable = AreaTable();
  final ChiefOperationTable _chiefOperationTable = ChiefOperationTable();
  final operationsTable = OperationTable();
  final distributionStageTable = DistributionStageTable();

  final listController = ScrollController();

  final ChiefDistributionOperationsTable _chiefDistributionOperationsTable =
      ChiefDistributionOperationsTable();

  List<bool> isElementOpenList = [];

  List<String> areasNamesList = [];

  List<DistributionOperationModel> operationsForDistributionList = [];

  int chiefOperationsSelectMinRange = 0;
  final int distributionPageElementsLimit = 9;
  int chiefOperationsSelectMaxRange = 9;

  Map<String, dynamic> areasMap =
      {}; // ключ - номер участка + его имя, значение - id

  final _excelStageLoadService = ExcelService();

  Future<void> fetchChiefOperations() async {
    emit(state.copyWith(
        chiefOperationsList: [], status: DistributionPageStatus.loading));
    isElementOpenList = [];
    List<int> batchesIdsList = [];
    List<ChiefDistributionOperation> chiefOperationsList = [];
    var fetchedChiefOperationsList =
        await _chiefDistributionOperationsTable.selectNotDistributed(
            unitId: unitId ?? 1,
            maxRange: chiefOperationsSelectMaxRange,
            minRange: chiefOperationsSelectMinRange);

    for (var operation in fetchedChiefOperationsList) {
      final chiefOperationDto =
          ChiefDistributionOperationsDTO.fromMap(operation);
      final chiefDistributionOperation = ChiefDistributionOperation(
          operationId: chiefOperationDto.operationId,
          stageId: chiefOperationDto.stageId,
          stage: chiefOperationDto.stage,
          operation: chiefOperationDto.operation,
          batchId: chiefOperationDto.batchId,
          batch: chiefOperationDto.batch,
          quantity: chiefOperationDto.quantity,
          id: chiefOperationDto.id);
      batchesIdsList.add(chiefDistributionOperation.stage.batchArchiveId ?? 1);
      chiefOperationsList.add(chiefDistributionOperation);
    }

    var fetchedOperationList =
        await operationsTable.selectByBatchesIdsList(batchesIdsList);

    List<StageDTO> stagesDtoList = [];
    List<int> stagesIdsList = [];
    for (var operation in fetchedOperationList) {
      final operationDto = OperationDTO.fromMap(operation);

      if (!stagesIdsList.contains(operationDto.stageId)) {
        stagesDtoList.add(operationDto.stage ??
            StageDTO(id: 0, number: '', name: '', isdistributed: false));
        stagesIdsList.add(operationDto.stageId);
      }
    }

    var stagesMap = groupBy(stagesDtoList, (stage) => stage.batchArchiveId);

    List<ChiefDistributionOperation> finalList = [];

    for (var operation in chiefOperationsList) {
      print(operation.id);
      if (stagesMap[operation.stage.batchArchiveId]?.length == 1) {
        finalList.add(operation);
      } else {
        final index = stagesMap[operation.stage.batchArchiveId]
            ?.indexWhere((value) => value.id == operation.stageId);

        if (index == 0) {
          finalList.add(operation);
        } else {
          var fetchedStagesList =
              await distributionStageTable.selectUploadedByStageId(
                  stagesMap[operation.stage.batchArchiveId]![index! - 1].id);

          if (fetchedStagesList.isNotEmpty) {
            operation.quantity = fetchedStagesList.length;
            finalList.add(operation);
          }
        }
      }
    }

    emit(state.copyWith(
        chiefOperationsList: finalList,
        status: DistributionPageStatus.success));
  }

  Future<void> fetchAreas() async {
    areasNamesList = [];
    var fetchedAreasList = await _areaTable.select();

    for (var area in fetchedAreasList) {
      AreaDTO areaDto = AreaDTO.fromMap(area);
      String key = '${areaDto.number} ${areaDto.name}';
      areasNamesList.add(key);
      areasMap[key] = areaDto.id;
    }
  }

  Future<void> loadStageFromExcel() async {
    emit(state.copyWith(status: DistributionPageStatus.loading));
    try {
      await _excelStageLoadService.stageExcelFunction();
    } catch (e) {}

    fetchChiefOperations();
  }

  Future<void> sendOperationsToDistribution() async {
    emit(state.copyWith(status: DistributionPageStatus.loading));

    List<OperatorOperationsDTO> operatorOperationsDtoList = [];
    List<int> chiefOperationsIdList = [];
    for (var operation in operationsForDistributionList) {
      final quantity = operation.quantity;

      var fetchedChiefOperationsList =
          await _chiefOperationTable.fetchOperationsByOperationIdWithLimit(
              limit: quantity, operationId: operation.operationId);

      int orderNumber = 1;
      for (var chiefOperation in fetchedChiefOperationsList) {
        chiefOperationsIdList.add(chiefOperation['id']);
        operatorOperationsDtoList.add(OperatorOperationsDTO(
            id: 0,
            timeplan: operation.timePlan,
            timeFirstStart: 0,
            statusId: operation.statusId,
            status: StatusDTO(id: 0, name: ''),
            batchId: operation.batchId,
            batch: BatchDTO.empty,
            distributionStageId: chiefOperation['distribution_stage_id'],
            stageId: operation.stageId,
            stage: StageDTO.empty,
            operationId: operation.operationId,
            operation: OperationDTO.empty,
            areaId: operation.areaId,
            order: orderNumber,
            chiefOperationId: chiefOperation['id'],
            chiefBatchId: chiefOperation['chief_batch_id'],
            area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
        orderNumber++;
      }

      await _chiefDistributionOperationsTable.updateQuantity(
          chiefOperationId: operation.chiefOperationId,
          newQuantity: operation.oldQuantity - quantity);
    }

    await _operatorOperationsTable.bulkInsert(
        operationsList: operatorOperationsDtoList);

    fetchChiefOperations();

    operationsForDistributionList = [];
    _chiefOperationTable.changeIsDistributed(
        operationsIdList: chiefOperationsIdList);
  }

  void listControllerAddListener() {
    listController.addListener(() {
      if (chiefOperationsSelectMinRange != 0 &&
          (listController.position.minScrollExtent == listController.offset)) {
        chiefOperationsSelectMinRange -= distributionPageElementsLimit;
        chiefOperationsSelectMaxRange -= distributionPageElementsLimit;
        fetchChiefOperations();
        print('min');
      }

      if ((state.chiefOperationsList.length > distributionPageElementsLimit) &&
          (listController.position.maxScrollExtent == listController.offset)) {
        chiefOperationsSelectMinRange += distributionPageElementsLimit;
        chiefOperationsSelectMaxRange += distributionPageElementsLimit;

        print('max');
        fetchChiefOperations();
      }
    });
  }
}
