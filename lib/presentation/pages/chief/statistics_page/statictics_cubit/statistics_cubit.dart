import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/local/service/notification_service.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';

import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/domain/model/status.dart';

import 'package:open_filex/open_filex.dart';

import '../../../../../data/repositories/supabase/service/area_table.dart';
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
  int activeAreaId = 0;

  // Future<void> fetchStagesNew() async {
  //   List<StatisticsStageModel2> stagesList = [];
  //   Map<int, StatisticsBatchModel> batchesMap = {};
  //   Map<int, List<int>> stagesInBatchesMap = {};
  //
  //   var fetchedChiefOperations = await _chiefOperationTable.select();
  //
  //   for (var chiefOperation in fetchedChiefOperations) {
  //     final chiefOperationDto = ChiefOperationDto.fromMap(chiefOperation);
  //
  //     if (batchesMap.containsKey(chiefOperationDto.chiefBatchId)) {
  //       if (stagesInBatchesMap[chiefOperationDto.chiefBatchId]!
  //           .contains(chiefOperationDto.stage.id)) {
  //         batchesMap[chiefOperationDto.chiefBatchId]
  //             ?.stagesList
  //             ?.firstWhere(
  //                 (element) => element.stage.id == chiefOperationDto.stage.id)
  //             .operationsList
  //             ?.add(StatisticsOperationModel2(
  //                 operation: chiefOperationDto.operation));
  //       } else {
  //         batchesMap[chiefOperationDto.chiefBatchId]?.stagesList?.add(
  //                 StatisticsStageModel2(
  //                     stage: chiefOperationDto.stage,
  //                     operationsList: [
  //                   StatisticsOperationModel2(
  //                       operation: chiefOperationDto.operation)
  //                 ]));
  //
  //         List<int> newList =
  //             stagesInBatchesMap[chiefOperationDto.chiefBatchId]!;
  //
  //         newList.add(chiefOperationDto.stage.id);
  //
  //         stagesInBatchesMap[chiefOperationDto.chiefBatchId] = newList;
  //       }
  //     } else {
  //       batchesMap[chiefOperationDto.chiefBatchId] = StatisticsBatchModel(
  //           chiefBatchId: chiefOperationDto.chiefBatchId,
  //           name: chiefOperationDto.chiefBatch.batch.name,
  //           number: chiefOperationDto.chiefBatch.batch.number,
  //           stagesList: [
  //             StatisticsStageModel2(
  //                 stage: chiefOperationDto.stage,
  //                 operationsList: [
  //                   StatisticsOperationModel2(
  //                       operation: chiefOperationDto.operation)
  //                 ])
  //           ]);
  //
  //       stagesInBatchesMap[chiefOperationDto.chiefBatchId] = [
  //         chiefOperationDto.stage.id
  //       ];
  //     }
  //   }
  //
  //   var fetchedOperatorOperations = await _operatorOperationsTable.select();
  //
  //   for (var operatorOperation in fetchedOperatorOperations) {
  //     print(operatorOperation);
  //     final operatorOperationsDto =
  //         OperatorOperationsDTO.fromMap(operatorOperation);
  //     var stage = batchesMap[operatorOperationsDto.chiefBatchId]
  //         ?.stagesList
  //         ?.firstWhere((element) =>
  //             element.stage.id ==
  //             operatorOperationsDto.chiefOperation?.stageId);
  //
  //     var operation = stage?.operationsList?.firstWhere((element) =>
  //         element.operation.id == operatorOperationsDto.operation.id);
  //
  //     operation?.status = Status(
  //         id: operatorOperationsDto.status.id,
  //         name: operatorOperationsDto.status.name);
  //
  //     operation?.timeFact = operatorOperationsDto.timefact;
  //
  //     operation?.timePlan = operatorOperationsDto.timeplan;
  //
  //     operation?.timeWorking = operatorOperationsDto.timeworking;
  //
  //     operation?.timeStop = operatorOperationsDto.timestop;
  //
  //     operation?.timeStart = operatorOperationsDto.timestart;
  //
  //     operation?.machine = operatorOperationsDto.machine;
  //
  //     operation?.user = operatorOperationsDto.user;
  //
  //     if (operation?.status?.id == 6) {
  //       stage?.readyOperationsQuantity++;
  //       stage?.readyOperationsPercent = int.parse(
  //           ((stage.readyOperationsQuantity / stage.operationsList!.length) *
  //                   100)
  //               .toString());
  //     }
  //   }
  // }

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

    emit(state.copyWith(stagesList: stagesList));
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
    String filePath =
        await _excelService.uploadReport(stagesList: state.stagesList);
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    } else {
      filePath = '$filePath/Отчет о производстве.xlsx';
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
