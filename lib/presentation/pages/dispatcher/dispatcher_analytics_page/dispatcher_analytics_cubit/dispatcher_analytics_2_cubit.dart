import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/transfer_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/unit.dart';
import 'package:master_plan/domain/usecase/upload_reports_service.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';

part 'dispatcher_analytics_2_state.dart';

class DispatcherAnalytics2Cubit extends Cubit<DispatcherAnalytics2State> {
  DispatcherAnalytics2Cubit() : super(DispatcherAnalytics2InitialState()) {
    _init();
  }

  final _unitTable = UnitTable();
  final _areaTable = AreaTable();
  final _transferOperationsTable = TransferOperationsTable();
  final _operatorOperationsTable = OperatorOperationsTable();

  final _uploadReportsService = UploadReportsService();

  void _init() async {
    //методы при инициализации страницы
    await fetchUnits();
    fetchAreas();
  }

  List<Unit> unitsList = [];
  List<Area> areasList = [];

  DateTime timeStart = DateTime.now();
  DateTime timeEnd = DateTime.now();

  Unit selectedUnit = Unit(id: 0, name: 'Все', number: '', companyId: 0);
  Area selectedArea =
      Area(id: 0, name: 'все в выбранном цехе', number: '', unitId: 0);

  Future fetchUnits() async {
    List<Unit> _unitsList = [];

    var fetchedUnitsList = await _unitTable.select();

    for (var fetchedUnit in fetchedUnitsList) {
      final unitDto = UnitDTO.fromMap(fetchedUnit);

      final unit = Unit.fromDTO(unitDto);

      _unitsList.add(unit);
    }

    unitsList = _unitsList;
    unitsList.insert(0, Unit(id: 0, name: 'Все', number: '', companyId: 0));
    selectedUnit = unitsList.first;
  }

  Future fetchAreas() async {
    List<int> unitsIdsList = [];

    if (selectedUnit.id == 0) {
      for (final unit in unitsList) {
        unitsIdsList.add(unit.id);
      }
    } else {
      unitsIdsList.add(selectedUnit.id);
    }

    final fetchedAreasList =
        await _areaTable.selectByUnitIdListDTO(unitsIdsList);

    print('fetched areas list : ${fetchedAreasList}');

    areasList = fetchedAreasList;

    areasList.insert(
        0,
        Area(
          id: 0,
          name: 'Все в выбранном цеху',
          number: '',
          unitId: 0,
        ));

    selectedArea = areasList.first;
    print('selected area : ${selectedArea.name}');
  }

  String getDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<List<AnalyticsOperationModel>> fetchReadyOperations() async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    List<OperatorOperations> operatorOperationsList = [];

    List<TransferAnalyticsModel> transfersAnalyticsModelsList = [];

    List<TransferOperationsDTO> transferOperationsList = [];

    List<int> operatorOperationsIdsList = [];

    List<int> areasIdsList = getIdsListFromAreasList(selectedArea.id == 0? areasList : [selectedArea]);

    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnArea(areasIdsList);

    int start = timeStart.millisecondsSinceEpoch;
    int end = timeEnd.millisecondsSinceEpoch + 86399000;

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = OperatorOperations.fromDTO(dto: operationDto);

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

    return analyticsOperationsList;
  }

  openUnitsFilter() {
    emit(DispatcherAnalyticsSelectUnitState(
      unitsList: unitsList,
    ));
  }

  openAreasFilter() {
    emit(DispatcherAnalyticsSelectAreaState(
      areasList: areasList,
    ));
  }

  openDateFilter() {
    emit(DispatcherAnalyticsSelectDateState());
  }

  selectUnit(Unit? unit) async {
    selectedUnit = unit ?? Unit.empty;
    await fetchAreas();
    emit(DispatcherAnalyticsSelectedUnitState(selectedUnit: selectedUnit));
  }

  selectArea(Area? area) {
    selectedArea = area ?? Area.empty;
    emit(DispatcherAnalyticsSelectedAreaState(selectedArea: selectedArea));
  }

  selectDate() {
    emit(DispatcherAnalyticsSelectedDateState());
  }

  uploadReadyOperationsReport() async {

    emit(DispatcherAnalyticsUploadReadyOperationsReportState());

    final operationsList = await fetchReadyOperations();

    _uploadReportsService.uploadReadyOperationsReport(
        analyticsOperationsModelsList: operationsList,
        areasList: [selectedArea],
        unitsList: [selectedUnit],
        timeStart: timeStart,
        timeEnd: timeEnd);

    emit(DispatcherAnalyticsUploadedReadyOperationsReportState());
  }

  List<int> getIdsListFromAreasList(List<Area> areasList) {
    List<int> areasIdsList = [];
    for (var area in areasList) {
      areasIdsList.add(area.id);
    }
    return areasIdsList;
  }
}
