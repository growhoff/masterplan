import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
import '../../../../../../data/repositories/supabase/dto/position_staff_dto.dart';
import '../../../../../../domain/model/operator_operations.dart';
import '../../../../../../domain/model/position_staff.dart';

part 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  AnalyticsCubit(this.staffId) : super(AnalyticsState());

  final _operatorOperationsTable = OperatorOperationsTable();
  final _positionStaffTable = PositionStaffTable();
  final _excelService = ExcelService();
  final int staffId;

  Future<void> fetchReadyOperations() async {
    List<AnalyticsOperationModel> analyticsOperationsList = [];

    Map<int, AnalyticsOperationModel> operationsMap = {};

    List<int> areasList = [];

    var fetchedList = await _positionStaffTable.selectByStaffId(staffId: staffId);
    for (var fetchedStaff in fetchedList){
      final positionStaffDto = PositionStaffDTO.fromMap(fetchedStaff);
      final positionStaff = PositionStaffModel.fromDTO(positionStaffDto);
      areasList.add(positionStaff.areaId ?? 0);
    }

    var fetchedOperationsList =
        await _operatorOperationsTable.selectReadyDefectAndModificationOnArea(areasList);

    for (var fetchedOperation in fetchedOperationsList) {
      final operationDto = OperatorOperationsDTO.fromMap(fetchedOperation);

      final operation = convertOperationDtoToModel(dto: operationDto);

      if (!operationsMap.containsKey(operation.operation.id)) {
        var hours =
            DateTime.fromMillisecondsSinceEpoch(operation.timestop ?? 0).hour;

        int change = 1;
        (hours >= 8 && hours <= 20) ? change = 1 : change = 2;

        operationsMap[operation.operation.id] = AnalyticsOperationModel(
            operationId: operation.operation.id,
            code: operation.operation.code,
            detailNumber: operation.batch.number,
            operationNumber: operation.operation.number,
            name: operation.operation.name,
            timePlan: TimeConverter.instance
                .convertTimeFromMinutes(operation.timeplan),
            timeFact: TimeConverter.instance
                .convertTimeFromSeconds(operation.timeworking ?? 0),
            machineName: operation.machine?.name ?? '',
            machineInventoryNumber: operation.machine?.inventoryNumber ?? 0,
            fio: operation.user?.fio ?? '',
            date: DateFormat.yMd().format(
                DateTime.fromMillisecondsSinceEpoch(operation.timestop ?? 0)),
            change: change,
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
        timeFirstStart: dto.timeFirstStart ?? 0,
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
            orderId: dto.batch.orderId),
        stage: dto.stage ?? StageDTO.empty,
        operation: dto.operation,
        area: dto.area ?? AreaDTO(id: 0, name: '', number: '', unitId: 0));
  }
}
