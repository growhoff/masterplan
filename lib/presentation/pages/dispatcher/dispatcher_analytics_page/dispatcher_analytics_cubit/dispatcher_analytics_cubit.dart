import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/local/dto/filters_info_model.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';
import 'package:master_plan/domain/usecase/staff_service.dart';
import 'package:master_plan/domain/usecase/upload_reports_service.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../data/repositories/local/service/excel_service.dart';
import '../../../../../data/repositories/local/service/notification_service.dart';
import '../../../../../data/repositories/supabase/dto/area_dto.dart';
import '../../../../../data/repositories/supabase/dto/operator_operations_dto.dart';
import '../../../../../data/repositories/supabase/dto/stage_dto.dart';
import '../../../../../data/repositories/supabase/service/operator_operations_table.dart';
import '../../../../../domain/model/area.dart';
import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/company.dart';
import '../../../../../domain/model/machine.dart';
import '../../../../../domain/model/operator_operations.dart';
import '../../../../../domain/model/order.dart';
import '../../../../../domain/model/position.dart';
import '../../../../../domain/model/staff.dart';
import '../../../../../domain/model/status.dart';
import '../../../../../domain/model/unit.dart';
import '../../../../../domain/model/user.dart';
import '../../../../../domain/usecase/time_converter.dart';
import '../../../master/pages/analytics_page/analytics_operation_model.dart';

part 'dispatcher_analytics_state.dart';

class DispatcherAnalyticsCubit extends Cubit<DispatcherAnalyticsState> {
  DispatcherAnalyticsCubit() : super(DispatcherAnalyticsState());

  final _uploadReportsService = UploadReportsService();

  final _operatorOperationsTable = OperatorOperationsTable();
  final _transferOperationsTable = TransferOperationsTable();
  final _unitTable = UnitTable();
  final _areaTable = AreaTable();

  List<Area> selectedAreasList = [];
  List<Unit> selectedUnitsList = [];

  Area selectedArea = Area.empty;
  Unit selectedUnit = Unit.empty;

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  Future fetchUnits() async {
    List<Unit> unitsList = [];

    var fetchedUnitsList = await _unitTable.select();

    for (var fetchedUnit in fetchedUnitsList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);

      final unit = Unit.fromDTO(unitDto);

      unitsList.add(unit);
    }

    selectedUnitsList = unitsList;

    selectedAreasList = state.areasList;
    unitsList.insert(0, Unit(id: 0, name: 'Все', number: '', companyId: 0));
    selectedUnit = unitsList.first;

    unitsList.forEach((unit) => print('unit number: ${unit.number}'));
    emit(state.copyWith(unitsList: unitsList));
    await fetchAreas();
  }

  Future fetchAreas() async {
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.loading));
    List<Area> areasList = [];

    var fetchedAreasList = [];
    if (selectedUnit.name == 'Все' || selectedUnit.name == '') {
      fetchedAreasList = await _areaTable.selectAll();
    } else {
      fetchedAreasList = await _areaTable.selectByUnitIdList([selectedUnit.id]);
    }

    for (var fetchedArea in fetchedAreasList) {
      final areaDto = AreaDTO.fromMap(fetchedArea);
      final area = Area.fromDTO(areaDto);
      areasList.add(area);
    }

    selectedAreasList = areasList;

    areasList.insert(
        0, Area(id: 0, name: 'Все в выбранных цехах', number: '', unitId: 0));

    selectedArea = areasList.first;

    emit(state.copyWith(
        areasList: areasList, status: DispatcherAnalyticsStateStatus.success));
  }

  addSelectedAreaToList(Area area) {
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.loading));

    selectedAreasList = [];
    selectedArea = area;
    if (area.id == 0) {
      List<Area> areasList = state.areasList.skip(1).toList();
      selectedAreasList = areasList;
    } else {
      selectedAreasList.add(area);
    }
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.success));
  }

  changeSelectedUnit(Unit unit) async {
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.loading));
    selectedUnitsList = [];
    selectedUnit = unit;
    if (unit.id == 0) {
      List<Unit> unitsList = state.unitsList.skip(1).toList();
      selectedUnitsList = unitsList;
    } else {
      selectedUnitsList.add(unit);
    }

    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.success));
  }

  List<int> getIdsListFromAreasList(List<Area> areasList) {
    List<int> areasIdsList = [];
    for (var area in areasList) {
      areasIdsList.add(area.id);
    }
    return areasIdsList;
  }

  Future deleteBatch() async {
    print('удалили');
  }

  Future<void> fetchReadyOperations() async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    List<OperatorOperations> operatorOperationsList = [];

    List<TransferAnalyticsModel> transfersAnalyticsModelsList = [];

    List<TransferOperationsDTO> transferOperationsList = [];

    List<int> operatorOperationsIdsList = [];

    List<int> areasIdsList = getIdsListFromAreasList(selectedAreasList);

    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnArea(areasIdsList);

    int start = timeStart.millisecondsSinceEpoch;
    int end = timeEnd.millisecondsSinceEpoch + 86399000;

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

      AnalyticsOperationModel analyticsOperation = AnalyticsOperationModel(
          unitNumber: value.first.distributionStage?.unit?.number ?? '',
          batch: value.first.batch,
          stage: value.first.stage,
          operationId: value.first.operation.id,
          code: '${value.first.batch.code}.${value.first.operation.code}',
          comment: value.first.comment ?? '',
          detailNumber: value.first.batch.numberRS,
          operationNumber: value.first.operation.number,
          operationName: value.first.operation.name,
          timePlan: value.first.timeplan,
          //TimeConverter.instance.convertTimeFromMinutes(value.first.timeplan),
          timeFact: value.first.timeworking ?? 0,
          //TimeConverter.instance.convertTimeFromSeconds(value.first.timeworking ?? 0),
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

    List<OperatorOperations> operatorOperationsList = [];

    List<int> areasIdsList = getIdsListFromAreasList(selectedAreasList);

    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnAreaOrderedByBatch(areasIdsList);

    int start = timeStart.millisecondsSinceEpoch;
    int end = timeEnd.millisecondsSinceEpoch + 86399000;

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
        // print('operation code : ${value.first.operation.code}');
        //print('batch code : ${value.first.batch.code}');

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

    var areasMap = groupBy(totalNumberReadyOperationModelsList,
        (operation) => operation.areaNumber);

    List<TotalNumberReadyOperationModel> finalOperationsList = [];
    areasMap.forEach((key, value) {
      finalOperationsList.addAll(value);
      finalOperationsList.add(TotalNumberReadyOperationModel(
          stageNumber: '',
          planNumber: '',
          code: '',
          unitNumber: '',
          operationName: '',
          areaNumber: '',
          planName: ''));
    });

    totalNumberReadyOperationModelsList
        .sortBy((operation) => operation.areaNumber);

    print('перед эмитом');
    emit(state.copyWith(
        totalNumberReadyOperationModelsList: finalOperationsList));
  }

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

  Future<void> uploadReadyOperationsReport() async {
    await fetchReadyOperations();

    _uploadReportsService.uploadReadyOperationsReport(
        analyticsOperationsModelsList: state.analyticsOperationsList,
        areasList: selectedAreasList,
        unitsList: selectedUnitsList,
        timeStart: timeStart,
        timeEnd: timeEnd);
  }

  Future<void> uploadTotalNumberReadyOperationsReport() async {
    await fetchGroupedReadyOperations();

    _uploadReportsService.uploadTotalNumberReadyOperationsReport(
        totalNumberReadyOperationModelsList:
            state.totalNumberReadyOperationModelsList,
        areasList: selectedAreasList,
        unitsList: selectedUnitsList,
        timeStart: timeStart,
        timeEnd: timeEnd);
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
