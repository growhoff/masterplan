import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/area_table.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
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
import '../../../../../domain/model/status.dart';
import '../../../../../domain/model/unit.dart';
import '../../../../../domain/model/user.dart';
import '../../../../../domain/usecase/time_converter.dart';
import '../../../master/pages/analytics_page/analytics_operation_model.dart';

part 'dispatcher_analytics_state.dart';

class DispatcherAnalyticsCubit extends Cubit<DispatcherAnalyticsState> {
  DispatcherAnalyticsCubit() : super(DispatcherAnalyticsState());

  final _operatorOperationsTable = OperatorOperationsTable();
  final _excelService = ExcelService();
  final _unitTable = UnitTable();
  final _areaTable = AreaTable();

  List<Area> selectedAreasList = [];

  Unit selectedUnit = Unit.empty;

  Area selectedArea = Area.empty;

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

    selectedUnit = unitsList.first;
    selectedAreasList = state.areasList;

    emit(state.copyWith(unitsList: unitsList));
  }

  addSelectedAreaToList(){
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.loading));
    selectedAreasList = [];
    selectedAreasList.add(selectedArea);
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.success));
  }

  changeSelectedUnit(Unit unit)async{
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.loading));
    selectedUnit = unit;
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.success));
  }

   pressAreasButton() {

    selectedArea = state.areasList.first;
    print('press: ${selectedArea.name}');
    selectedAreasList = [];
    selectedAreasList.add(selectedArea);
  }

  List<int> getIdsListFromAreasList(List<Area> areasList) {
    List<int> areasIdsList = [];
    for (var area in areasList) {
      areasIdsList.add(area.id);
    }
    return areasIdsList;
  }

  Future fetchAreas() async {
    emit(state.copyWith(status: DispatcherAnalyticsStateStatus.loading));
    List<Area> areasList = [];

    var fetchedAreasList = selectedUnit.id != 0
        ? await _areaTable.selectUnitId(selectedUnit.id)
        : await _areaTable.selectAll();

    for (var fetchedArea in fetchedAreasList) {
      final areaDto = AreaDTO.fromMap(fetchedArea);
      final area = Area.fromDTO(areaDto);
      areasList.add(area);
    }

    selectedAreasList = areasList;
    print(selectedAreasList);

    emit(state.copyWith(
        areasList: areasList, status: DispatcherAnalyticsStateStatus.success));
  }

  Future deleteBatch()async{
    print('удалили');
  }

  Future<void> fetchReadyOperations() async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    List<OperatorOperations> operatorOperationsList = [];

    List<int> areasIdsList = getIdsListFromAreasList(selectedAreasList);

    var fetchedOperationsList = await _operatorOperationsTable
        .selectReadyDefectAndModificationOnArea(areasIdsList);

    int start = timeStart.millisecondsSinceEpoch;
    int end = timeEnd.millisecondsSinceEpoch + 86399000;

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = convertOperationDtoToModel(dto: operationDto);




      print(
          'start: ${timeStart}  operation: ${operation.timeFirstStart} end: ${timeEnd}');
      if ((operation.timeFirstStart >= start &&
          operation.timeFirstStart <= end)) {
        operatorOperationsList.add(operation);
      }
        }

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
          operationId: value.first.operation.id,
          code: '${value.first.batch.code}.${value.first.operation.code}',
          comment: value.first.comment ?? '',
          detailNumber: value.first.batch.numberRS,
          operationNumber: value.first.operation.number,
          operationName: value.first.operation.name,
          timePlan: TimeConverter.instance
              .convertTimeFromMinutes(value.first.timeplan),
          timeFact: TimeConverter.instance
              .convertTimeFromSeconds(value.first.timeworking ?? 0),
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
    List<AnalyticsOperationModel> analyticsOperationsList = [];

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

        print(
            'start: ${timeStart}  operation: ${operation.timeFirstStart} end: ${timeEnd}');
      }
        }

    var batchesMap =
        groupBy(operatorOperationsList, (operation) => operation.batch.id);

    batchesMap.forEach((key, value) {
      var operationsMap = groupBy(value, (operation) => operation.operation.id);

      operationsMap.forEach((key, value) {
        print('operation code : ${value.first.operation.code}');
        print('batch code : ${value.first.batch.code}');
        final analyticsOperation = AnalyticsOperationModel(
            batch: value.first.batch,
            stage: value.first.stage,
            operationId: 0,
            code: value.first.operation.code,
            comment: '',
            detailNumber: value.first.batch.numberRS,
            detailName: value.first.batch.name,
            operationNumber: value.first.operation.number,
            operationName: value.first.operation.name,
            timePlan: '',
            timeFact: '',
            machineName: '',
            machineInventoryNumber: 0,
            fio: '',
            dateStart: '',
            dateEnd: '',
            timeStart: '',
            timeEnd: '',
            change: 0,
            areaNumber: '');

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
    });

    for (var op in analyticsOperationsList) {
      print(op.operationName);
    }

    print('перед эмитом');
    emit(state.copyWith(analyticsOperationsList: analyticsOperationsList));
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

  String getDate(DateTime date){
    return '${date.day}.${date.month}.${date.year}';
  }

  Future<void> uploadReadyOperationsReport() async {
    print(timeStart);
    print(timeEnd);

    await fetchReadyOperations();

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

  Future<void> uploadTotalNumberReadyOperationsReport() async {
    await fetchGroupedReadyOperations();

    String filePath =
        await _excelService.uploadTotalNumberReadyOperationsReport(
            analyticsOperationsList: state.analyticsOperationsList);
    if (filePath == '') {
      filePath = 'что-то пошло не так';
    } else {
      filePath =
          '$filePath/Отчет суммарного количества выполненных операций.xlsx';
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
            isready: dto.batch.isready,
            order: Order(
                id: dto.batch.order?.id ?? 0,
                number: dto.batch.order?.number ?? '',
                priority: dto.batch.order?.priority ?? 0,
                statusId: dto.batch.order?.statusId ?? 0),
            orderId: dto.batch.orderId),
        stage: dto.stage ?? StageDTO.empty,
        operation: dto.operation,
        area: dto.area ?? AreaDTO(id: 0, name: '', number: '', unitId: 0));
  }
}
