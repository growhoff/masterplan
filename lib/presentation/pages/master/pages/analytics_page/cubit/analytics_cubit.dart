import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';

// import 'package:master_plan/data/repositories/supabase/service/position_staff_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/domain/usecase/areas_list_service.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';

import '../../../../../../data/repositories/supabase/dto/transfer_operations_dto.dart';
import '../../../../../../data/repositories/supabase/service/transfer_operations_table.dart';
import '../../../../../../domain/model/company.dart';
import '../../../../../../domain/model/distribution_stage.dart';
import '../../../../../../domain/model/operator_operations.dart';
import '../../../../../../domain/model/unit.dart';
import '../../../../../../domain/usecase/upload_reports_service.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsState());



  final _operatorOperationsTable = OperatorOperationsTable();
  final _uploadReportsService = UploadReportsService();

  final _transferOperationsTable = TransferOperationsTable();

  final _areasIdsList = AreasListService.instance.areasIdsList;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  Future fetchTime(BuildContext context) async {
    DateTime start = DateTime(2024);
    DateTime end = DateTime.now();

    final dateTimeRange = await showDateRangePicker(
        context: context, firstDate: start, lastDate: end);
    if (dateTimeRange != null) {
      start = dateTimeRange.start;
      end = dateTimeRange.end;
    }

    timeStart = start;
    timeEnd = end;
  }

  String getDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> fetchReadyOperations() async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    List<TransferAnalyticsModel> transfersAnalyticsModelsList = [];

    List<int> operatorOperationsIdsList = [];

    List<TransferOperationsDTO> transferOperationsList = [];

    List<OperatorOperations> operatorOperationsList = [];

    int start = timeStart.millisecondsSinceEpoch;
    int end = timeEnd.millisecondsSinceEpoch + 86399000;

    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnArea(_areasIdsList);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = convertOperationDtoToModel(dto: operationDto);

      if ((operation.timeFirstStart >= start &&
          operation.timeFirstStart <= end)) {
        operatorOperationsList.add(operation);
        operatorOperationsIdsList.add(operation.id);
      }
    }

    var fetchedTransfersList = await _transferOperationsTable
        .selectByOperatorOperationsIdsList(operatorOperationsIdsList);

    for (var transfer in fetchedTransfersList) {
      final transferOperationDto = TransferOperationsDTO.fromMap(transfer);
      transferOperationsList.add(transferOperationDto);
    }

    var transfersMap = groupBy(
        transferOperationsList, (transfer) => transfer.operatorOperationId);


    var operationsMap =
        groupBy(operatorOperationsList, (operation) => operation.optimalPart);

    operationsMap.forEach((key, value) {
      var hours =
          DateTime.fromMillisecondsSinceEpoch(value.first.timestop ?? 0).hour;

      var dateTimeEnd =
          DateTime.fromMillisecondsSinceEpoch(value.first.timestop ?? 0);

      String dateEnd =
          '${dateTimeEnd.day}.${dateTimeEnd.month}.${dateTimeEnd.year}';
      String timeEnd = '${dateTimeEnd.hour}:${dateTimeEnd.minute}';

      var dateTimeStart =
          DateTime.fromMillisecondsSinceEpoch(value.first.timeFirstStart);

      String dateStart =
          '${dateTimeStart.day}.${dateTimeStart.month}.${dateTimeStart.year}';
      String timeStart = '${dateTimeStart.hour}:${dateTimeStart.minute}';

      int change = 1;
      (hours >= 8 && hours <= 20) ? change = 1 : change = 2;

      print('comment: ${value.first.comment}');

      AnalyticsOperationModel analyticsOperation = AnalyticsOperationModel(
          batch: value.first.batch,
          stage: value.first.stage,
          unitNumber: value.first.distributionStage?.unit?.number ?? '',
          operationId: value.first.operation.id,
          code: '${value.first.batch.code}.${value.first.operation.code}',
          comment: value.first.comment ?? '',
          detailNumber: value.first.batch.numberRS,
          operationNumber: value.first.operation.number,
          operationName: value.first.operation.name,
          timePlan:value.first.timeplan,
          timeFact: value.first.timeworking ?? 0,
          machineName: value.first.machine?.name ?? '',
          machineInventoryNumber: value.first.machine?.inventoryNumber ?? 0,
          fio: value.first.user?.fio ?? '',
          dateEnd: dateEnd,
          timeEnd: timeEnd,
          dateStart: dateStart,
          timeStart: timeStart,
          change: change,
          areaNumber: value.first.area.number,
          detailName: value.first.batch.name);


      transfersAnalyticsModelsList = [];

      if (transfersMap[value.first.id] != null) {
        for (var transfer in transfersMap[value.first.id]!) {
          var transferHours =
              DateTime.fromMillisecondsSinceEpoch(transfer.timestop ?? 0).hour;

          var transferDateTimeEnd =
          DateTime.fromMillisecondsSinceEpoch(transfer.timestop ?? 0);

          String transferDateEnd =
              '${transferDateTimeEnd.day}.${transferDateTimeEnd.month}.${transferDateTimeEnd.year}';
          String transferTimeEnd =
              '${transferDateTimeEnd.hour}:${transferDateTimeEnd.minute}';

          var transferDateTimeStart =
          DateTime.fromMillisecondsSinceEpoch(transfer.timeFirstStart ?? 0);

          String transferDateStart =
              '${transferDateTimeStart.day}.${transferDateTimeStart.month}.${transferDateTimeStart.year}';
          String transferTimeStart =
              '${transferDateTimeStart.hour}:${transferDateTimeStart.minute}';

          int transferChange = 1;
          (transferHours >= 8 && transferHours <= 20)
              ? transferChange = 1
              : transferChange = 2;

          final transferAnalyticsModel = TransferAnalyticsModel(
            id: transfer.id,
            number: '${transfer.transferDTO?.number}',
            name: transfer.transferDTO?.name ?? '',
            timePlan: transfer.transferDTO?.timesh ?? 0,
            //TimeConverter.instance.convertTimeFromMinutes(transfer.transferDTO?.timesh ?? 0),
            areaNumber: value.first.area.number,
            code:
            '${value.first.batch.code}.${value.first.operation.code}.${transfer.transferDTO?.code}',
            fio: value.first.user?.fio ?? '',
            dateEnd: transferDateEnd,
            timeEnd: transferTimeEnd,
            dateStart: transferDateStart,
            timeStart: transferTimeStart,
            change: transferChange,
            machineName: value.first.machine?.name ?? '',
            machineInventoryNumber: value.first.machine?.inventoryNumber ?? 0,
            timeFact: transfer.timeworking ?? 0,
            // TimeConverter.instance.convertTimeFromSeconds(transfer.timeworking ?? 0),
            unitNumber: value.first.distributionStage?.unit?.number ?? '',
          );

          transfersAnalyticsModelsList.add(transferAnalyticsModel);
        }

      }

      analyticsOperation.transfersList = transfersAnalyticsModelsList;

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

  Future<void> fetchGroupedReadyOperations() async {
    List<TotalNumberReadyOperationModel> totalNumberReadyOperationModelsList =
        [];

    int start = timeStart.millisecondsSinceEpoch;
    int end = timeEnd.millisecondsSinceEpoch + 86399000;

    List<OperatorOperations> operatorOperationsList = [];

    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnAreaOrderedByBatch(_areasIdsList);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = convertOperationDtoToModel(dto: operationDto);

      if ((operation.timeFirstStart >= start &&
          operation.timeFirstStart <= end)) {
        operatorOperationsList.add(operation);
      }
    }

    var batchesMap =
        groupBy(operatorOperationsList, (operation) => operation.batch.id);

    batchesMap.forEach((key, value) {
      var operationsMap = groupBy(value, (operation) => operation.operation.id);

      operationsMap.forEach((key, value) {
        final totalNumberReadyOperationModel = TotalNumberReadyOperationModel(
            stageNumber:
                '${value.first.batch.order?.number}.${value.first.batch.number}.${value.first.stage.number}',
            planNumber: value.first.batch.numberRS,
            code: '${value.first.batch.code}.${value.first.operation.code}',
            unitNumber: value.first.distributionStage?.unit?.number ?? '',
            operationName:
                '${value.first.operation.number} ${value.first.operation.name}',
            areaNumber: value.first.area.number,
            planName: value.first.batch.name);

        for (var operation in value) {
          totalNumberReadyOperationModel.totalQuantity++;
          switch (operation.status.id) {
            case 4:
              totalNumberReadyOperationModel.modificationQuantity++;
            case 5:
              totalNumberReadyOperationModel.defectQuantity++;
          }
        }

        totalNumberReadyOperationModelsList.add(totalNumberReadyOperationModel);
      });
    });

    print('перед эмитом');
    emit(state.copyWith(
        totalNumberReadyOperationModelsList:
            totalNumberReadyOperationModelsList));
  }

  Future<void> uploadReadyOperationsReport() async {
    await fetchReadyOperations();

    var areasMap = groupBy(
        state.analyticsOperationsList, (operation) => operation.areaNumber);

    String filterAreasNumbersString = '';

    areasMap.forEach((key, value) {
      filterAreasNumbersString = '$filterAreasNumbersString $key';
    });



    _uploadReportsService.uploadReadyOperationsReportWithStringFilter(
        analyticsOperationsModelsList: state.analyticsOperationsList,
        filterAreasNumbersString: filterAreasNumbersString,
        filterUnitsNumbersString:
            state.analyticsOperationsList.first.unitNumber,
        timeEnd: timeEnd,
        timeStart: timeStart);
  }

  Future<void> uploadTotalNumberReadyOperationsReport(
      BuildContext context) async {
    await fetchGroupedReadyOperations();

    var areasMap = groupBy(state.totalNumberReadyOperationModelsList,
        (operation) => operation.areaNumber);

    String filterAreasNumbersString = '';

    areasMap.forEach((key, value) {
      filterAreasNumbersString = '$filterAreasNumbersString $key';
    });

    _uploadReportsService
        .uploadTotalNumberReadyOperationsReportWithStringFilter(
            totalNumberReadyOperationModelsList:
                state.totalNumberReadyOperationModelsList,
            filterAreasNumbersString: filterAreasNumbersString,
            filterUnitsNumbersString:
                state.totalNumberReadyOperationModelsList.first.unitNumber,
            timeStart: timeStart,
            timeEnd: timeEnd);

    // var filterTimeStart =
    // DateTime.fromMillisecondsSinceEpoch(timeStart.millisecondsSinceEpoch);
    //
    // String dateStart =
    //     '${filterTimeStart.day}.${filterTimeStart.month}.${filterTimeStart
    //     .year}';
    //
    // var filterTimeEnd =
    // DateTime.fromMillisecondsSinceEpoch(timeEnd.millisecondsSinceEpoch);
    //
    // String dateEnd =
    //     '${filterTimeEnd.day}.${filterTimeEnd.month}.${filterTimeEnd.year}';
    //

    //
    // final filtersInfoModel = FiltersInfoModel(
    //     timeStart: dateStart,
    //     timeEnd: dateEnd,
    //     unitsNumbersList:
    //     state.totalNumberReadyOperationModelsList.first.unitNumber,
    //     areasNumbersList: filterAreasNumbersString);
    //
    // print('перед выводом ${state.totalNumberReadyOperationModelsList}');
    //
    // String filePath =
    // await _excelService.uploadTotalNumberReadyOperationsReport(
    //     filtersInfo: filtersInfoModel,
    //     totalNumberReadyOperationModelsList:
    //     state.totalNumberReadyOperationModelsList);
    // if (filePath == '') {
    //   filePath = 'что-то пошло не так';
    // } else {
    //   filePath =
    //   '$filePath/Отчет суммарного количества выполненных операций (${filtersInfoModel
    //       .timeStart} - ${filtersInfoModel.timeEnd}).xlsx';
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
          fio: dto.staff?.fio ?? 'empty',
          positionId: dto.staff?.positionId ?? 0,
          companyId: 0,
          unitId: 0,
          areaId: 0,
          photo: '',
          company: Company(id: 0, name: '', code: ''),
          position: Position(
              id: dto.staff?.position.id ?? 0,
              name: dto.staff?.position.name ?? ''),
        ),
        machine: Machine(
            id: 0,
            isActivated: dto.machine?.isActivated ?? false,
            inventoryNumber: dto.machine?.inventoryNumber ?? 0,
            name: dto.machine?.name ?? 'empty_machine_name',
            areaId: 0),
        timeFirstStart: dto.timeFirstStart ?? 0,
        comment: dto.comment,
        status: Status(id: dto.status.id, name: dto.status.name),
        batch: Batch(
            id: dto.batch.id,
            numberRS: dto.batch.numberRS,
            name: dto.batch.name,
            number: dto.batch.number,
            count: dto.batch.count,
            code: dto.batch.code,
            technology: dto.batch.technology,

            order: Order(
                id: dto.batch.order?.id ?? 0,
                number: dto.batch.order?.number ?? '',
                priority: dto.batch.order?.priority ?? 0,
                statusId: dto.batch.order?.statusId ?? 0),
            orderId: dto.batch.orderId),
        stage: dto.stage ?? StageDTO.empty,
        distributionStage: DistributionStage(
            id: dto.distributionStageDto?.id ?? 0,
            chiefBatchId: dto.distributionStageDto?.chiefBatchId ?? 0,
            unit: Unit(
                id: dto.distributionStageDto?.unitDto?.id ?? 0,
                name: dto.distributionStageDto?.unitDto?.name,
                number: dto.distributionStageDto?.unitDto?.number,
                companyId: dto.distributionStageDto?.unitDto?.companyId ?? 0),
            stageId: dto.distributionStageDto?.stageId ?? 0,
            statusId: dto.distributionStageDto?.statusId ?? 0),
        operation: dto.operation,
        area: dto.area ?? AreaDTO(id: 0, name: '', number: '', unitId: 0));
  }
}
