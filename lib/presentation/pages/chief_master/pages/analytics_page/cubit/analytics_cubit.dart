import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';

// import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/position.dart';

// import 'package:master_plan/domain/model/staff.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../../data/repositories/local/service/notification_service.dart';
import '../../../../../../data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import '../../../../../../data/repositories/supabase/dto/position_staff_dto.dart';
import '../../../../../../data/repositories/supabase/service/chief_batch_table.dart';
import '../../../../../../data/repositories/supabase/service/chief_distribution_operations_table.dart';
import '../../../../../../domain/model/chief_distribution_operations_model.dart';
import '../../../../../../domain/model/operator_operations.dart';
import '../../../../../../domain/model/position_staff.dart';
import '../../../../chief/chief_analytics_page/chief_stage_report_model.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this.staffId) : super(AnalyticsState());

  final _operatorOperationsTable = OperatorOperationsTable();
  final _excelService = ExcelService();
  final _positionStaffTable = PositionStaffTable();
  final ChiefDistributionOperationsTable _chiefDistributionOperationsTable =
      ChiefDistributionOperationsTable();
  final ChiefBatchTable _chiefBatchTable = ChiefBatchTable();
  final int staffId;

  Future<void> fetchReadyOperations({int? timeStart, int? timeEnd}) async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    List<OperatorOperations> operatorOperationsList = [];
    List<int> areasList = [];

    // получить список участков на которых работает мастер
    print('staffId: $staffId');
    var fetchedList =
        await _positionStaffTable.selectByStaffId(staffId: staffId);

    for (var fetchedStaff in fetchedList) {
      final positionStaffDto = PositionStaffDTO.fromMap(fetchedStaff);
      final positionStaff = PositionStaffModel.fromDTO(positionStaffDto);
      areasList.add(positionStaff.areaId ?? 0);
    }
    print('areasList: $areasList');
    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnArea(areasList);

    print(fetchedOperationsList);
    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = convertOperationDtoToModel(dto: operationDto);

      if (timeStart != null && timeEnd != null) {
        print(
            'start: ${timeStart}  operation: ${operation.timeFirstStart} end: ${timeEnd}');
        if ((operation.timeFirstStart >= timeStart &&
                operation.timeFirstStart <= timeEnd) ||
            operation.timeFirstStart == 0) {
          operatorOperationsList.add(operation);
        }
      } else {
        operatorOperationsList.add(operation);
      }
    }

    var operationsMap =
        groupBy(operatorOperationsList, (operation) => operation.optimalPart);

    operationsMap.forEach((key, value) {
      var hours =
          DateTime.fromMillisecondsSinceEpoch(value.first.timestop ?? 0).hour;

      var dateTime =
          DateTime.fromMillisecondsSinceEpoch(value.first.timestop ?? 0);
      String date = '${dateTime.day}.${dateTime.month}.${dateTime.year}';

      int change = 1;
      (hours >= 8 && hours <= 20) ? change = 1 : change = 2;

      AnalyticsOperationModel analyticsOperation = AnalyticsOperationModel(
          comment: value.first.comment ?? '',
          operationId: value.first.operation.id,
          code: value.first.operation.code,
          detailNumber: value.first.batch.number,
          operationNumber: value.first.operation.number,
          operationName: value.first.operation.name,
          timePlan: TimeConverter.instance
              .convertTimeFromMinutes(value.first.timeplan),
          timeFact: TimeConverter.instance
              .convertTimeFromSeconds(value.first.timeworking ?? 0),
          machineName: value.first.machine?.name ?? '',
          machineInventoryNumber: value.first.machine?.inventoryNumber ?? 0,
          fio: value.first.user?.fio ?? 'мастер',
          date: date,
          change: change,
          areaNumber: value.first.area.number,
          detailName: value.first.batch.name);

      for (var operation in value) {
        analyticsOperation.quantity++;
        switch (operation.status.id) {
          case 4:
            analyticsOperation.modificationQuantity++;
          case 5:
            analyticsOperation.defectQuantity++;
        }
      }
      analyticsOperationsList.add(analyticsOperation);
    });

    emit(state.copyWith(analyticsOperationsList: analyticsOperationsList));
  }

  Future<void> uploadReadyOperationsReport(BuildContext context) async {
    DateTime start = DateTime(2024);
    DateTime end = DateTime.now();

    final dateTimeRange = await showDateRangePicker(
        context: context, firstDate: start, lastDate: end);
    if (dateTimeRange != null) {
      start = dateTimeRange.start;
      end = dateTimeRange.end;
    }

    await fetchReadyOperations(
        timeStart: start.millisecondsSinceEpoch,
        timeEnd: end.millisecondsSinceEpoch + 86399000);

    String filePath = await _excelService.uploadReadyOperationsReport(
        analyticsOperationsList: state.analyticsOperationsList);
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    } else {
      filePath = '$filePath/Выполненные операции.xlsx';
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
            code: chiefOperation.batch.code,
            technologyNumber: chiefOperation.batch.technology,
            batchId: chiefOperation.batchId,
            batchNumber: chiefOperation.batch.number,
            batchName: chiefOperation.batch.name,
            batchCode: chiefOperation.batch.code,
            stageNumber: chiefOperation.stage.number);

        stagesMap[chiefOperation.stageId]?.detailsQuantity =
            chiefOperation.batch.count;
      }

      stagesMap[chiefOperation.stageId]?.operationsList.add(
          ChiefOperationForReportModel(
              name: chiefOperation.operation.name,
              number: chiefOperation.operation.number,
              operationId: chiefOperation.operation.id,
              code: chiefOperation.operation.code));

      stagesMap[chiefOperation.stageId]?.operationsQuantity++;
    }

    var fetchedOperatorOperationsList = await _operatorOperationsTable
        .selectOrderedByChiefBatchIdAndChiefOperationId();

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
          } else {
            if (operatorOperationsDto.chiefBatchId !=
                prevOperation.chiefBatchId) {
              operationInList?.onDistribution++;
              stagesMap[operatorOperationsDto.stageId]
                  ?.onDistributionOperationsQuantity++;
            } else {
              if ((operatorOperationsDto.modific == false ||
                      operatorOperationsDto.modific == null) &&
                  (prevOperation.chiefOperationId ==
                      operatorOperationsDto.chiefOperationId! - 1) &&
                  (prevOperation.statusId == 9)) {
                operationInList?.onDistribution++;
                stagesMap[operatorOperationsDto.stageId]
                    ?.onDistributionOperationsQuantity++;
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

    stagesMap.forEach((key, value) async {
      int defectCount = 0;
      //int onDistributionCount = 0;

      for (int i = 0; i < value.operationsList.length; i++) {
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

      value.semisQuantity = value.detailsQuantity - value.defectDetailsQuantity;

      value.missingSemisQuantity = value.detailsQuantity - value.semisQuantity;
    });

    stagesMap.forEach((key, value) {
      stagesList.add(value);
    });
    emit(state.copyWith(
        stagesList: stagesList, status: AnalyticsPageStatus.success));
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

  OperatorOperations convertOperationDtoToModel(
      {required OperatorOperationsDTO dto}) {
    return OperatorOperations(
        timeworking: dto.timeworking,
        optimalPart: dto.optimalPart,
        timeplan: dto.timeplan ?? 0,
        id: dto.id,
        timestop: dto.timestop,
        user: User(
            id: 0,
            fio: dto.user?.fio ?? 'empty',
            positionId: 0,
            companyId: 0,
            unitId: 0,
            areaId: 0,
            photo: '',
            positionModel: Position(id: 0, name: '')),
        machine: Machine(
            id: 0,
            isActivated: dto.machine?.isActivated ?? false,
            inventoryNumber: dto.machine?.inventoryNumber ?? 0,
            name: dto.machine?.name ?? 'empty_machine_name',
            areaId: 0),
        timeFirstStart: dto.timeFirstStart ?? 0,
        status: Status(id: dto.status.id, name: dto.status.name),
        batch: Batch(
            id: dto.batch.id,
            number: dto.batch.number,
            name: dto.batch.name,
            count: dto.batch.count,
            code: dto.batch.code,
            technology: dto.batch.technology,
            isready: dto.batch.isready,
            orderId: dto.batch.orderId),
        stage: dto.stage ?? StageDTO.empty,
        operation: dto.operation,
        area: dto.area ?? AreaDTO(id: 0, name: '', number: '', unitId: 0));
  }
}
