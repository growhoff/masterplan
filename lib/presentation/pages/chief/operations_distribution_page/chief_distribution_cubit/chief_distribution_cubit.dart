import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/area_table.dart';

import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
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

  final OperatorOperationsTable _operatorOperationsTable =
      OperatorOperationsTable();

  final AreaTable _areaTable = AreaTable();
  final ChiefOperationTable _chiefOperationTable = ChiefOperationTable();
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
    List<ChiefDistributionOperation> chiefOperationsList = [];
    var fetchedChiefOperationsList =
        await _chiefDistributionOperationsTable.selectNotDistributed(
            maxRange: chiefOperationsSelectMaxRange,
            minRange: chiefOperationsSelectMinRange);

    for (var operation in fetchedChiefOperationsList) {
      final chiefOperationDto =
          ChiefDistributionOperationsDTO.fromMap(operation);
      chiefOperationsList.add(ChiefDistributionOperation(
          operationId: chiefOperationDto.operationId,
          stageId: chiefOperationDto.stageId,
          stage: chiefOperationDto.stage,
          operation: chiefOperationDto.operation,
          batchId: chiefOperationDto.batchId,
          batch: chiefOperationDto.batch,
          quantity: chiefOperationDto.quantity,
          id: chiefOperationDto.id));
      isElementOpenList.add(false);
    }
    emit(state.copyWith(
        chiefOperationsList: chiefOperationsList,
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
    try{
      await _excelStageLoadService.stageExcelFunction();
    }
    catch(e){

    }

    fetchChiefOperations();

    // await _excelStageLoadService.finishLoading();
  }

  Future<void> sendOperationsToDistribution() async {
    emit(state.copyWith(status: DistributionPageStatus.loading));
    List<int> chiefOperationsIdList = [];
    for (var operation in operationsForDistributionList) {
      final quantity = operation.quantity;
      print(operation.operationId);
      var fetchedChiefOperationsList =
          await _chiefOperationTable.fetchOperationsByOperationIdWithLimit(
              limit: quantity, operationId: operation.operationId);

      for (var chiefOperation in fetchedChiefOperationsList) {
        chiefOperationsIdList.add(chiefOperation['id']);
      }

      for (int i = 0; i < quantity; i++) {
        await _operatorOperationsTable.insert(OperatorOperationsDTO(
            id: 0,
            timeplan: 0,
            timefact: 0,
            statusId: operation.statusId,
            status: StatusDTO(id: 0, name: ''),
            batchId: operation.batchId,
            batch: BatchDTO.empty,
            stageId: operation.stageId,
            stage: StageDTO.empty,
            operationId: operation.operationId,
            operation: OperationDTO.empty,
            areaId: operation.areaId,
            order: i + 1,
            chiefOperationId: fetchedChiefOperationsList[i]['id'],
            chiefBatchId: fetchedChiefOperationsList[i]['chief_batch_id'],
            area: AreaDTO(id: 0, name: '', number: '', unitId: 0)));
      }
      await _chiefDistributionOperationsTable.updateQuantity(
          chiefOperationId: operation.chiefOperationId,
          newQuantity: operation.oldQuantity - quantity);
    }

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
