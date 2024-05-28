import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/local/service/notification_service.dart';

import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';

import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/presentation/pages/chief/statistics_page/chief_stage_report_model.dart';

import 'package:open_filex/open_filex.dart';

import '../../../../../domain/model/area.dart';
import '../stage_model.dart';
import '../statistics_stage_model.dart';

part 'statistics_state.dart';

class StatisticsCubit extends Cubit<ChiefStatisticsState> {
  StatisticsCubit() : super(ChiefStatisticsState());

  final ExcelService _excelService = ExcelService();

  final ChiefDistributionOperationsTable _chiefDistributionOperationsTable =
      ChiefDistributionOperationsTable();

  final ChiefOperationTable _chiefOperationTable = ChiefOperationTable();

  final OperatorOperationsTable _operatorOperationsTable =
      OperatorOperationsTable();

  final ChiefBatchTable _chiefBatchTable = ChiefBatchTable();

  int activeAreaId = 0;

  Future<void> fetchStagesNew() async {
    int? companyId = CompanyService.instance.companyId;
    print('companyId: $companyId');
    List<StatisticsStageModel2> stagesList = [];
    Map<int, StatisticsBatchModel> batchesMap = {};
    Map<int, List<int>> stagesInBatchesMap = {};

    var fetchedChiefOperations = await _chiefOperationTable.select();

    for (var chiefOperation in fetchedChiefOperations) {
      final chiefOperationDto = ChiefOperationDto.fromMap(chiefOperation);

      if (batchesMap.containsKey(chiefOperationDto.chiefBatchId)) {
        if (stagesInBatchesMap[chiefOperationDto.chiefBatchId]!
            .contains(chiefOperationDto.stage?.id)) {
          batchesMap[chiefOperationDto.chiefBatchId]
              ?.stagesList
              ?.firstWhere(
                  (element) => element.stage?.id == chiefOperationDto.stage?.id)
              .operationsList
              ?.add(StatisticsOperationModel2(
                  operation: chiefOperationDto.operation,
                  chiefOperationId: chiefOperationDto.id));
        } else {
          batchesMap[chiefOperationDto.chiefBatchId]?.stagesList?.add(
                  StatisticsStageModel2(
                      stage: chiefOperationDto.stage,
                      operationsList: [
                    StatisticsOperationModel2(
                        operation: chiefOperationDto.operation,
                        chiefOperationId: chiefOperationDto.id)
                  ]));

          List<int> newList =
              stagesInBatchesMap[chiefOperationDto.chiefBatchId]!;

          newList.add(chiefOperationDto.stage!.id);

          stagesInBatchesMap[chiefOperationDto.chiefBatchId] = newList;
        }
      } else {
        batchesMap[chiefOperationDto.chiefBatchId] = StatisticsBatchModel(
            chiefBatchId: chiefOperationDto.chiefBatchId,
            name: chiefOperationDto.chiefBatch!.batch.name,
            number: chiefOperationDto.chiefBatch!.batch.number,
            stagesList: [
              StatisticsStageModel2(
                  stage: chiefOperationDto.stage,
                  operationsList: [
                    StatisticsOperationModel2(
                        operation: chiefOperationDto.operation,
                        chiefOperationId: chiefOperationDto.id)
                  ])
            ]);

        stagesInBatchesMap[chiefOperationDto.chiefBatchId] = [
          chiefOperationDto.stage?.id ?? 0
        ];
      }
    }

    var fetchedOperatorOperations = await _operatorOperationsTable.select();

    for (var operatorOperation in fetchedOperatorOperations) {
      final operatorOperationsDto =
          OperatorOperationsDTO.fromMap(operatorOperation);
      var stage = batchesMap[operatorOperationsDto.chiefBatchId]
          ?.stagesList
          ?.firstWhere((element) =>
              element.stage?.id ==
              operatorOperationsDto.chiefOperation?.stageId);

      var operation = stage?.operationsList?.firstWhere((element) =>
          element.operation?.id == operatorOperationsDto.operation.id);

      operation?.status = Status(
          id: operatorOperationsDto.status.id,
          name: operatorOperationsDto.status.name);

      operation?.timeFact = operatorOperationsDto.timefact;

      operation?.timePlan = operatorOperationsDto.timeplan;

      operation?.timeWorking = operatorOperationsDto.timeworking;

      operation?.timeStop = operatorOperationsDto.timestop;

      operation?.timeStart = operatorOperationsDto.timestart;

      operation?.machine = operatorOperationsDto.machine;

      operation?.user = operatorOperationsDto.user;

      if (operation?.status?.id == 6) {
        stage?.readyOperationsQuantity++;
        stage?.readyOperationsPercent =
            ((stage.readyOperationsQuantity / stage.operationsList!.length) *
                    100)
                .toInt();
      }
    }
  }

  Future<void> fetchStages() async {
    List<StatisticsStageModel> stagesList = [];
    Map<int, StatisticsStageModel> stagesMap = {};
    var fetchedChiefOperationsList =
        await _chiefDistributionOperationsTable.select();

    for (var operation in fetchedChiefOperationsList) {
      final chiefOperationDto =
          ChiefDistributionOperationsDTO.fromMap(operation);
      final chiefOperation = ChiefDistributionOperation(
          id: chiefOperationDto.id,
          operationId: chiefOperationDto.operationId,
          stageId: chiefOperationDto.stageId,
          stage: chiefOperationDto.stage,
          operation: chiefOperationDto.operation,
          batchId: chiefOperationDto.batchId,
          batch: chiefOperationDto.batch,
          quantity: chiefOperationDto.quantity);
      if (stagesMap.containsKey(chiefOperation.stageId)) {
        // берем старый список
        List<StatisticOperationModel> newOperationsList =
            stagesMap[chiefOperation.stageId]!.operationsList;
        // добавляем новую операцию
        newOperationsList.add(StatisticOperationModel(
          id: chiefOperation.id,
          operationId: chiefOperation.operationId,
          stageId: chiefOperation.stageId,
          stage: chiefOperation.stage,
          operation: chiefOperation.operation,
          batchId: chiefOperation.batchId,
          batch: chiefOperation.batch,
          quantity: chiefOperation.quantity,
          readyOperationsList: [],
        ));
        // заменяем список в модели на новый
        stagesMap[chiefOperation.stageId]?.operationsList = newOperationsList;
      } else {
        stagesMap[chiefOperation.stageId] = StatisticsStageModel(
            stage: StageDTO(
                id: chiefOperation.stage.id,
                number: chiefOperation.stage.number,
                name: chiefOperation.stage.name,
                areaId: chiefOperation.stage.areaId,
                area: chiefOperation.stage.area,
                isdistributed: chiefOperation.stage.isdistributed,
                batchId: chiefOperation.stage.batchId,
                batch: chiefOperation.batch),
            operationsList: [
              StatisticOperationModel(
                id: chiefOperation.id,
                operationId: chiefOperation.operationId,
                stageId: chiefOperation.stageId,
                stage: chiefOperation.stage,
                operation: chiefOperation.operation,
                batchId: chiefOperation.batchId,
                batch: chiefOperation.batch,
                quantity: chiefOperation.quantity,
                readyOperationsList: [],
              )
            ]);
      }
    }

    var fetchedOperatorOperationsList = await _operatorOperationsTable.select();

    for (var operatorOperation in fetchedOperatorOperationsList) {
      final operatorOperationDto =
          OperatorOperationsDTO.fromMap(operatorOperation);

      var oldOperation = stagesMap[operatorOperationDto.stageId]
          ?.operationsList
          .firstWhere((element) =>
              element.operationId == operatorOperationDto.operationId);

      int? index = stagesMap[operatorOperationDto.stageId]
          ?.operationsList
          .indexOf(oldOperation!);

      if (index != null) {
        Map<int, int>? statusMap = stagesMap[operatorOperationDto.stageId]
            ?.operationsList[index]
            .statusMap;
        if (statusMap != null) {
          if (statusMap.containsKey(operatorOperationDto.statusId)) {
            statusMap[operatorOperationDto.statusId] =
                (statusMap[operatorOperationDto.statusId]! + 1);
            if (operatorOperationDto.statusId == 6) {
              stagesMap[operatorOperationDto.stageId]?.readyOperationsQuantity =
                  (stagesMap[operatorOperationDto.stageId]!
                          .readyOperationsQuantity! +
                      1);
            }
          } else {
            statusMap[operatorOperationDto.statusId] = 1;
          }
          stagesMap[operatorOperationDto.stageId]
              ?.operationsList[index]
              .statusMap = statusMap;
          stagesMap[operatorOperationDto.stageId]?.operationsList[index].area =
              Area(
                  id: operatorOperationDto.area?.id ?? 0,
                  name: operatorOperationDto.area?.name ?? '',
                  number: operatorOperationDto.area?.number ?? '',
                  unitId: operatorOperationDto.area?.unitId ?? 0);
        }

        if (operatorOperationDto.statusId == 9) {
          stagesMap[operatorOperationDto.stageId]
              ?.operationsList[index]
              .readyOperationsList
              .add(ReadyOperationModel(
                timeFact: operatorOperationDto.timefact,
                timePlan: operatorOperationDto.timeplan,
                timeStart: operatorOperationDto.timestart,
                timeStop: operatorOperationDto.timestop,
                timeWorking: operatorOperationDto.timeworking,
                user: operatorOperationDto.user,
              ));
        }
      }
    }

    stagesMap.forEach((key, value) {
      value.operationsQuantity =
          (value.stage.batch!.count * value.operationsList.length);
      value.readyOperationsPercent =
          ((value.readyOperationsQuantity! / value.operationsQuantity) * 100)
              .toInt();
      stagesList.add(value);
    });

    // emit(state.copyWith(stagesList: stagesList));
  }

  // Future<void> fetchReadyPercent({required StatisticsStageModel stage}) async {
  //   for (var operation in stage.operationsList) {
  //     if (operation.statusMap[6] != null) {
  //       operation.readyPercent = operation.statusMap[6]! == 0
  //           ? 0
  //           : (((operation.statusMap[6]! / operation.quantity) * 100)).toInt();
  //     }
  //   }
  // }

  Future<void> uploadReportToExcel() async {
    // String filePath =
    //     await _excelService.uploadReport(stagesList: state.stagesList);
    // if (filePath == '') {
    //   filePath = 'что-то пошло не так';
    // } else {
    //   filePath = '$filePath/Отчет о производстве.xlsx';
    // }
    // NotificationService.showNotification(
    //     title: 'Отчет о производстве загружен',
    //     body: 'путь: $filePath',
    //     payload: filePath);
    //
    // NotificationService.onClickNotification.stream.listen((event) {
    //   print(event);
    //   OpenFilex.open(event);
    // });
  }

  Future<void> fetchStagesForReport() async {
    Map<int, ChiefStageForReportModel> stagesMap = {};
    List<ChiefStageForReportModel> stagesList = [];

    var fetchedChiefOperationsList =
        await _chiefDistributionOperationsTable.select();

    for (var operation in fetchedChiefOperationsList) {
      final chiefOperationDto =
          ChiefDistributionOperationsDTO.fromMap(operation);

      final chiefOperation = ChiefDistributionOperation(
          id: chiefOperationDto.id,
          operationId: chiefOperationDto.operationId,
          stageId: chiefOperationDto.stageId,
          stage: chiefOperationDto.stage,
          operation: chiefOperationDto.operation,
          batchId: chiefOperationDto.batchId,
          batch: chiefOperationDto.batch,
          quantity: chiefOperationDto.quantity);

      if (!stagesMap.containsKey(chiefOperation.stageId)) {
        stagesMap[chiefOperation.stageId] = ChiefStageForReportModel(
            batchId: chiefOperation.batchId,
            batchNumber: chiefOperation.batch.number,
            batchName: chiefOperation.batch.name,
            batchCode: chiefOperation.batch.code,
            stageNumber: chiefOperation.stage.number);

        stagesMap[chiefOperation.stageId]?.detailsQuantity =
            chiefOperation.batch.count;
      }

      stagesMap[chiefOperation.stageId]?.operationsList.add(ChiefOperationModel(
          name: chiefOperation.operation.name,
          number: chiefOperation.operation.number,
          operationId: chiefOperation.operation.id,
          code: chiefOperation.operation.code));

      stagesMap[chiefOperation.stageId]?.operationsQuantity++;
    }

    var fetchedOperatorOperationsList = await _operatorOperationsTable.select();

    for (var operation in fetchedOperatorOperationsList) {
      final operatorOperationsDto = OperatorOperationsDTO.fromMap(operation);

      final operationInList = stagesMap[operatorOperationsDto.stageId]
          ?.operationsList
          .firstWhere((element) =>
              element.operationId == operatorOperationsDto.operationId);

      operationInList?.areaNumber = operatorOperationsDto.area!.number;

      operationInList?.inWorkQuantity++;

      switch (operatorOperationsDto.statusId) {
        case 4:
          operationInList?.modificationQuantity++;
        case 5:
          stagesMap[operatorOperationsDto.stageId]?.defectDetailsQuantity++;
          operationInList?.defectQuantity++;
        case 6:
          stagesMap[operatorOperationsDto.stageId]?.readyOperationsQuantity++;
          operationInList?.readyQuantity++;
        case 9:
          stagesMap[operatorOperationsDto.stageId]?.readyOperationsQuantity++;
          operationInList?.readyQuantity++;
      }

      final totalOperationsQuantity =
          stagesMap[operatorOperationsDto.stageId]!.operationsQuantity *
              stagesMap[operatorOperationsDto.stageId]!.detailsQuantity;

      operationInList?.readyPercent =
      ((operationInList.readyQuantity / totalOperationsQuantity) *
              100).round();

    }

    stagesMap.forEach((key, value) async {
      value.operationsQuantity =
          value.operationsQuantity * value.detailsQuantity;

      value.readyOperationsPercent =
      ((value.readyOperationsQuantity / value.operationsQuantity)*
          100).round();

      value.readyDetailsQuantity =
          await _chiefBatchTable.fetchReadyDetailsCount(batchId: value.batchId);
      value.defectDetailsQuantity = await _chiefBatchTable
          .fetchDefectDetailsCount(batchId: value.batchId);
    });

    stagesMap.forEach((key, value) {
      stagesList.add(value);
    });
    emit(state.copyWith(stagesList: stagesList));
  }

  Future<void> uploadStagesReportToExcel() async {
    String filePath = await _excelService.uploadChiefStagesReport(
        stagesList: state.stagesList);
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    } else {
      filePath = '$filePath/Этапы.xlsx';
    }
    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }

  Future<void> uploadOperationsReportToExcel() async {
    String filePath = await _excelService.uploadChiefOperationsReport(
        stagesList: state.stagesList);
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    } else {
      filePath = '$filePath/Ход выполнения операций.xlsx';
    }
    NotificationService.showNotification(
        title: 'Отчет о производстве загружен',
        body: 'путь: $filePath',
        payload: filePath);

    NotificationService.onClickNotification.stream.listen((event) {
      print(event);
      OpenFilex.open(event);
    });
  }
}
