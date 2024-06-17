import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_batch_table.dart';
import 'package:master_plan/domain/usecase/company_service.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/local/service/notification_service.dart';

import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';

import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';

import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';

import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';

import 'package:master_plan/presentation/pages/chief/statistics_page/chief_stage_report_model.dart';

import 'package:open_filex/open_filex.dart';

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
      switch (operatorOperationsDto.statusId) {
        case 2:
          operationInList?.onDistribution++;
          stagesMap[operatorOperationsDto.stageId]?.onDistributionOperationsQuantity++;
        case 3:
          operationInList?.distributed++;
          stagesMap[operatorOperationsDto.stageId]?.distributedOperationsQuantity++;
        case 4:
          operationInList?.modificationQuantity++;
          stagesMap[operatorOperationsDto.stageId]?.modificationOperationsQuantity++;
        case 5:
          stagesMap[operatorOperationsDto.stageId]?.defectDetailsQuantity++;
          stagesMap[operatorOperationsDto.stageId]?.defectOperationsQuantity++;
          operationInList?.defectQuantity++;
        // case 7:
        //   operationInList?.distributed++;
        //   stagesMap[operatorOperationsDto.stageId]?.distributedOperationsQuantity++;
        case 9:
          stagesMap[operatorOperationsDto.stageId]?.readyOperationsQuantity++;
          operationInList?.readyQuantity++;
      }


    }

    stagesMap.forEach((key, value) async {
      int defectCount = 0;

      for (int i = 0; i < value.operationsList.length; i++) {
        value.operationsList[i].mustBeDone =
            value.detailsQuantity - defectCount;
        defectCount = defectCount + value.operationsList[i].defectQuantity;

        value.operationsList[i].readyPercent =
            (value.operationsList[i].readyQuantity /
                    value.detailsQuantity *
                    100)
                .round();
      }

      value.operationsQuantity =
          value.operationsQuantity * value.detailsQuantity;

      value.readyOperationsPercent =
          ((value.readyOperationsQuantity / value.operationsQuantity) * 100)
              .round();

      value.readyDetailsQuantity =
          await _chiefBatchTable.fetchReadyDetailsCount(batchId: value.batchId);

      value.readyDetailsPercent =
          (value.readyDetailsQuantity / value.detailsQuantity * 100).round();

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
