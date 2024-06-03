import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:master_plan/data/repositories/local/service/excel_service.dart';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/operator_operations_table.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_operation_model.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../../data/repositories/local/service/notification_service.dart';
import '../../../../../../domain/model/operator_operations.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit() : super(AnalyticsState());

  final _operatorOperationsTable = OperatorOperationsTable();
  final _excelService = ExcelService();

  Future<void> fetchReadyOperations() async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    Map<int, AnalyticsOperationModel> operationsMap = {};

    var fetchedOperationsList =
        await _operatorOperationsTable.selectReadyDefectAndModification();

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = convertOperationDtoToModel(dto: operationDto);

      if (!operationsMap.containsKey(operation.operation.id)) {
        operationsMap[operation.operation.id] = AnalyticsOperationModel(
            operationId: operation.operation.id,
            code: operation.operation.code,
            detailNumber: operation.batch.number,
            operationNumber: operation.operation.number,
            name: operation.operation.name,
            timePlan: DateTime.fromMillisecondsSinceEpoch(operation.timeplan ).toString(),
            timeFact: DateTime.fromMillisecondsSinceEpoch(operation.timefact ).toString(),
            machineName: operation.machine?.name ?? '',
            machineInventoryNumber: operation.machine?.inventoryNumber ?? 0,
            fio: operation.user?.fio ?? '',
            date: DateTime.fromMillisecondsSinceEpoch(operation.timestop ?? 0 ).toString(),
            change: 0,
            areaNumber: operation.area.number);
      }
      operationsMap[operation.operation.id]?.quantity++;

      switch (operation.status.id) {
        case 4:
          operationsMap[operation.operation.id]?.modificationQuantity++;
        case 5:
          operationsMap[operation.operation.id]?.defectQuantity++;
      }
    }

    operationsMap.forEach((key, value) {
      analyticsOperationsList.add(value);
    });

    emit(state.copyWith(analyticsOperationsList: analyticsOperationsList));
  }

  Future<void> uploadReadyOperationsReport() async {
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

  OperatorOperations convertOperationDtoToModel(
      {required OperatorOperationsDTO dto}) {
    return OperatorOperations(
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
            inventoryNumber: dto.machine?.inventoryNumber ?? 0,
            name: dto.machine?.name ?? 'empty_machine_name',
            areaId: 0),
        timefact: dto.timefact ?? 0,
        status: Status(id: dto.status.id, name: dto.status.name),
        batch: Batch(
            id: dto.batch.id,
            number: dto.batch.number,
            name: dto.batch.name,
            count: dto.batch.count,
            code: dto.batch.code,
            technology: dto.batch.technology,
            order: dto.batch.order,
            isready: dto.batch.isready,
            packageId: dto.batch.packageId),
        stage: dto.stage ?? StageDTO.empty,
        operation: dto.operation,
        area: dto.area ?? AreaDTO(id: 0, name: '', number: '', unitId: 0));
  }
}
